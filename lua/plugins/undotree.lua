local undotree_keys = {
  { "n", "<A-u>", ":UndotreeToggle<CR>", { desc = "Undotree: Toggle undotree" } },
}

return {
  {
    "mbbill/undotree",
    cmd = "UndoTreeToggle",
    keys = fignvim.mappings.make_lazy_keymaps(undotree_keys, true),
  },
}
