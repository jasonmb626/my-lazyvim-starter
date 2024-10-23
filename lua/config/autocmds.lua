-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.task" },
  callback = function()
    vim.keymap.set("n", "<leader>Sc", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "CUST_MEETING" })
      vim.cmd("edit")
    end, { desc = "Set TAG to CUST_MEETING" })
    vim.keymap.set("n", "<leader>SC", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "CRQ" })
      vim.cmd("edit")
    end, { desc = "Set TAG to CRQ" })
    vim.keymap.set("n", "<leader>Se", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "EMAIL_SUPPORT" })
      vim.cmd("edit")
    end, { desc = "Set TAG to EMAIL_SUPPORT" })
    vim.keymap.set("n", "<leader>Si", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "INCIDENT" })
      vim.cmd("edit")
    end, { desc = "Set TAG to INCIDENT" })
    vim.keymap.set("n", "<leader>Sm", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "MISC" })
      vim.cmd("edit")
    end, { desc = "Set TAG to MISC" })
    vim.keymap.set("n", "<leader>Sn", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "NUCLEUS_INC" })
      vim.cmd("edit")
    end, { desc = "Set TAG to NUCLEUS_INC" })
    vim.keymap.set("n", "<leader>Sp", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "PTO" })
      vim.cmd("edit")
    end, { desc = "Set TAG to PTO" })
    vim.keymap.set("n", "<leader>Sr", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "TRAINING" })
      vim.cmd("edit")
    end, { desc = "Set TAG to TRAINING" })
    vim.keymap.set("n", "<leader>Ss", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "SCRIPTING" })
      vim.cmd("edit")
    end, { desc = "Set TAG to SCRIPTING" })
    vim.keymap.set("n", "<leader>St", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "TCS_MEETING" })
      vim.cmd("edit")
    end, { desc = "Set TAG to TCS_MEETING" })
    vim.keymap.set("n", "<leader>Sw", function()
      local current_file = vim.fn.expand("%:p'")
      local set_tag_ok, set_tag_output =
        pcall(vim.fn.system, { "/home/jason/.config/nvim/bin/taskw_uniq_tag_set.sh", current_file, "W_O_REQ" })
      vim.cmd("edit")
    end, { desc = "Set TAG to W_O_REQ" })
  end,
})
