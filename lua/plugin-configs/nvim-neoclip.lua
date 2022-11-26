local neoclip = fignvim.plug.load_module_file("neoclip")
if not neoclip then
  return
end

neoclip.setup({
  history = 1000,
})
