-- https://github.com/Equilibris/nx.nvim
local nx_keys = {
  {
    "n",
    "<leader>nx",
    "<cmd>Telescope nx actions<CR>",
    { desc = "Brings up Nx command pallete" },
  },
}

require("nx").setup({
  nx_cmd_root = "nx",
})

fignvim.mappings.create_keymaps(nx_keys)
