local whichkey = fignvim.plug.load_module_file("which-key")
if not whichkey then
  return
end

whichkey.setup({
  plugins = {
    spelling = { enabled = true },
    presets = { operators = false },
  },
  window = {
    border = "rounded",
    padding = { 2, 2, 2, 2 },
  },
  disable = { filetypes = { "TelescopePrompt" } },
})
