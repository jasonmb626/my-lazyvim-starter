-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("cmp").setup({
  mapping = require("cmp").mapping.preset.insert({
    ["<C-j>"] = {
      i = function()
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.select_next_item({ behavior = require("cmp.types").cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
    },
    ["<C-k>"] = {
      i = function()
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.select_prev_item({ behavior = require("cmp.types").cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
    },
    ["<C-l>"] = {
      i = function()
        i = require("cmp").mapping.confirm({ select = true })
      end,
    },
  }),
})

local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
  defaults = {
    mappings = {
      n = {
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      i = {
        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = actions.move_selection_next, -- move to next result
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-S-d>"] = actions.delete_buffer,
      },
    },
  },
})

vim.keymap.set("n", "<M-h>", function()
  require("bufferline").cycle(-1)
end, { desc = "Prev buffer" })
vim.keymap.set("n", "<M-l>", function()
  require("bufferline").cycle(1)
end, { desc = "Next buffer" })
vim.keymap.set("n", "<M-u>", function()
  require("bufferline").go_to(1, true)
end, { desc = "Jump to 1st buffer" })
vim.keymap.set("n", "<M-i>", function()
  require("bufferline").go_to(2, true)
end, { desc = "Jump to 2nd buffer" })
vim.keymap.set("n", "<M-o>", function()
  require("bufferline").go_to(3, true)
end, { desc = "Jump to 3rd buffer" })
vim.keymap.set("n", "<M-p>", function()
  require("bufferline").go_to(4, true)
end, { desc = "Jump to 4th buffer" })
vim.keymap.set("n", "<leader>b<", function()
  require("bufferline").move(-1)
end, { desc = "Move buffer backward in bufferline." })
vim.keymap.set("n", "<leader>b>", function()
  require("bufferline").move(1)
end, { desc = "Move buffer forward in bufferline." })

local olog = require("plenary.log").new({
  plugin = "me",
  level = "info",
})
vim.keymap.set("n", "<leader>bL", function()
  orgmode = require("orgmode")
  olog.info(vim.inspect(orgmode))
end, { desc = "Move buffer forward in bufferline." })
