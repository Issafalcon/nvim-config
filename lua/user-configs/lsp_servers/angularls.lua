M = {}

M.on_attach = function (client, bufnr)
    local clients = vim.lsp.buf_get_clients(bufnr)
    for _, other_client in pairs(clients) do
      if other_client.name == "tsserver" then
        -- Prevent tsserver rename duplication when angularls is in use
        other_client.server_capabilities.rename = false
      end
    end
end

return M
