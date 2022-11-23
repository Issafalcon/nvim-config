local toggleterm = fignvim.plug.load_module_file("toggleterm")
if not toggleterm then
  return
end

toggleterm.setup({
  size = 10,
  open_mapping = [[<F7>]],
  shading_factor = 2,
  direction = "float",
  float_opts = {
    border = "curved",
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})
