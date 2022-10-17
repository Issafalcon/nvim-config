local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
  return
end

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/snippets/vscode" } })
require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/snippets" } })

local maps = require("custom_config").mappings
local mapper = require("utils.mapper")
local opts = { noremap = true, silent = true }
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

vim.keymap.set({ "i", "s" }, maps.completion.snippet_choice, function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
--, opts, "Completion", "cmp_snippet_choice", "Toggle the next choice in the LuaSnip snippet when available")

vim.keymap.set({ "i", "s" }, maps.completion.snippet_expand_or_next, function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)
-- ,
--   opts,
--   "Completion",
--   "cmp_snippet_expand",
--   "Expand the snippet under the cursor or jump to next snippet placeholder"
-- )

vim.keymap.set({ "i", "s" }, maps.completion.snippet_previous, function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)
--, opts, "Completion", "cmp_snippet_previous", "Jump to the previous snippet placeholder")

vim.cmd([[
  command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()
]])

-- Edits snippet files loaded for the current filetype
-- (see https://github.com/L3MON4D3/LuaSnip/blob/69cb81cf7490666890545fef905d31a414edc15b/lua/luasnip/config.lua#L82-L104)
mapper.map(
  "n",
  maps.completion.edit_snippet,
  ":LuaSnipEdit<CR>",
  opts,
  "Completion",
  "cmp_snippet_edit",
  "Edit the snippet files for the filetype of the current buffer"
)
