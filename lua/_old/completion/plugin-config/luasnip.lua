---@type FigNvimPluginConfig
local M = {}

function M.lazy_config()
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
end

return M
