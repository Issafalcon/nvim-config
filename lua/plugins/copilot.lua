vim.pack.add({ { src = "https://github.com/github/copilot.vim" } })

vim.g.copilot_no_tab_map = true
vim.g.copilot_proxy_strict_ssl = false

-- Accept a copilot suggestion with <C-x>. This replaces the old nvim-cmp
-- fallback workaround that lived in plugins/completion.lua.
vim.keymap.set("i", "<C-x>", 'copilot#Accept("")', {
  desc = "Accept Copilot suggestion",
  expr = true,
  replace_keycodes = false,
  silent = true,
})
