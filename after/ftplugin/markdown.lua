local opts = { noremap = true, silent = true, buffer = 0 }

vim.keymap.set("n", "<Tab>", "<Cmd>call search('\\[[^]]*\\]([^)]\\+)')<CR>", opts)
vim.keymap.set("n", "<S-Tab>", "<Cmd>call search('\\[[^]]*\\]([^)]\\+)', 'b')<CR>", opts)

vim.o.wrap = true
vim.o.spell = true

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then return end

cmp.setup.buffer({
  sources = {
    { name = "luasnip" },
    { name = "spell" },
    {
      name = "buffer",
      option = {
        get_bufnrs = function() return vim.api.nvim_list_bufs() end,
      },
    },
    { name = "path" },
  },
})
