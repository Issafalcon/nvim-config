local spectre_keys = {
  {
    "n",
    "<leader>S",
    ":lua require('spectre').open()<CR>",
    { desc = "Open Spectre Panel" },
  },
  {
    "n",
    "<leader>sw",
    ":lua require('spectre').open_visual({select_word=true})<CR>",
    { desc = "Search for current word under cursor" },
  },
  {
    "v",
    "<leader>s",
    ":lua require('spectre').open_visual()<CR>",
    { desc = "Search for current selection" },
  },
  {
    "n",
    "<leader>sp",
    ":lua require('spectre').open_file_search()<CR>",
    { desc = "Search for text in current file" },
  },
}

return {
  {
    "windwp/nvim-spectre",
    keys = fignvim.mappings.make_lazy_keymaps(spectre_keys, true),
    config = true,
  },
}
