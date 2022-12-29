local create_command = vim.api.nvim_create_user_command

create_command("FignvimReload", function()
  fignvim.updater.reload()
end, { desc = "Reload FigNvim" })
