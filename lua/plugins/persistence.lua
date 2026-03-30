vim.pack.add({
  { src = "https://github.com/folke/persistence.nvim" },
})

require("persistence").setup({})

-- load the session for the current directory
vim.keymap.set("n", "<leader>ps", function()
  require("persistence").load()
end, { desc = "Persistence: Load session for current dir" })

-- select a session to load
vim.keymap.set("n", "<leader>pS", function()
  require("persistence").select()
end, { desc = "Persistence: Select session to load" })

-- load the last session
vim.keymap.set("n", "<leader>pl", function()
  require("persistence").load({ last = true })
end, { desc = "Persistence: Load last session" })

-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>pd", function()
  require("persistence").stop()
end, { desc = "Persistence: Don't save current session" })
