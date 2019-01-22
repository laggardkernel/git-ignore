#!/usr/bin/env zsh
# Standardized $0 handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

source "${0:h}/init.zsh"
