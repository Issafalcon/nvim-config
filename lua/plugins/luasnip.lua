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

-- Snippet expansion and placeholder jumping (<Tab>/<S-Tab>) are handled by
-- blink.cmp via its 'snippet_forward' / 'snippet_backward' commands.
-- Only the choice-cycling binding stays here since blink has no equivalent.
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice()
  end
end, { desc = "Cycle to the next choice in the active LuaSnip choice node" })
