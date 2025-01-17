local yanky_mappings = {
  { { "n", "x" }, "y", "<Plug>(YankyYank)" },

  { { "n", "x" }, "p", "<Plug>(YankyPutAfter)" },
  { { "n", "x" }, "P", "<Plug>(YankyPutBefore)" },
  { { "n", "x" }, "gp", "<Plug>(YankyGPutAfter)" },
  { { "n", "x" }, "gP", "<Plug>(YankyGPutBefore)" },

  { "n", "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
  { "n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
  { "n", "]P", "<Plug>(YankyPutIndentAfterLinewise)" },
  { "n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)" },

  { "n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)" },
  { "n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" },
  { "n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" },
  { "n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" },

  { "n", "=p", "<Plug>(YankyPutAfterFilter)" },
  { "n", "=P", "<Plug>(YankyPutBeforeFilter)" },

  {
    "n",
    "<leader>P",
    function()
      require("telescope").extensions.yank_history.yank_history({})
    end,
    { desc = "Paste from Yanky" },
  },
}

require("yanky").setup({
  highlight = {
    timer = 150,
  },
  ring = {
    storage = jit.os:find("Windows") and "shada" or "sqlite",
  },
})

fignvim.mappings.create_keymaps(yanky_mappings)
