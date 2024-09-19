#!/bin/bash

set -u

sed -i 's/local auto_select = true/local autoselect = vim.g.cmp_auto_select or true/' /home/jason/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/coding.lua
cmp_auto_select_check=$(grep 'vim\.g\.cmd_auto_select[[:space:]]*=' /home/jason/.config/nvim/lua/config/options.lua)
if [[ -z $cmp_auto_select_check ]]; then
  echo "vim.g.cmp_auto_select = true" >/home/jason/.config/nvim/lua/config/options.lua
fi

iter_line_nbr=$(grep -n '    iter(yaml.dumps_lines(frontmatter_, function(a, b)' /home/jason/.local/share/nvim/lazy/obsidian.nvim/lua/obsidian/note.lua | awk -F: '{print $1}')
insert_line_nbr=$((iter_line_nbr - 1))
sed -i "${insert_line_nbr}i frontmatter_ = vim.tbl_extend(\"force\", frontmatter_, { hubs = {}, urls = {} })" /home/jason/.local/share/nvim/lazy/obsidian.nvim/lua/obsidian/note.lua
sed -i "s/frontmatter_ = vim.tbl_extend(\"force\", frontmatter_, { hubs = {}, urls = {} })/  frontmatter_ = vim.tbl_extend(\"force\", frontmatter_, { hubs = {}, urls = {} })/" /home/jason/.local/share/nvim/lazy/obsidian.nvim/lua/obsidian/note.lua
sed -i 's/      for i, k in ipairs { "id", "aliases", "tags" } do/      for i, k in ipairs { "id", "aliases", "tags", "hubs", "urls" } do/' /home/jason/.local/share/nvim/lazy/obsidian.nvim/lua/obsidian/note.lua
