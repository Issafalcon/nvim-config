local ls = fignvim.plug.load_module_file("luasnip")
if not ls then
  return
end

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

fignvim.luasnip = {}

function fignvim.luasnip.change_choice()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end

function fignvim.luasnip.jump_next()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end

function fignvim.luasnip.jump_prev()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end

return fignvim.luasnip
