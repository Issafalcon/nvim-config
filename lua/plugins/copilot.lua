vim.pack.add({ { src = "https://github.com/github/copilot.vim" } })

vim.g.copilot_no_tab_map = true
vim.g.copilot_proxy_strict_ssl = false

vim.keymap.set("i", "<Plug>(vimrc:copilot-dummy-map)", 'copilot#Accept("")', {
  desc = "Copilot dummy accept to workaround fallback issues with nvim-cmp",
  expr = true,
  silent = true,
})
