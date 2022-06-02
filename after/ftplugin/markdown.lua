local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

vim.cmd [[
  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end
]]

cmp.setup.buffer({
  sources = {
    { name = "luasnip" },
    { name = "spell" },
    {
      name = "buffer",
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = "path" },
  },
})
