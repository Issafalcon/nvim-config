local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local luasnip = require("luasnip")
local lspkind = require("lspkind")
local highlight = require("cmp.utils.highlight")
local autocmd = require("cmp.utils.autocmd")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
  formatting = {
    fields = {
      cmp.ItemField.Kind,
      cmp.ItemField.Abbr,
      cmp.ItemField.Menu,
    },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. strings[1] .. " "
      kind.menu = "    (" .. strings[2] .. ")"

      return kind
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "treesitter" },
    { name = "luasnip" },
    { name = "npm", keyword_length = 4 },
    { name = "buffer" },
    { name = "path" },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    completion = {
      border = "rounded",
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline", keyword_pattern = "[^!]\\k\\+" },
  }),
})

autocmd.subscribe("ColorScheme", function()
  highlight.inherit("CmpItemKindField", "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
  highlight.inherit("PmenuSel", "PmenuSel", { bg = "#282C34", fg = "NONE" })
  highlight.inherit("Pmenu", "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

  highlight.inherit(
    "CmpItemAbbrDeprecated",
    "CmpItemAbbrDeprecated",
    { fg = "#7E8294", bg = "NONE", strikethrough = true }
  )
  highlight.inherit("CmpItemAbbrMatch", "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
  highlight.inherit("CmpItemAbbrMatchFuzzy", "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
  highlight.inherit("CmpItemMenu", "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

  highlight.inherit("CmpItemKindField", "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
  highlight.inherit("CmpItemKindProperty", "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
  highlight.inherit("CmpItemKindEvent", "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

  highlight.inherit("CmpItemKindText", "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
  highlight.inherit("CmpItemKindEnum", "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
  highlight.inherit("CmpItemKindKeyword", "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })

  highlight.inherit("CmpItemKindConstant", "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
  highlight.inherit("CmpItemKindConstructor", "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
  highlight.inherit("CmpItemKindReference", "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })

  highlight.inherit("CmpItemKindFunction", "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
  highlight.inherit("CmpItemKindStruct", "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
  highlight.inherit("CmpItemKindClass", "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
  highlight.inherit("CmpItemKindModule", "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
  highlight.inherit("CmpItemKindOperator", "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

  highlight.inherit("CmpItemKindVariable", "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
  highlight.inherit("CmpItemKindFile", "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

  highlight.inherit("CmpItemKindUnit", "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
  highlight.inherit("CmpItemKindSnippet", "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
  highlight.inherit("CmpItemKindFolder", "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

  highlight.inherit("CmpItemKindMethod", "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
  highlight.inherit("CmpItemKindValue", "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
  highlight.inherit("CmpItemKindEnumMember", "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

  highlight.inherit("CmpItemKindInterface", "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
  highlight.inherit("CmpItemKindColor", "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
  highlight.inherit("CmpItemKindTypeParameter", "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })
end)
