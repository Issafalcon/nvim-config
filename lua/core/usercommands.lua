local create_command = vim.api.nvim_create_user_command

create_command("FignvimReload", function() fignvim.updater.reload() end, { desc = "Reload FigNvim" })

create_command("PluginDev", function() vim.g.plugin_dev = true end, { desc = "Run FigNvim in Plugin Development modes" })
