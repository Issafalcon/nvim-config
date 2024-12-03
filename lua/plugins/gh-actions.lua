return {
  {
    "topaxi/pipeline.nvim",
    keys = {
      { "<leader>gh", "<cmd>Pipeline<cr>", desc = "Open Pipeline" },
    },
    -- optional, you can also install and use `yq` instead.
    build = "make",
    ---@type pipeline.Config
    opts = {},
  },
}
