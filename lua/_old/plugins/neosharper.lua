return {
  {
    "Issafalcon/neosharper",
    dependencies = { "ColinKennedy/mega.cmdparse", "ColinKennedy/mega.logging" },
    config = function()
      vim.g.neosharper_configuration = {
        commands = {},
        logging = {
          level = "info",
          use_console = false,
          use_file = false,
        },
      }
    end,
  },
}
