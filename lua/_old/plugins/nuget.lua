return {
  {
    "d7omdev/nuget.nvim",
    dependencies = {
      "plenary.nvim",
      "telescope.nvim",
    },
    ft = "cs",
    cmd = { "NuGetInstall", "NuGetRemove" },
    config = function()
      require("nuget").setup()
    end,
  },
}
