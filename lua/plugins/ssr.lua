-- Treesitter based structural search and replace
local ssr_keys = {
  { { "n", "x" }, "<leader>sR", function() require("ssr").open() end, { desc = "Structural Replace" } },
}

return {
  {
    "cshuaimin/ssr.nvim",
    keys = fignvim.mappings.make_lazy_keymaps(ssr_keys, true),
  },
}
