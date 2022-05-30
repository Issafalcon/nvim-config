require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/snippets/vscode" } })


local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.setup({
  history = true,
  update_events = 'TextChanged, TextChangedI',
  ext_opts = {
    [types.choiceNode] = {
      active = {
      virt_text = { { " <- Current Choice", "NonTest" } },}
    }
  }
})

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/snippets/luasnip/plugin<CR>")
