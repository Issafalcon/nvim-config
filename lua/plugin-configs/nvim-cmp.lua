local cmp = fignvim.plug.load_module_file("cmp")
local luasnip = fignvim.plug.load_module_file("luasnip")

if not (cmp and luasnip) then
  return
end

local mappings = fignvim.config.get_plugin_mappings("nvim-cmp", true)
local copilot_mappings = fignvim.config.get_plugin_mappings("copilot.vim", true)

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local sources = {
  nvim_lsp = { name = "nvim_lsp", priority = 1000, keyword_length = 2 },
  nvim_lua = { name = "nvim_lua", priority = 800, keyword_length = 2 },
  luasnip = { name = "luasnip", priority = 750, keyword_length = 2 },
  npm = { name = "npm", priority = 725, keyword_length = 4 },
  emoji = { name = "emoji", priority = 700, keyword_length = 2 },
  rg = { name = "rg", priority = 600, keyword_length = 2 },
  buffer = { name = "buffer", priority = 500, keyword_length = 2 },
  path = { name = "path", priority = 250, keyword_length = 3 },
}

local common_sources = { sources.nvim_lsp, sources.luasnip, sources.rg, sources.emoji, sources.buffer, sources.path }

cmp.setup({
  enabled = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    return vim.g.cmp_enabled
  end,
  preselect = cmp.PreselectMode.None,
  formatting = {
    fields = {
      cmp.ItemField.Abbr,
      cmp.ItemField.Kind,
      cmp.ItemField.Menu,
    },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. strings[1] .. " "
      kind.menu = "(" .. strings[2] .. ")"

      return kind
    end,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources(common_sources),
  duplicates = {
    nvim_lsp = 1,
    luasnip = 1,
    cmp_tabnine = 1,
    buffer = 1,
    path = 1,
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    completion = {
      border = "none",
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      max_width = 80,
      max_height = 50,
    },
  },
  mapping = {
    [mappings.cmp_prev_item.lhs] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    [mappings.cmp_next_item.lhs] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    [mappings.cmp_prev_item_alt.lhs] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    [mappings.cmp_next_item_alt.lhs] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    [mappings.cmp_scroll_up.lhs] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    [mappings.cmp_scroll_down.lhs] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    [mappings.cmp_complete.lhs] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    [mappings.cmp_disable.lhs] = cmp.config.disable,
    [mappings.cmp_abort.lhs] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    [mappings.cmp_confirm.lhs] = cmp.mapping.confirm({ select = false }),
    -- Fix for copilot key-mapping fallback mechanism issue - https://github.com/hrsh7th/nvim-cmp/blob/b16e5bcf1d8fd466c289eab2472d064bcd7bab5d/doc/cmp.txt#L830-L852
    [copilot_mappings.accept_suggestion.lhs] = cmp.mapping(function(fallback)
      vim.api.nvim_feedkeys(
        vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)),
        "n",
        true
      )
    end),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype("gitcommit", {
--   sources = cmp.config.sources({
--     { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = "buffer" },
--   }),
-- })

cmp.setup.filetype("lua", {
  sources = cmp.config.sources(
    vim.tbl_deep_extend("force", cmp.config.sources(common_sources), {
      sources.nvim_lua,
    }),
    {
      { name = "buffer" },
    }
  ),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline", keyword_pattern = "[^!]\\k\\+" },
  }),
})
