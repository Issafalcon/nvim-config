fignvim.lsp.formatting = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: vim.lsp.Client):boolean}

---@param opts? FigNvimFormatter| {filter?: (string|lsp.Client.filter)}
function fignvim.lsp.formatting.get_formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter lsp.Client.filter
  ---@type FigNvimFormatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      fignvim.lsp.servers.format(fignvim.table.merge({}, filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = vim.lsp.get_clients(fignvim.table.merge({}, filter, { bufnr = buf }))

      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client.supports_method("textDocument/formatting")
          or client.supports_method("textDocument/rangeFormatting")
      end, clients)

      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return fignvim.table.merge(ret, opts) --[[@as FigNvimFormatter]]
end

---@alias lsp.Client.format {timeout_ms?: number, format_options?: table} | lsp.Client.filter

---@param opts? lsp.Client.format
function fignvim.lsp.formatting.format(opts)
  opts = vim.tbl_deep_extend(
    "force",
    {},
    opts or {},
    require("lsp.plugin-config-nvim-lspconfig").lazy_opts.format or {},
    require("formatting.plugin-configs.conform").lazy_opts.default_format_opts or {}
  )
  local ok, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    opts.formatters = {}
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end
