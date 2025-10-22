local which_key = require("which-key")

which_key.add({
  { "<leader>t", group = "Navigation" },
  {
    "<F7>",
    group = "Terminal",
  },
  { "<leader>x", group = "Diagnostics" },
})
