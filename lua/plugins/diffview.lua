vim.pack.add({
  { src = "https://github.com/sindrets/diffview.nvim" },
})

-- Lazy load on command
vim.api.nvim_create_user_command("DiffviewLoad", function(_)
  require("diffview").setup({})
end, { nargs = 0, desc = "Load Diffview.nvim" })
