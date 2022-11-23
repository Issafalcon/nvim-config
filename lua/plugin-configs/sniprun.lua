local sniprun = fignvim.plug.load_module_file("sniprun")
if not sniprun then
  return
end

sniprun.setup({
  display = {
    "Classic",
    "VirtualTextOk",
    "TempFloatingWindow",
  },
})
