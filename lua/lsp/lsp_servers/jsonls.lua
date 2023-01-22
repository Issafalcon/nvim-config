M = {}

local function load_schemas()
  local schemastore_ok, schemastore = pcall(require, "schemastore")
  return schemastore_ok and schemastore.json.schemas() or {}
end

M.opts = {
  settings = {
    json = {
      schemas = load_schemas()
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
        end,
      },
    },
  },
}

return M
