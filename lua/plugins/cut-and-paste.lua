local yanky_mappings = {
  { { "n", "x" }, "y", "<Plug>(YankyYank)" },

  { { "n", "x" }, "p", "<Plug>(YankyPutAfter)" },
  { { "n", "x" }, "P", "<Plug>(YankyPutBefore)" },
  { { "n", "x" }, "gp", "<Plug>(YankyGPutAfter)" },
  { { "n", "x" }, "gP", "<Plug>(YankyGPutBefore)" },

  { "n", "<c-n>", "<Plug>(YankyCycleForward)" },
  { "n", "<c-p>", "<Plug>(YankyCycleBackward)" },

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
    function() require("telescope").extensions.yank_history.yank_history({}) end,
    { desc = "Paste from Yanky" },
  },
}

local cutlass_mappings = {
  { { "n", "x" }, "m", "d", { desc = "Cutlass: Cut char to clipboard" } },
  { "n", "mm", "dd", { desc = "Cutlass: Cut line to clipboard" } },
  { "n", "M", "D", { desc = "Cutlass: Cut from cursor to end of line, to clipboard" } },
  { "n", "\\m", "m", { desc = "Cutlass: Remap create mark key so it isn't shadowed" } },
}

local yanky_spec = {
  "gbprod/yanky.nvim",
  event = "BufReadPost",
  keys = fignvim.config.make_lazy_keymaps(yanky_mappings),
  config = function()
    require("yanky").setup({
      highlight = {
        timer = 150,
      },
      ring = {
        storage = jit.os:find("Windows") and "shada" or "sqlite",
      },
    })

    fignvim.config.register_keymap_group("Yanky", yanky_mappings)
  end,
}

local cutlass_spec = {
  "svermeulen/vim-cutlass",
  event = "BufReadPost",
  keys = fignvim.config.make_lazy_keymaps(cutlass_mappings),
}

return {
  yanky_spec,
  cutlass_spec,
}
