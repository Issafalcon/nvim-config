vim.pack.add({
  {
    src = "https://github.com/danymat/neogen",
  },
})

require("neogen").setup({
  snippet_support = "luasnip",
  languages = {
    cs = {
      template = {
        annotation_convention = "xmldoc",
      },
    },
  },
})

vim.keymap.set("n", "<leader>/F", function()
  require("neogen").generate({ type = "file" })
end, { desc = "Generates filetype specific annotations for the nearest file" })

vim.keymap.set("n", "<leader>/f", function()
  require("neogen").generate({ type = "func" })
end, { desc = "Generates filetype specific annotations for the nearest function" })

vim.keymap.set("n", "<leader>/c", function()
  require("neogen").generate({ type = "class" })
end, { desc = "Generates filetype specific annotations for the nearest class" })

vim.keymap.set("n", "<leader>/t", function()
  require("neogen").generate({ type = "type" })
end, { desc = "Generates filetype specific annotations for the nearest type" })
