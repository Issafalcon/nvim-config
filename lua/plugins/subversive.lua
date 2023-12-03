local subversive_keys = {
  {
    "n",
    "s",
    "<plug>(SubversiveSubstitute)",
    { desc = "Subversive: Substitute the motion specified with whatever is in default yank register" },
  },
  {
    "n",
    "ss",
    "<plug>(SubversiveSubstituteLine)",
    { desc = "Subversive: Substitute the line with whatever is in default yank register" },
  },
  {
    "n",
    "S",
    "<plug>(SubversiveSubstituteToEndOfLine)",
    { desc = "Subversive: Substitute everything until the end of the line with whatever is in the yank register" },
  },
  {
    { "n", "x" },
    "<leader>s",
    "<plug>(SubversiveSubstituteRange)",
    {
      desc = "Subversive: Substitute all instances of the text in the first motion that exist in the text within the second motion",
    },
  },
  {
    "n",
    "<leader>ss",
    "<plug>(SubversiveSubstituteWordRange)",
    { desc = "Subversive: Substitute all instances of word under the cursor within the motion specified" },
  },
  {
    { "n", "x" },
    "<leader><leader>v",
    "<plug>(SubversiveSubvertRange)",
    {
      desc = "Subversive: Subvert all instances of the text in the first motion that exist in the text within the second motion",
    },
  },
  {
    "n",
    "<leader><leader>vv",
    "<plug>(SubversiveSubvertWordRange)",
    { desc = "Subversive: Subvert all instances of word under the cursor within the motion specified" },
  },
}

return {
  {
    "svermeulen/vim-subversive",
    event = "BufEnter",
    init = function()
      local opt = {
        g = {
          subversivePromptWithCurrent = 0,
          subversivePromptWithActualCommand = 1,
        },
      }

      fignvim.config.set_vim_opts(opt)
    end,
    keys = fignvim.mappings.make_lazy_keymaps(subversive_keys, true),
  },
}
