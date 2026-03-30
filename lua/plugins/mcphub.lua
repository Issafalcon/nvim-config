vim.pack.add({
  { src = "https://github.com/ravitemer/mcphub.nvim" },
})

require("mcphub").setup({
  -- Your configuration here
  config = vim.fn.expand("~/.config/mcphub/servers.json"),
  global_env = {
    "CONFLUENCE_URL",
    "CONFLUENCE_USERNAME",
    "CONFLUENCE_API_TOKEN",
    "JIRA_URL",
    "JIRA_USERNAME",
    "JIRA_API_TOKEN",
  },
})
