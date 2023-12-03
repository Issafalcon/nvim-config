return {
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
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
  },
}
