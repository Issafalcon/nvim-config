local aerial = fignvim.plug.load_module_file("aerial")
if not aerial then
  return
end

aerial.setup({
  attach_mode = "window",
  backends = { "lsp", "treesitter", "markdown" },
  close_automatic_events = { "unfocus" },
  highlight_on_hover = true,
  layout = {
    min_width = 28,
  },
  show_guides = true,
  filter_kind = false,
  guides = {
    mid_item = "├ ",
    last_item = "└ ",
    nested_top = "│ ",
    whitespace = "  ",
  },
  keymaps = {
    ["[y"] = "actions.prev",
    ["]y"] = "actions.next",
    ["[Y"] = "actions.prev_up",
    ["]Y"] = "actions.next_up",
    ["{"] = false,
    ["}"] = false,
    ["[["] = false,
    ["]]"] = false,
  },
})
