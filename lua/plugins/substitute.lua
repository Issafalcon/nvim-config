local substitute_keys = {
  {
    "n",
    "s",
    function() require("substitute").operator() end,
    { noremap = true, desc = "Substitute: substitute using operator with value in default buffer" },
  },
  {
    "n",
    "ss",
    function() require("substitute").line() end,
    { noremap = true, desc = "Substutute: Substutute line using with value in default buffer" },
  },
  {
    "n",
    "S",
    function() require("substitute").eol() end,
    { noremap = true, desc = "Substutute: Substitute to end of line using value in default buffer" },
  },
  {
    "x",
    "s",
    function() require("substitute").visual() end,
    { noremap = true, desc = "Substitute: Sustitute visual selection with value in defautl buffer" },
  },

  { "n", "<leader>s", function() require("substitute.range").operator() end, { noremap = true } },
  {
    "x",
    "<leader>s",
    function() require("substitute.range").visual() end,
    { noremap = true },
  },
  {
    "n",
    "<leader>ss",
    function() require("substitute.range").word() end,
    { noremap = true },
  },

  {
    "n",
    "sx",
    function() require("substitute.exchange").operator() end,
    { noremap = true },
  },
  {
    "n",
    "sxx",
    function() require("substitute.exchange").line() end,
    { noremap = true },
  },
  {
    "x",
    "X",
    function() require("substitute.exchange").visual() end,
    { noremap = true },
  },
  {
    "n",
    "sxc",
    function() require("substitute.exchange").cancel() end,
    { noremap = true },
  },
}

return {
  {
    "gbprod/substitute.nvim",
    dependencies = { "tpope/vim-abolish" },
    keys = fignvim.mappings.make_lazy_keymaps(substitute_keys, true),
    opts = {
      range = {
        prefix = "S",
      },
    },
  },
}
