#!/bin/bash

set -u

sed -i 's/local auto_select = true/local autoselect = vim.g.cmp_auto_select or true/' /home/jason/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/coding.lua
cmp_auto_select_check=$(grep 'vim\.g\.cmd_auto_select[[:space:]]*=' /home/jason/.config/nvim/lua/config/options.lua)
if [[ -z $cmp_auto_select_check ]]; then
  echo "vim.g.cmp_auto_select = true" >/home/jason/.config/nvim/lua/config/options.lua
fi
