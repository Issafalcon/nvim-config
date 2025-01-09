-- Treesitter based structural search and replace
local ssr_keys = {
  {
    { "n", "x" },
    "<leader>sR",
    function()
      require("ssr").open()
    end,
    { desc = "Structural Replace" },
  },
}

fignvim.mappings.create_keymaps(ssr_keys)
