local icon_picker = fignvim.plug.load_module_file("icon-picker")
if not icon_picker then
  return
end

icon_picker.setup({
  disable_legacy_commands = true,
})
