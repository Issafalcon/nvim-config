local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Adds custom highlights from user config
augroup("fignvim_highlights", { clear = true })
cmd({ "VimEnter", "ColorScheme" }, {
  desc = "Load custom highlights from user configuration",
  group = "fignvim_highlights",
  callback = function()
    if vim.g.colours_name then
      local colourscheme = require("core.colourscheme")
      for group, spec in pairs(colourscheme.theme.highlights) do
        vim.api.nvim_set_hl(0, group, spec)
      end
    end
  end,
})
