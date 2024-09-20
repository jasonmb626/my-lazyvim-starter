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

local obsidian_client = require("obsidian").get_client()
local current_workspace = obsidian_client.current_workspace
ws_path = obsidian_client.vault_root({}, current_workspace)

require("which-key").add({ lhs = "<leader>o", group = "obsidian", mode = { "n", "v" } })
vim.keymap.set("n", "<leader>os", function()
  require("telescope.builtin").find_files({ cwd = ws_path.filename })
end, { desc = "Find files in vault" })
vim.keymap.set("n", "<leader>oz", function()
  require("telescope.builtin").live_grep({ cwd = ws_path.filename })
end, { desc = "grep files in vault" })

local util = require("obsidian.util")
vim.keymap.set("n", "<leader>on", function()
  require("obsidian.templates").insert_template({
    template_name = "note",
    client = obsidian_client,
    location = util.get_active_window_cursor_location(),
  })
end, { desc = "Insert note template" })
vim.keymap.set("n", "<leader>oe", function()
  require("neo-tree.command").execute({ toggle = true, dir = ws_path.filename })
end, { desc = "Explorer Neotreee (vault)" })
vim.keymap.set("n", "<leader>ot", function()
  local note = obsidian_client:today()
  obsidian_client:open_note(note)
end, { desc = "Open today's note" })
vim.keymap.set("n", "<leader>ok", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.fn.expand("%:p'")
  local move_file_ok, move_file_output =
    pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/file_note.sh", current_file, ws_path.filename })
  print(move_file_ok)
  print(vim.inspect(move_file_output))
  if move_file_ok and move_file_output:find("Failed") then
    print(move_file_output)
  else
    vim.api.nvim_buf_delete(current_buf, {})
  end
end, { desc = "Accept note and sort into zettelkasten" })
vim.keymap.set("n", "<leader>odd", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.fn.expand("%:p'")
  local rm_file_ok, rm_file_output =
    pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/file_note.sh", current_file, "-d" })
  if rm_file_ok and rm_file_output:find("Failed") then
    print(rm_file_output)
  else
    vim.api.nvim_buf_delete(current_buf, {})
  end
end, { desc = "Delete note permanantely." })

local olog = require("plenary.log").new({
  plugin = "me",
  level = "info",
})

vim.keymap.set("n", "<leader>ob", function()
  local current_file = vim.fn.expand("%:p'")
  local note = require("obsidian.note").from_file(current_file)
  local backlinks = obsidian_client:find_backlinks(note)
  local entries = {}
  for _, matches in ipairs(backlinks) do
    for _, match in ipairs(matches.matches) do
      entries[#entries + 1] = {
        value = { path = matches.path, line = match.line },
        filename = tostring(matches.path),
        lnum = match.line,
      }
    end
  end

  local opts = {}
  ---@type string
  local prompt_title
  if opts.anchor then
    prompt_title = string.format("Backlinks to '%s%s'", note.id, opts.anchor)
  elseif opts.block then
    prompt_title = string.format("Backlinks to '%s#%s'", note.id, util.standardize_block(opts.block))
  else
    prompt_title = string.format("Backlinks to '%s'", note.id)
  end

  local picker = obsidian_client:picker()
  vim.schedule(function()
    olog.info(vim.inspect(entries))
    picker:pick(entries, {
      prompt_title = prompt_title,
      callback = function(value)
        util.open_buffer(value.path, { line = value.line })
      end,
    })
  end)
end, { desc = "Get backlinks to this note." })

require("obsidian.note"):add_field("hubs", { "[[]]" })
require("obsidian.note"):add_field("urls", {})

-- log.info(vim.inspect(obsidian_client))
