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

# source "${0:h}/bin/git-ignore"
path+=("${0:h}/bin" "${path[@]}")
# fpath+=("${path[@]}" "${0:h}/function")

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

_gitignore_compdef() {
  local templates IFS=$'\t\n'
  # unquote variable expansion on purpose to remove empty lines
  templates=(${(f)"$(_gitignore_list)"}); templates=("${templates[@]:l}")
  compset -P '*,'
  compadd -S '' "${templates[@]}"
}
compdef _gitignore_compdef "git-ignore"
