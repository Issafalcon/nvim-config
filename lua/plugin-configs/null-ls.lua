local null_ls = fignvim.plug.load_module_file("null-ls")
if not null_ls then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = true,
  sources = {
    formatting.prettier.with({ extra_args = { "--single-quote", "--jsx-single-quote" } }),
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.stylua,
    -- Use project-local exe only
    -- https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils#configuring-sources
    formatting.eslint_d.with({
      only_local = "node_modules/.bin",
    }),
    formatting.shfmt,
    formatting.markdownlint,
    diagnostics.yamllint,
    diagnostics.shellcheck,
    diagnostics.vint,
    diagnostics.eslint_d.with({
      only_local = "node_modules/.bin",
    }),
    diagnostics.chktex,
    code_actions.eslint.with({
      prefer_local = "node_modules/.bin",
    }),
    code_actions.refactoring,
  },
  on_attach = fignvim.lsp.on_attach
})