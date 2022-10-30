fignvim.lsp.formatting = {}

local formatting_config = require('user-configs.lsp').formatting
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

function fignvim.lsp.formatting.format()
  vim.lsp.buf.format(formatting_opts)
end

function fignvim.lsp.formatting.create_buf_commands(bufnr)
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
