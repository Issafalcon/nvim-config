local powershell_config = require("pwsh.plugin-configs.powershell")

return {
  {
    "TheLeoP/powershell.nvim",
    ---@type powershell.user_config
    opts = powershell_config.lazy_opts,
    ft = { "ps1", "psd1", "psm1", "ps1xml", "psc1", "pssc" },
  },
}
