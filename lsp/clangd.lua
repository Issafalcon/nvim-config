vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("clangd-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "clangd" then
      return
    end

    client.server_capabilities.documentFormattingProvider = false
  end,
})

return {
  cmd = { "clangd", "--offset-encoding=utf-16" },
}
