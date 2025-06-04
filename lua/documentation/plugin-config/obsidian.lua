---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  workspaces = {
    {
      name = "obsidian-notes",
      path = vim.fn.expand("~") .. "/repos/obsidian-notes",
    },
  },
  disable_frontmatter = true,
  log_level = vim.log.levels.INFO,

  -- Optional, customize how names/IDs for new notes are created.
  note_id_func = function(title)
    return title
  end,

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
      dir = function()
        return vim.fn.fnamemodify(vim.fn.expand("%"), ":h:t")
      end,
    },
  },

  daily_notes = {
    folder = "Daily",
    template = "DailyTemplate.md",
  },
}

return M
