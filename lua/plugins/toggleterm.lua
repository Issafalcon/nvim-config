local toggleterm_keys = {
  {
    "n",
    "<leader>lg",
    function() fignvim.term.toggle_term_cmd("lazygit") end,
    { desc = "ToggleTerm with lazygit" },
  },
  {
    "n",
    "<F7>n",
    function() fignvim.term.toggle_term_cmd("node") end,
    { desc = "ToggleTerm with Node" },
  },
  {
    "n",
    "<F7>p",
    function() fignvim.term.toggle_term_cmd("python") end,
    { desc = "ToggleTerm with Python" },
  },
  {
    "n",
    "<F7>f",
    "<cmd>ToggleTerm direction=float<cr>",
    { desc = "ToggleTerm in floating window" },
  },
  {
    "n",
    "<F7>h",
    "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
    { desc = "ToggleTerm in horizontal split" },
  },
  {
    "n",
    "<F7>v",
    "<cmd>ToggleTerm size=80 direction=vertical<cr>",
    { desc = "ToggleTerm in vertical split" },
  },
  {
    { "n", "t" },
    "<F7><F7>",
    "<cmd>ToggleTerm<cr>",
    { desc = "ToggleTerm" },
  },
  {
    { "n", "t" },
    "<C-'>",
    "<cmd>ToggleTerm<cr>",
    { desc = "ToggleTerm" },
  },
}

return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    init = function() fignvim.mappings.register_whichkey_prefix("<F7>", "Terminal") end,
    keys = fignvim.mappings.make_lazy_keymaps(toggleterm_keys, true),
    opts = {
      size = 10,
      open_mapping = [[<F7><F7>]],
      shading_factor = 2,
      direction = "float",
      float_opts = {
        border = "curved",
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
  },
}
