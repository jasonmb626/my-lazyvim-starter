return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      local zettel_base = os.getenv("ZETTEL_BASE") or "~/Documents/zettelkasten"
      local useful = require("config.useful")
      local olog = require("plenary.log").new({
        plugin = "me",
        level = "info",
      })

      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = zettel_base .. "/**/*",
        org_default_notes_file = zettel_base .. "/refile.org",
        org_use_tag_inheritance = false,
        mappings = {
          org = {
            org_toggle_checkbox = "<leader>o<CR>",
          },
        },
        org_todo_keywords = {
          "TODO(t!)",
          "NEXT(n!)",
          "PROG(p!)",
          "BLOCKED(b@/!)",
          "?(?!)",
          "TO DELEGATE(2!)",
          "DELEGATED(g@/!)",
          "FOLLOWUP(f!)",
          "FORWARDED(>@/!)",
          "ADJOURNED(a!)",
          "TICKLE(T!)",
          "|",
          "CANCELED(c!)",
          "DONE(d!)",
        },
        org_log_into_drawer = "LOGBOOK",
      })

      local cmp = require("cmp")
      local sources = cmp.get_config().sources
      sources = vim.list_extend(sources, { { "orgmode" } })
      cmp.setup({
        sources = cmp.config.sources(sources),
      })

      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require("nvim-treesitter.configs").setup({
      --   ensure_installed = "all",
      --   ignore_install = { "org" },
      -- })
    end,
  },
  {
    "nvim-orgmode/org-bullets.nvim",
    config = function()
      require("org-bullets").setup()
    end,
  },
}
