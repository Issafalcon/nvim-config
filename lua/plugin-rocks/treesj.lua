-- Enhanced join / split functionality
local treesj_keys = {
  { "n", "<leader>j", "<cmd>TSJToggle<cr>", { desc = "Join Toggle" } },
}

-- https://github.com/Wansmer/treesj
require("treesj").setup({
  max_join_length = 140,
  use_default_keymaps = false,
})

fignvim.mappings.create_keymaps(treesj_keys)
