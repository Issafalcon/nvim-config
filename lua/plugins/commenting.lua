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

local comment_spec = {
  "numToStr/Comment.nvim",
  keys = { "gc", "gb", "g<", "g>" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- code
    local comment = require("Comment")
    comment.setup({
      opleader = {
        line = "gc",
        block = "gb",
      },
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
}

local neogen_spec = {
  "danymat/neogen",
  keys = fignvim.config.make_lazy_keymaps(neogen_keys, true),
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
}

return {
  comment_spec,
  neogen_spec,
}
