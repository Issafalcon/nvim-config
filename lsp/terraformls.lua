vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("terraform-ls-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "terraformls" then
      return
    end

    -- Workaround for https://github.com/hashicorp/terraform-ls/issues/2125
    fignvim.ui.notify("Removing terraformls semantic tokens provider", "info", { title = "LSP" })
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

return {
  filetypes = { "terraform", "tf" },
}
