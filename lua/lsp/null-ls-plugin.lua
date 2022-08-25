local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") and client.name == "null-ls" then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.formatting_sync({}, 2500)
        end,
      })
    end
  end,
})
