---@type FigNvimPluginConfig
local M = {}

local prettier_filetpyes = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
  "htmlangular",
}

local get_opts = function()
  local opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = "fallback", -- not recommended to change
    },
    formatters_by_ft = {
      lua = { "stylua" },
      fish = { "fish_indent" },
      sh = { "shfmt" },
      python = { "black" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
      prettier = function(_, ctx)
        return fignvim.formatting.has_parser(ctx, prettier_filetpyes)
      end,
    },
  }

  for _, ft in ipairs(prettier_filetpyes) do
    opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
    table.insert(opts.formatters_by_ft[ft], "prettier")
  end

  return opts
end

M.lazy_init = function()
  fignvim.formatting.register({
    name = "conform.nvim",
    priority = 100,
    primary = true,
    format = function(buf)
      require("conform").format({ bufnr = buf })
    end,
    sources = function(buf)
      local ret = require("conform").list_formatters(buf)

      ---@param v conform.FormatterInfo
      return vim.tbl_map(function(v)
        return v.name
      end, ret)
    end,
  })
end

M.lazy_opts = get_opts()

M.setup = function()
  M.lazy_init()
  require("conform").setup(M.lazy_opts)
end

return M
