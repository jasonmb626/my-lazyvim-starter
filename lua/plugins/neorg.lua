return {
  "nvim-neorg/neorg",
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              work = "~/Documents/zettelkasten", -- Format: <name_of_workspace> = <path_to_workspace_root>
            },
            index = "index.norg", -- The name of the main (root) .norg file
            default_workspace = "work",
          },
        },
      },
    })
  end,
}
