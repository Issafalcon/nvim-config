local opts = { noremap = true, silent = true, buffer = 0 }

vim.keymap.set("n", "<Tab>", "<Cmd>call search('\\[[^]]*\\]([^)]\\+)')<CR>", opts)
vim.keymap.set("n", "<S-Tab>", "<Cmd>call search('\\[[^]]*\\]([^)]\\+)', 'b')<CR>", opts)

vim.o.wrap = true
vim.o.spell = true
