local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
  return
end

saga.init_lsp_saga({
  code_action_lightbulb = {
    enable = false,
    enable_in_insert = false,
    cache_code_action = false,
    sign = false
  },
})
