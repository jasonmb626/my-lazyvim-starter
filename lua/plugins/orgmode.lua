return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      local zettel_base = os.getenv("ZETTEL_BASE") or "~/Documents/zettelkasten"
      local useful = require("config.useful")
      local templates_dir = os.getenv("ORG_TEMPLATES_DIR") or "~/.config/nvim/org-templates"
      local tpl_daily = useful.readAll(templates_dir .. "/tpl-daily-plan.txt")
      local store_template = useful.readAll(templates_dir .. "/store-template.txt")
      local inc_template = useful.readAll(templates_dir .. "/inc-template.txt")
      local script_template = useful.readAll(templates_dir .. "/script-template.txt")
      local custom_datetree = {
        tree_type = "custom",
        tree = {
          {
            format = "%Y-%m-%d %A",
            pattern = "^(%d%d%d%d)%-(%d%d)%-(%d%d).*$",
            order = { 1 },
          },
        },
      }
      local olog = require("plenary.log").new({
        plugin = "me",
        level = "info",
      })

      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = zettel_base .. "/**/*",
        org_default_notes_file = zettel_base .. "/refile.org",
        org_use_tag_inheritance = false,
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
        org_capture_templates = {
          s = {
            description = "Script",
            template = script_template,
            target = zettel_base .. "/journal.org",
            headline = "Capture",
          },
          S = {
            description = "Store",
            template = store_template,
            target = zettel_base .. "/journal.org",
            headline = "Capture",
          },
          I = {
            description = "Incident",
            template = inc_template,
            target = zettel_base .. "/journal.org",
            headline = "Capture",
          },
          t = {
            description = "TODO entry",
            template = "* TODO %^{Description} :NEW:\n  :LOGBOOK:\n  - Added: %U\n  :END:\n \n%?",
            target = zettel_base .. "/journal.org",
            headline = "Capture",
          },
          d = {
            description = "Daily plan",
            template = tpl_daily,
            target = zettel_base .. "/journal.org",
            datetree = custom_datetree,
          },
          m = "Meetings",
          mw = {
            description = "Workarounds (CSS scripts/jobs)",
            template = "* Workarounds (CSS scripts/jobs) :CUST_MEETING:\nSCHEDULED: <" .. vim.fn.strftime(
              "%Y-%m-%d %a"
            ) .. " 09:30>",
            target = zettel_base .. "/journal.org",
            datetree = custom_datetree,
          },
          mj = {
            description = "JTF",
            template = "* JTF :CUST_MEETING:\nSCHEDULED: <" .. vim.fn.strftime("%Y-%m-%d %a") .. " 10:45>",
            target = zettel_base .. "/journal.org",
            datetree = custom_datetree,
          },
          mn = {
            description = "Nucleus Blocker",
            template = "* Nucleus Blocker :CUST_MEETING:\nSCHEDULED: <" .. vim.fn.strftime("%Y-%m-%d %a") .. " 08:30>",
            target = zettel_base .. "/journal.org",
            datetree = custom_datetree,
          },
          mN = {
            description = "Nucleus Scrum",
            template = "* Nucleus Scrum :CUST_MEETING:\nSCHEDULED: <" .. vim.fn.strftime("%Y-%m-%d %a") .. " 13:00>",
            target = zettel_base .. "/journal.org",
            datetree = custom_datetree,
          },
          mt = {
            description = "Team meeting",
            template = "* Team Meeting :CUST_MEETING:\nSCHEDULED: <" .. vim.fn.strftime("%Y-%m-%d %a") .. " 11:30>",
            target = zettel_base .. "/journal.org",
            datetree = custom_datetree,
          },
          mc = {
            description = "Checkpoing T1/T2",
            template = "* Checkpoint T1/T2 :CUST_MEETING:\nSCHEDULED: <" .. vim.fn.strftime("%Y-%m-%d %a") .. " 09:30>",
            target = zettel_base .. "/journal.org",
            datetree = custom_datetree,
          },
        },
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
