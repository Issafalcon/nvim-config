local nx_keys = {
  {
    "n",
    "<leader>nx",
    "<cmd>Telescope nx actions<CR>",
    { desc = "Brings up Nx command pallete" },
  },
}

return {
  {
    "Equilibris/nx.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      -- See below for config options
      nx_cmd_root = "nx",
    },
    keys = fignvim.mappings.make_lazy_keymaps(nx_keys, true),
  },
}
