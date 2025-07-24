---@type FigNvimPluginConfig
local M = {}

M.lazy_config = function(_, _)
  -- Fetch the api-key from the environment variable
  local api_key = os.getenv("JIRA_API_KEY")
  local jira_domain = os.getenv("JIRA_DOMAIN")
  local email = os.getenv("JIRA_EMAIL")

  require("jirac").setup({
    email = email,
    jira_domain = jira_domain,
    api_key = api_key,
    config = {
      default_project_key = "INFSAAS",
      keymaps = {
        ["keymap_name"] = {
          mode = "n",
          key = "q",
        },
      },
      window_width = 150,
      window_height = 50,
    },
  })
end

return M
