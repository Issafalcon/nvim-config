M = {}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

M.opts = {
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
  },
}

M.on_attach = function(client, bufnr)
  client.server_capabilities.document_formatting = false

  local ts_utils_ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")
  fignvim.fn.conditional_func(ts_utils.setup, ts_utils_ok ~= nil, {})
  fignvim.fn.conditional_func(ts_utils.setup_client, ts_utils_ok ~= nil, client)

  local clients = vim.lsp.buf_get_clients(bufnr)
  for _, other_client in pairs(clients) do
    if other_client.name == "angularls" then
      -- Prevent tsserver rename duplication when angularls is in use
      client.server_capabilities.rename = false
    end
  end
end
return M
