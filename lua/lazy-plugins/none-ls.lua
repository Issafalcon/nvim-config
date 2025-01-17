-- https://github.com/nvimtools/none-ls.nvim
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = true,
  sources = {
    formatting.prettier.with({
      -- extra_args = { "--single-quote", "--jsx-single-quote" },
      condition = function(utils)
        return utils.root_has_file({
          -- https://prettier.io/docs/en/configuration.html
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.json5",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.toml",
          "prettier.config.js",
          "prettier.config.cjs",
        })
      end,
    }),
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.yamlfmt,
    formatting.stylua,
    formatting.shfmt,
    -- formatting.sql_formatter.with({
    --   filetypes = { "sql", "mysql", "mariadb", "pgsql" },
    -- }),
    formatting.sqlfluff.with({
      extra_args = { "--dialect", "mysql" },
      filetypes = { "sql", "mysql", "mariadb", "pgsql" },
    }),
    formatting.clang_format.with({
      filetypes = { "c", "cpp", "objc", "objcpp", "h" },
    }),
    formatting.markdownlint,
    diagnostics.yamllint,
    diagnostics.vint,
    code_actions.refactoring,
  },
  on_attach = fignvim.lsp.on_attach,
})
