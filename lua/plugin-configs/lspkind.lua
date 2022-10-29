local lspkind = fignvim.plug.load_module_file("lspkind")
if not lspkind then return end
fignvim.lspkind = {
  mode = "symbol",
  symbol_map = {
    NONE = "",
    Array = "",
    Boolean = "⊨",
    Class = "",
    Constructor = "",
    Key = "",
    Namespace = "",
    Null = "NULL",
    Number = "#",
    Object = "⦿",
    Package = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "𝓐",
    TypeParameter = "",
    Unit = "",
  },
}
lspkind.init(fignvim.lspkind)

