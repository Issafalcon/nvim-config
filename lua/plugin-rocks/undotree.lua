-- https://github.com/mbbill/undotree
local undotree_keys = {
  { "n", "<A-u>", ":UndotreeToggle<CR>", { desc = "Undotree: Toggle undotree" } },
}

fignvim.mappings.create_keymaps(undotree_keys)
