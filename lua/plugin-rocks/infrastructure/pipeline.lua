local pipeline_keys = {
  {
    "n",
    "<leader>gh",
    "<cmd>Pipeline<cr>",
    { desc = "Open Pipeline" },
  },
}

require("pipeline").setup()
fignvim.mappings.create_keymaps(pipeline_keys)
