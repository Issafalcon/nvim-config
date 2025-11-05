vim.pack.add({
  { src = "https://github.com/ravitemer/mcphub.nvim" },
})

require("mcphub").setup({
  -- Your configuration here
  config = vim.fn.expand("~/.config/mcphub/servers.json"),
})
