vim.pack.add({
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/robole/vscode-markdown-snippets" },
  { src = "https://github.com/J0rgeSerran0/vscode-csharp-snippets" },
  { src = "https://github.com/dsznajder/vscode-es7-javascript-react-snippets" },
  { src = "https://github.com/fivethree-team/vscode-svelte-snippets" },
  { src = "https://github.com/xabikos/vscode-react" },
  { src = "https://github.com/thomanq/math-snippets" },
})

local ls = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/snippets/vscode" } })
require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/snippets" } })

local types = require("luasnip.util.types")

ls.config.setup({
  history = true,
  update_events = "TextChanged,TextChangedI",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
})

vim.cmd([[
    command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()
]])

vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { desc = "Expand the snippet under the cursor or jump to next snippet placeholder" })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice()
  end
end, { desc = "Toggle the next choice in the LuaSnip snippet" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { desc = "Jump to the previous snippet placeholder" })
