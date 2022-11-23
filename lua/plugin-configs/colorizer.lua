local colorizer = fignvim.plug.load_module_file("colorizer")
if not colorizer then
  return
end

colorizer.setup({
  filetypes = {
    css = {
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      mode = "background",
      names = true,
    },
    sass = { enable = false, parsers = { css } }, -- Enable sass colors
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
  },
  user_default_options = {
    mode = "foreground",
    names = false,
  },
})