local dressing = fignvim.plug.load_module_file("dressing")
if not dressing then
  return
end

dressing.setup({
  input = {
    default_prompt = "➤ ",
    winhighlight = "Normal:Normal,NormalNC:Normal",
  },
  select = {
    backend = { "telescope", "builtin" },
    builtin = { winhighlight = "Normal:Normal,NormalNC:Normal" },
  },
})
