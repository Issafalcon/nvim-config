-- Add colour to colour names
return {
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      filetypes = {
        css = {
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          mode = "background",
          names = true,
        },
        ---@diagnostic disable-next-line: undefined-global
        sass = { enable = true, parsers = { css } }, -- Enable sass colors
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "lua",
      },
      user_default_options = {
        mode = "background",
        names = false,
      },
    },
  },
}
