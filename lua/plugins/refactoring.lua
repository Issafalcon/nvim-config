local ssr_keys = {
  { { "n", "x" }, "<leader>sR", function() require("ssr").open() end, { desc = "Structural Replace" } },
}

-- Enhanced join / split functionality
local treesj_keys = {
  { "n", "J", "<cmd>TSJToggle<cr>", { desc = "Join Toggle" } },
}

-- Treesitter based structural search and replace
local ssr_spec = {
  "cshuaimin/ssr.nvim",
  keys = fignvim.config.make_lazy_keymaps(ssr_keys),
}

local treesj_spec = {
  "Wansmer/treesj",
  keys = fignvim.config.make_lazy_keymaps(treesj_keys),
  opts = { use_default_keymaps = false, max_join_length = 150 },
}
