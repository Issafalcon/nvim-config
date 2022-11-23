local neogen = fignvim.plug.load_module_file("neogen")
if not neogen then
  return
end

neogen.setup({
  snippet_support = "luasnip",
  languages = {
    cs = {
      template = {
        annotation_convention = "xmldoc",
      },
    },
  },
})
