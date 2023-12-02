local neogen_keys = {
  {
    "n",
    "<leader>/F",
    function() require("neogen").generate({ type = "file" }) end,
    { desc = "Generates filetype specific annotations for the nearest file" },
  },
  {
    "n",
    "<leader>/f",
    function() require("neogen").generate({ type = "func" }) end,
    { desc = "Generates filetype specific annotations for the nearest function" },
  },
  {
    "n",
    "<leader>/c",
    function() require("neogen").generate({ type = "class" }) end,
    { desc = "Generates filetype specific annotations for the nearest class" },
  },
  {
    "n",
    "<leader>/t",
    function() require("neogen").generate({ type = "type" }) end,
    { desc = "Generates filetype specific annotations for the nearest type" },
  },
}

local neogen_spec = {
  "danymat/neogen",
  keys = fignvim.mappings.make_lazy_keymaps(neogen_keys, true),
  opts = {
    snippet_support = "luasnip",
    languages = {
      cs = {
        template = {
          annotation_convention = "xmldoc",
        },
      },
    },
  },
}

local plantuml_spec = {
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
}

local markdown_preview_spec = {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function() vim.g.mkdp_filetypes = { "markdown" } end,
  ft = { "markdown" },
}

return fignvim.module.enable_registered_plugins({
  ["neogen"] = neogen_spec,
  ["plantuml"] = plantuml_spec,
  ["markdown-preview"] = markdown_preview_spec,
}, "documenting")
