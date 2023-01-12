local catppuccin = fignvim.plug.load_module_file("catppuccin")

if not catppuccin then return end

catppuccin.setup({
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
})
