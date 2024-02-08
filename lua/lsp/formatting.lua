fignvim.lsp.formatting = {}

local formatting_config = {
  format_on_save = {
    -- Enable / disable formatting globally
    enabled = true,
    -- Enable / disable formatting on save for specific filetypes
    allow_filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "javascript.tsx",
      "typescript.tsx",
      "cs",
      "lua",
    },
    -- Disable formatting on save for specific filetypes
    ignore_filetypes = {},
  },
  -- Disable formatting capabilities for listed language servers
  disabled = {
    "lua_ls",
  },
  -- Formatting timeout
  timeout_ms = 4000,
}

local formatting_opts = {}

fignvim.lsp.formatting = vim.deepcopy(formatting_config)
formatting_opts.disabled = nil
formatting_opts.format_on_save = nil
formatting_opts.filter = function(client)
  local filter = formatting_config.filter
  local disabled = formatting_config.disabled or {}
  -- check if client is fully disabled or filtered by function
  return not (vim.tbl_contains(disabled, client.name) or (type(filter) == "function" and not filter(client)))
end

function fignvim.lsp.formatting.format() vim.lsp.buf.format(formatting_opts) end

function fignvim.lsp.formatting.create_buf_autocmds(bufnr, client_name)
  vim.api.nvim_buf_create_user_command(
    bufnr,
    "Format",
    function() vim.lsp.buf.format(formatting_opts) end,
    { desc = "Format file with LSP" }
  )

  local autoformat = fignvim.lsp.formatting.format_on_save
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if
    autoformat.enabled
    and (vim.tbl_isempty(autoformat.allow_filetypes or {}) or vim.tbl_contains(autoformat.allow_filetypes, filetype))
    and (vim.tbl_isempty(autoformat.ignore_filetypes or {}) or not vim.tbl_contains(autoformat.ignore_filetypes, filetype))
  then
    local autocmd_group = "auto_format_" .. bufnr
    vim.api.nvim_create_augroup(autocmd_group, { clear = true })
    if client_name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    else
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = autocmd_group,
        buffer = bufnr,
        desc = "Auto format buffer " .. bufnr .. " before save",
        callback = function()
          if vim.g.autoformat_enabled then vim.lsp.buf.format(fignvim.table.default_tbl({ bufnr = bufnr }, formatting_opts)) end
        end,
      })
    end
  end
end

return fignvim.lsp.formatting
