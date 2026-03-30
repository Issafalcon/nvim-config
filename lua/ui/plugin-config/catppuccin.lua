---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  flavour = "mocha",
  transparent_background = false,
  term_colors = true,
  integrations = {
    aerial = true,
    gitsigns = true,
    cmp = true,
    nvimtree = true,
    alpha = true,
    dashboard = true,
    flash = true,
    fzf = true,
    grug_far = true,
    headlines = true,
    illuminate = true,
    indent_blankline = { enabled = true },
    leap = true,
    lsp_trouble = true,
    mason = true,
    markdown = true,
    mini = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
    navic = { enabled = true, custom_bg = "lualine" },
    neotest = true,
    neotree = true,
    noice = true,
    notify = true,
    semantic_tokens = true,
    snacks = true,
    telescope = true,
    treesitter = true,
    treesitter_context = true,
    which_key = true,
  },
  dim_inactive = {
    enabled = true,
    shade = "dark",
    percentage = 0.10,
  },
}
return M
