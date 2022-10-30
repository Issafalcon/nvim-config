local notify = fignvim.plug.load_module_file("notify")
if not notify then
  return
end

notify.setup({ stages = "fade_in_slide_out" })
vim.notify = notify
