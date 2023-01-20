local trouble_keys = {
  { "n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle trouble" } },
  { "n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", { desc = "Open workspace diagnostics" } },
  { "n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { desc = "Open document diagnostics" } },
  { "n", "<leader>xl", "<cmd>Trouble loclist<cr>", { desc = "Open workspace diagnostics in loclist" } },
  { "n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { desc = "Open workspace diagnostics into quickfix" } },
}

local trouble_spec = {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  init = function() fignvim.mappings.register_keymap_group("Diagnostics", trouble_keys, false, "<leader>x") end,
  keys = fignvim.mappings.make_lazy_keymaps(trouble_keys, true),
  opts = {
    use_diagnostic_signs = true,
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  },
}

return fignvim.module.enable_registered_plugins({
  ["trouble"] = trouble_spec,
}, "diagnostics")
