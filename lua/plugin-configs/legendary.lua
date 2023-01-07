local legendary = fignvim.plug.load_module_file("legendary")
if not legendary then
  return
end

legendary.setup({
  keymaps = fignvim.config.get_legendary_keymaps(),
  default_opts = {
    keymaps = {
      noremap = true,
      silent = true,
    },
  },
})
