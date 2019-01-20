#
# Generate .gitignore files with templates from gitignore.io
#
# Authors:
#   laggardkernel <laggardkernel@gmail.com>
#

_gitignore_warn() { printf "%b[Warn]%b %s\\n" '\e[0;33m' '\e[0m' "$@" >&2; }
_gitignore_info() { printf "%b[Info]%b %s\\n" '\e[0;32m' '\e[0m' "$@" >&2; }

# git ignore generator
export FORGIT_GI_REPO=~/.forgit/gi/repos/dvcs/gitignore # https://github.com/dvcs/gitignore.git
export FORGIT_GI_SRC=$FORGIT_GI_REPO/templates

_gitignore_update() {
  if [[ -d "$FORGIT_GI_REPO" ]]; then
    _gitignore_info 'Updating gitignore repo...'
    (cd $FORGIT_GI_REPO && git pull --no-rebase --ff) || return 1
  else
    _gitignore_info 'Initializing gitignore repo...'
    git clone --depth=1 https://github.com/dvcs/gitignore.git "$FORGIT_GI_REPO"
  fi
}

_gitignore_clean() {
  setopt localoptions rmstarsilent
  [[ -d $FORGIT_GI_REPO ]] && rm -rf $FORGIT_GI_REPO
}

_gitignore_list() {
  command find $FORGIT_GI_SRC/* -print | sed -e 's#\.[^/]*$##' -e 's#.*/##' | sort -fu
}

_gitignore_get() {
  local item filename header stack stacks IFS=$'\t\n'
  for item in "$@"; do
    filename=$(find -L "$FORGIT_GI_SRC" -type f \( -iname "${item}.gitignore" -o -iname "${item}.stack" \) -print -quit)
    if [[ -z "$filename" ]]; then
      _gitignore_warn "No gitignore template found for '$item'." && continue
    elif [[ "$filename" == *.gitignore ]]; then
      header="${filename##*/}"
      header="${header%.gitignore}"
      echo "### $header ###"
      cat "$filename"
      echo
      if [[ -e "${filename%.gitignore}.patch" ]]; then
        echo "### $header Patch ###"
        cat "${filename%.gitignore}.patch"
        echo
      else
        stacks=($(command find -L "$FORGIT_GI_SRC" -type f -iname "${item}.*.stack" -print))
        [[ ${#stacks[@]} -ne 0 ]] && for stack in "${stacks[@]}"; do
          header="${stack##*/}"
          header="${header%.stack}"
          echo "### $header Stack ###"
          cat "$stack"
          echo
        done
      fi
    else # particularly for Code.stack
      header="${filename##*/}"
      header="${header%.stack}"
      echo "### $header ###"
      cat "$filename"
      echo
    fi
  done
}

gitignore() {
  [ -d $FORGIT_GI_REPO ] || _gitignore_update
  local IFS cmd args options opt cat
  # https://github.com/wfxr/emoji-cli
  hash bat &>/dev/null && cat='bat -l gitignore --color=always --style=numbers,grid,header' || cat="cat"
  cmd="{ $cat $FORGIT_GI_SRC/{2}{.gitignore,.patch}; $cat $FORGIT_GI_SRC/{2}*.stack } 2>/dev/null"
  # shellcheck disable=SC2206,2207
  IFS=$'\n' args=($@) && [[ $# -eq 0 ]] && args=($(_gitignore_list | nl -nrn -w4 -s'  ' |
    _gitignore_fzf -m --preview="$cmd" --preview-window="right:70%" | awk '{print $2}'))
  [ ${#args[@]} -eq 0 ] && return 1
  options=('(1) Output to stdout'
    '(2) Append to .gitignore'
    '(3) Overwrite .gitignore')
  opt=$(printf '%s\n' "${options[@]}" | _gitignore_fzf +m | awk '{print $1}')
  # shellcheck disable=SC2068
  case "$opt" in
  '(1)')
    if hash bat &>/dev/null; then
      _gitignore_get ${args[@]} | bat -l gitignore --style=numbers,grid
    else
      _gitignore_get ${args[@]}
    fi
    ;;
  '(2)')
    ! [[ -e .gitignore ]] && touch .gitignore
    _gitignore_get ${args[@]} >>.gitignore
    ;;
  '(3)')
    _gitignore_get ${args[@]} >|.gitignore
    ;;
  esac
}

_gitignore_fzf() {
  FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --ansi
    --height '80%'
    --bind='alt-k:preview-up,alt-p:preview-up'
    --bind='alt-j:preview-down,alt-n:preview-down'
    --bind='ctrl-r:toggle-all'
    --bind='ctrl-s:toggle-sort'
    --bind='?:toggle-preview'
    --preview-window='right:60%'
    --bind='alt-w:toggle-preview-wrap'
    " fzf "$@"
}