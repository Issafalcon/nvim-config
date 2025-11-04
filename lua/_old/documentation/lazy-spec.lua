local neogen_config = require("documentation.plugin-config.neogen")

return {
  {
    "danymat/neogen",
    keys = fignvim.mappings.make_lazy_keymaps(require("keymaps").Annotations, true),
    opts = neogen_config.lazy_opts,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter", "nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ft = "markdown",
    opts = {},
  },

  {
    -- Syntax improvements for .puml files
    {
      "aklt/plantuml-syntax",
      event = { "BufRead *.puml", "BufWinEnter *.puml", "BufNewFile *.puml" },
    },
    -- Previewer for .puml files
    {
      "weirongxu/plantuml-previewer.vim",
      event = { "BufRead *.puml", "BufWinEnter *.puml", "BufNewFile *.puml" },
      dependencies = {
        "tyru/open-browser.vim",
      },
    },
  },

  {
    "vinnymeller/swagger-preview.nvim",
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    build = "npm i",
    config = true,
  },
}
