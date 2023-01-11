local catppuccin_spec = {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      transparent_background = false,
      term_colors = true,
      integrations = {
        telescope = true,
        aerial = true,
        gitsigns = true,
        cmp = true,
        nvimtree = true,
        mason = true,
      },
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.10,
      },
    }
  end,
}

local spec = {
  catppuccin_spec,
  { "shaunsingh/oxocarbon.nvim" },
}

return spec
