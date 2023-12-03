return {
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
}
