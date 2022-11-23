local session_lens = fignvim.plug.load_module_file("session-lens")
if not session_lens then
  return
end

session_lens.setup({
  path_display = { "shorten" },
  previewer = false,
})
