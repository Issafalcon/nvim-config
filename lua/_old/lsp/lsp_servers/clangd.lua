M = {}

M.opts = {
  cmd = { "clangd", "--offset-encoding=utf-16" },
}

M.on_attach = function(client, bufnr) client.server_capabilities.document_formatting = false end

return M
