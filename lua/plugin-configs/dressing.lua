local dressing = fignvim.plug.load_module_file("dressing")
if not dressing then
  return
end

dressing.setup({
  input = {
    default_prompt = "➤ ",
    win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
  },
  select = {
    backend = { "telescope", "builtin" },
    builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
  },
})
