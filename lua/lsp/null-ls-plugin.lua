local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
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
    formatting.eslint_d,
    formatting.shfmt,
    formatting.markdownlint,
    diagnostics.yamllint,
    diagnostics.shellcheck,
    diagnostics.vint,
    diagnostics.eslint_d,
    diagnostics.chktex,
    code_actions.eslint_d,
    code_actions.refactoring
  },
})
