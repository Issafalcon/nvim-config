require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/snippets/vscode" } })
require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/snippets" } })

local ls = require("luasnip")
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

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.cmd([[
  command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()
]])

-- Edits snippet files loaded for the current filetype
-- (see https://github.com/L3MON4D3/LuaSnip/blob/69cb81cf7490666890545fef905d31a414edc15b/lua/luasnip/config.lua#L82-L104)
vim.keymap.set("n", "<leader><leader>s", ":LuaSnipEdit<CR>")
