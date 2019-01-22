#
# Copyright 2019, laggardkernel and the git-ignore contributors
# SPDX-License-Identifier: MIT

# Generate .gitignore files with templates from gitignore.io
#
# Authors:
#   laggardkernel <laggardkernel@gmail.com>
#

# Standardized $0 handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

# Define default confs.
typeset -gA GITIGNORE_OPTS
: "${GITIGNORE_OPTS[gitignore]:=${0:h}/.git-ignore}"
: "${GITIGNORE_OPTS[bat_preview]:="-l gitignore --color=always --style=grid,header,numbers"}"

if (( $+commands[bat] )); then
  _gitignore_colorize() { bat -l gitignore --style=grid,header,numbers "$@"; }
  GITIGNORE_OPTS[preview_cmd]="bat ${GITIGNORE_OPTS[bat_preview]}"
else
  _gitignore_colorize() { cat "$@"; }
  GITIGNORE_OPTS[preview_cmd]="cat"
fi

_gitignore_info() { printf "%b[Info]%b %s\\n" '\e[0;32m' '\e[0m' "$@" >&2; }

_gitignore_update() {
  if [[ -d "${GITIGNORE_OPTS[gitignore]}" ]]; then
    _gitignore_info 'Updating gitignore repo...'
    (cd "${GITIGNORE_OPTS[gitignore]}" && git pull --no-rebase --ff) || return 1
  else
    _gitignore_info 'Initializing gitignore repo...'
    git clone --depth=1 https://github.com/dvcs/gitignore.git "${GITIGNORE_OPTS[gitignore]}"
  fi
}

_gitignore_clean() {
  [[ -d "${GITIGNORE_OPTS[gitignore]}" ]] && rm -rf "${GITIGNORE_OPTS[gitignore]}"
}

_gitignore_list() {
  local ng=0, ncm=0, IFS=$'\n'
  local -a templates
  [[ -o nullglob ]] && ng=1 || setopt nullglob
  [[ -o nocasematch ]] && ncm=1 || setopt nocasematch

  templates=("${GITIGNORE_OPTS[gitignore]}"/templates/*{.gitignore,.patch,.stack})
  templates=("${templates[@]##*/}"); templates=("${templates[@]%%.*}");
  templates=("${(u)templates[@]}")
  <<< "${templates[@]}" sort -fu

  [[ $ng = 1 ]] || unsetopt nullglob
  [[ $ncm = 1 ]] || unsetopt nocasematch
}

_gitignore_get() {
  local header
  local ng=0, ncg=0
  [[ -o nullglob ]] && ng=1 || setopt nullglob
  [[ -o nocaseglob ]] && ncg=1 || setopt nocaseglob

  for item in "$@"; do
    # Be careful of the trivial case: Code.stack
    for template in "${GITIGNORE_OPTS[gitignore]}"/templates/${item}{.gitignore*,.patch*,*stack}; do
      if [[ "$template" == *.gitignore ]]; then
        header="${template##*/}"; header="${header%.gitignore}"
        echo "### $header ###"
        cat "$template"
        echo ""
      elif [[ "$template" == *.patch ]]; then
        header="${template##*/}"; header="${header%.patch}"
        echo "### $header Patch ###"
        cat "$template"
        echo ""
      else
        header="${template##*/}"; header="${header%.stack}"
        echo "### $header Stack ###"
        cat "$template"
        echo ""
      fi
    done
  done

  [[ $ng = 1 ]] || unsetopt nullglob
  [[ $ncg = 1 ]] || unsetopt nocaseglob
}

gitignore() {
  [ -d "${GITIGNORE_OPTS[gitignore]}" ] || _gitignore_update

  local IFS=$'\n' preview_cmd choice
  local -a args menu
  preview_cmd="{ ${GITIGNORE_OPTS[preview_cmd]} ${GITIGNORE_OPTS[gitignore]}/templates/{2}{.gitignore,.patch}; ${GITIGNORE_OPTS[preview_cmd]} ${GITIGNORE_OPTS[gitignore]}/templates/{2}*.stack } 2>/dev/null"
  # shellcheck disable=SC2206,2207
  if [[ $# -eq 0 ]]; then
    args=($(_gitignore_list | nl -nrn -w4 -s'  ' |
      _gitignore_fzf -m --preview="$preview_cmd" --preview-window="right:70%" |
      cat
    ))

    [[ ${#args[@]} -eq 0 ]] && return 1 || args=(${args[@]##* })

    menu=('1) Output to stdout'
          '2) Append to .gitignore'
          '3) Overwrite .gitignore')
    choice=$(<<< "${menu[@]}" _gitignore_fzf +m)
    # shellcheck disable=SC2068
    case "$choice" in
    1*)
      _gitignore_get "${args[@]}" | _gitignore_colorize
      ;;
    2*)
      [[ -e ./.gitignore ]] || touch ./.gitignore
      _gitignore_get "${args[@]}" >> ./.gitignore
      ;;
    3*)
      _gitignore_get "${args[@]}" >| ./.gitignore
      ;;
    esac
  else
    _gitignore_get "$@" | _gitignore_colorize
  fi
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

_gitignore () {
  local templates IFS=$'\t\n'
  # unquote variable expansion on purpose to remove empty lines
  templates=(${(f)"$(_gitignore_list)"}); templates=("${templates[@]:l}")
  compset -P '*,'
  compadd -S '' "${templates[@]}"
}

compdef _gitignore gitignore
