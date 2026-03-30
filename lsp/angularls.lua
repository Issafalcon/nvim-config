-- Angular Language Server configuration
-- Based on LazyVim's Angular extras

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("angularls-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "angularls" then
      return
    end

    -- HACK: disable angular renaming capability due to duplicate rename popping up
    -- when both angularls and vtsls are active
    client.server_capabilities.renameProvider = false
  end,
})

return {
  -- Angular language server configuration
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
  root_dir = require("lspconfig").util.root_pattern("angular.json", "project.json"),
}
