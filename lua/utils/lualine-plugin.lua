local lualine_custom = require('utils.lualine-sections')
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

lualine.setup({
  options = {
    theme = "dracula",
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  extensions = {
    "quickfix",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      lualine_custom.nvim_diagnostics_error(),
      lualine_custom.nvim_diagnostics_warn(),
      { "filename", file_status = false, path = 1 },
      -- { lualine_custom.modified, color = { bg = lualine_custom.colors.red } },
      {
        "%w",
        cond = function()
          return vim.wo.previewwindow
        end,
      },
      {
        "%r",
        cond = function()
          return vim.bo.readonly
        end,
      },
      {
        "%q",
        cond = function()
          return vim.bo.buftype == "quickfix"
        end,
      },
    },
    lualine_c = {
      {
        "require'lsp-status'.status()",
        color = {
          fg = lualine_custom.colors.green,
        },
      },
    },
    lualine_x = {},
    lualine_y = { lualine_custom.search_result, "filetype" },
    lualine_z = { "%l:%c", "%p%%/%L" },
  },
  inactive_sections = {
    lualine_c = { "%f %y %m" },
    lualine_x = {},
  },
})
