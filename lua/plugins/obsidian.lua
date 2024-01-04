return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    "BufReadPre "
      .. vim.fn.expand("~")
      .. "/repos/wiki-md/**.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/repos/wiki-md",
      },
    },

    log_level = vim.log.levels.INFO,
  },
}
