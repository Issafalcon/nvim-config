local bufferline = fignvim.plug.load_module_file("bufferline")
if not bufferline then
  return
end

bufferline.setup({
  options = {
    offsets = {
      { filetype = "NvimTree", text = "", padding = 1 },
      { filetype = "neo-tree", text = "", padding = 1 },
      { filetype = "Outline", text = "", padding = 1 },
    },
    buffer_close_icon = fignvim.ui.get_icon("BufferClose"),
    modified_icon = fignvim.ui.get_icon("FileModified"),
    close_icon = fignvim.ui.get_icon("NeovimClose"),
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 20,
    separator_style = "thin",
  },
})
