local luasnip_keys = {
  {
    { "i", "s" },
    "<C-l>",
    function()
      local ls = require("luasnip")
      if ls.choice_active() then ls.change_choice() end
    end,
    { desc = "Toggle the next choice in the LuaSnip snippet" },
  },
  {
    { "i", "s" },
    "<C-k>",
    function()
      local ls = require("luasnip")
      if ls.expand_or_jumpable() then ls.expand_or_jump() end
    end,
    { desc = "Expand the snippet under the cursor or jump to next snippet placeholder" },
  },
  {
    { "i", "s" },
    "<C-j>",
    function()
      local ls = require("luasnip")
      if ls.jumpable(-1) then ls.jump(-1) end
    end,
    { desc = "Jump to the previous snippet placeholder" },
  },
  {
    "n",
    "<leader><leader>s",
    ":LuaSnipEdit<CR>",
    { desc = "Edit the snippet files for the filetype of the current buffer" },
  },
}

-- The best snippet engine
return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "robole/vscode-markdown-snippets",
      "J0rgeSerran0/vscode-csharp-snippets",
      "dsznajder/vscode-es7-javascript-react-snippets",
      "fivethree-team/vscode-svelte-snippets",
      "xabikos/vscode-react",
      "thomanq/math-snippets",
    },
    keys = fignvim.mappings.make_lazy_keymaps(luasnip_keys, true),
    event = "InsertEnter",
    config = function()
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
    end,
  },
}
