vim.pack.add({
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
})

require("ibl").setup({
  indent = {
    char = "│",
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
    injected_languages = false,
    highlight = { "Function", "Label" },
    priority = 500,
  },
  exclude = {
    filetypes = {
      "Trouble",
      "alpha",
      "dashboard",
      "help",
      "lazy",
      "mason",
      "neo-tree",
      "notify",
      "snacks_dashboard",
      "snacks_notif",
      "snacks_terminal",
      "snacks_win",
      "toggleterm",
      "trouble",
    },
  },
})
