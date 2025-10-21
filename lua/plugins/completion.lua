vim.pack.add({
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-cmdline" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/David-Kunz/cmp-npm" },
  { src = "https://github.com/lukas-reineke/cmp-rg" },
  { src = "https://github.com/PasiBergman/cmp-nuget" },
})

vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

local cmp = require("cmp")
local nuget = require("cmp-nuget")

-- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
local sources = {
  lazydev = { name = "lazydev", priority = 1100, keyword_length = 2 },
  nvim_lsp = { name = "nvim_lsp", priority = 1000, keyword_length = 2 },
  nuget = { name = "nuget", priority = 800, keyword_length = 1 },
  -- nvim_lua = { name = "nvim_lua", priority = 800, keyword_length = 2 },
  luasnip = { name = "luasnip", priority = 750, keyword_length = 2 },
  npm = { name = "npm", priority = 725, keyword_length = 2 },
  emoji = { name = "emoji", priority = 700, keyword_length = 2 },
  buffer = { name = "buffer", priority = 500, keyword_length = 2 },
  path = { name = "path", priority = 250, keyword_length = 2 },
  rg = { name = "rg", priority = 200, keyword_length = 2 },
}

local common_sources = {
  sources.nvim_lsp,
  sources.luasnip,
  sources.rg,
  sources.emoji,
  -- sources.buffer,
  sources.path,
}

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
  },
  enabled = function()
    -- Change the deprecation function below to recommended replacement
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
      return false
    end
    return true
  end,
  preselect = cmp.PreselectMode.None,
  ---@diagnostic disable-next-line: missing-fields
  formatting = {
    fields = {
      cmp.ItemField.Abbr,
      cmp.ItemField.Kind,
      cmp.ItemField.Menu,
    },
    format = function(entry, item)
      if entry.source.name == "nuget" then
        item.kind = "NuGet"
        return item
      end

      local icon = fignvim.ui.get_icon("lsp", item.kind)
      if icon then
        item.kind = icon .. " " .. item.kind
      end

      local widths = {
        abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
        menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
      }

      for key, width in pairs(widths) do
        if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
          item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
        end
      end

      return item
    end,
  },
  snippet = {
    expand = function(args)
      local luasnip_ok, luasnip_plug = pcall(require, "luasnip")
      fignvim.fn.conditional_func(luasnip_plug.lsp_expand, luasnip_ok, args.body)
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
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Select,
    }),
    ["<C-j>"] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Select,
    }),
    ["<Up>"] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Insert,
    }),
    ["<Down>"] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Insert,
    }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- Fix for copilot key-mapping fallback mechanism issue - https://github.com/hrsh7th/nvim-cmp/blob/b16e5bcf1d8fd466c289eab2472d064bcd7bab5d/doc/cmp.txt#L830-L852
    ["<C-x>"] = cmp.mapping(function(_)
      vim.api.nvim_feedkeys(
        vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)),
        "n",
        true
      )
    end),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
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
  }),
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype("gitcommit", {
--   sources = cmp.config.sources({
--     { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = "buffer" },
--   }),
-- })

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
    { name = "cmdline" },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

cmp.setup.filetype("mysql", {
  sources = cmp.config.sources({
    { name = "vim-dadbod-completion" },
  }),
})

cmp.setup.filetype("xml", {
  sources = cmp.config.sources({
    sources.nuget,
    sources.rg,
  }),
})
