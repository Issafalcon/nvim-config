local neogen_keys = {
  {
    "n",
    "<leader>/F",
    function() require("neogen").generate({ type = "file" }) end,
    { desc = "Generates filetype specific annotations for the nearest file" },
  },
  {
    "n",
    "<leader>/f",
    function() require("neogen").generate({ type = "func" }) end,
    { desc = "Generates filetype specific annotations for the nearest function" },
  },
  {
    "n",
    "<leader>/c",
    function() require("neogen").generate({ type = "class" }) end,
    { desc = "Generates filetype specific annotations for the nearest class" },
  },
  {
    "n",
    "<leader>/t",
    function() require("neogen").generate({ type = "type" }) end,
    { desc = "Generates filetype specific annotations for the nearest type" },
  },
}

return {
  {
    "danymat/neogen",
    keys = fignvim.mappings.make_lazy_keymaps(neogen_keys, true),
    opts = {
      snippet_support = "luasnip",
      languages = {
        cs = {
          template = {
            annotation_convention = "xmldoc",
          },
        },
      },
    },
  },
}
