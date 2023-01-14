local vimtex_keys = {
  {
    "n",
    "\\lg",
    ":Start latexmk-custom-launch.sh %:p<CR>",
    { desc = "Run a custom script to launch latex with bibliography", silent = true, noremap = true },
  },
}

local vimtex_spec = {
  "lervag/vimtex",
  ft = "tex",
  keys = fignvim.config.make_lazy_keymaps(vimtex_keys, false),
}

return {
  vimtex_spec,
}
