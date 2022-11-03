local lspkind = fignvim.plug.load_module_file("lspkind")
if not lspkind then
  return
end

fignvim.lspkind = {
  mode = "symbol",
  symbol_map = fignvim.ui.lspkind_icons,
}

lspkind.init(fignvim.lspkind)
