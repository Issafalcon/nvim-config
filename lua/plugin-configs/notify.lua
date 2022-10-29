local notify = fignvim.plug.load_module_file("notify")
if not notify then
  return
end

notify.setup({ stages = "fade" })
vim.notify = notify
