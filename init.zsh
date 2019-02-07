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
export GI_TEMPLATE="${0:h}/.git-ignore"

path+=("${0:h}/bin" "${path[@]}")
fpath+=("${path[@]}" "${0:h}/functions")
