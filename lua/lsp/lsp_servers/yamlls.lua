M = {}

local function load_schemas()
  local schemastore_ok, schemastore = pcall(require, "schemastore")
  return schemastore_ok and schemastore.yaml.schemas() or {}
end

M.opts = {
  settings = {
    yaml = {
      schemas = require("schemastore").yaml.schemas({
        extra = {
          {
            description = "Azure DevOps Pipeline Yaml schema",
            name = "azure-pipelines",
            fileMatch = { "*.yml", "*.yaml", "*pipelines.yml", "*pipelines.yaml" },
            url = "https://dev.azure.com/awsmtech/_apis/distributedtask/yamlschema",
          },
        },
      }),
      schemaStore = {
        -- Disable built-in schemaStore support if you want to use schemastore plugin
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
    },
  },
}

return M
