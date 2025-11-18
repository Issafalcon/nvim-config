vim.pack.add({
  { src = "https://github.com/b0o/schemastore.nvim" },
})

local function load_schemas()
  local schemastore_ok, schemastore = pcall(require, "schemastore")
  return schemastore_ok and schemastore.json.schemas() or {}
end

return {
  settings = {
    json = {
      schemas = load_schemas(),
      validate = { enable = true },
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
