return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    "BufReadPre "
      .. vim.fn.expand("~")
      .. "/repos/obsidian-notes/**.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "obsidian-notes",
        path = vim.fn.expand("~") .. "/repos/obsidian-notes",
      },
    },
    disable_frontmatter = true,
    log_level = vim.log.levels.INFO,

    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title) return title end,

    -- Optional, for templates (see below).
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {
        project = function()
          -- Return the name of the current folder that the file is in
          return string.gsub(vim.fn.fnamemodify(vim.fn.expand("%"), ":h:t"), " ", "-")
        end,
        dir = function() return vim.fn.fnamemodify(vim.fn.expand("%"), ":h:t") end,
      },
    },

    daily_notes = {
      folder = "Daily",
      template = "DailyTemplate.md",
    },
  },
}
