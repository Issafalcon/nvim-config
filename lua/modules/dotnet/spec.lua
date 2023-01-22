local omnisharp_extd_spec = {
  "Hoffs/omnisharp-extended-lsp.nvim",
  ft = "cs",
}

return fignvim.module.enable_registered_plugins({
  ["omnisharp-extended-lsp"] = omnisharp_extd_spec,
}, "dotnet")
