-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
require("mini.icons").setup({
  -- Icon style: 'glyph' or 'ascii'
  style = "glyph",

  -- Customize per category. See `:h MiniIcons.config` for details.
  default = {},
  directory = {},
  extension = {},
  file = {
    [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
    ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
  },
  filetype = {
    octo = { glyph = "" },
    dotenv = { glyph = "", hl = "MiniIconsYellow" },
  },
  lsp = {},
  os = {},

  -- Control which extensions will be considered during "file" resolution
  use_file_extension = function(_, _)
    return true
  end,
})

-- Mock out any dependency on 'nvim-web-devicons' (for plugins that do not have integration with any other icon lib)
MiniIcons.mock_nvim_web_devicons()
