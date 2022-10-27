fignvim.lsp.formatting = {}

local formatting_config = fignvim.config.get_config("lsp").formatting
fignvim.lsp.formatting.opts = vim.deepcopy(formatting_config)
fignvim.lsp.formatting.opts.disabled = nil
fignvim.lsp.formatting.opts.format_on_save = nil
fignvim.lsp.formatting.opts.filter = function(client)
  local filter = formatting_config.filter
  local disabled = formatting_config.disabled or {}
  -- check if client is fully disabled or filtered by function
  return not (vim.tbl_contains(disabled, client.name) or (type(filter) == "function" and not filter(client)))
end

function fignvim.lsp.formatting.format()
  vim.lsp.buf.format(fignvim.lsp.formatting.opts)
end

function fignvim.lsp.formatting.create_buf_commands(bufnr)
    vim.api.nvim_buf_create_user_command(
      bufnr,
      "Format",
      function() vim.lsp.buf.format(fignvim.lsp.formatting.opts) end,
      { desc = "Format file with LSP" }
    )

    local autoformat = fignvim.lsp.formatting.opts.format_on_save
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if
      autoformat.enabled
      and (vim.fn.tbl_isempty(autoformat.allow_filetypes or {}) or vim.fn.tbl_contains(autoformat.allow_filetypes, filetype))
      and (vim.fn.tbl_isempty(autoformat.ignore_filetypes or {}) or not vim.fn.tbl_contains(autoformat.ignore_filetypes, filetype))
    then
      local autocmd_group = "auto_format_" .. bufnr
      vim.api.nvim_create_augroup(autocmd_group, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = autocmd_group,
        buffer = bufnr,
        desc = "Auto format buffer " .. bufnr .. " before save",
        callback = function()
          if vim.g.autoformat_enabled then
            vim.lsp.buf.format(fignvim.table.default_tbl({ bufnr = bufnr }, fignvim.lsp.formatting.opts))
          end
        end,
      })
    end
end

return fignvim.lsp.formatting