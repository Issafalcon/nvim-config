local indent_blankline = fignvim.plug.load_module_file("indent_blankline")
if not indent_blankline then
  return
end

indent_blankline.setup({
  show_end_of_line = true,
  space_char_blankline = " ",
})
