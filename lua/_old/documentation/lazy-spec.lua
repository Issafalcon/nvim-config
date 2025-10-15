local neogen_config = require("documentation.plugin-config.neogen")
local obsidian_config = require("documentation.plugin-config.obsidian")

return {
  {
    "danymat/neogen",
    keys = fignvim.mappings.make_lazy_keymaps(require("keymaps").Annotations, true),
    opts = neogen_config.lazy_opts,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      "BufReadPre "
        .. vim.fn.expand("~")
        .. "/repos/obsidian-notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = obsidian_config.lazy_opts,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
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
