local vimtex_keys = {
  {
    "n",
    "\\lg",
    ":term latexmk-custom-launch.sh %:p<CR>",
    { desc = "Run a custom script to launch latex with bibliography", silent = true, noremap = true },
  },
  {
    "n",
    "\\lm",
    ":term pandoc-tex-to-mediawiki.sh %:p<CR>",
    {
      desc = "Run a custom script to convert a LaTeX file to mediawiki markdown, using elsevier citation styles for the bibliography",
      silent = true,
      noremap = true,
    },
  },
}

return {
  {
    "lervag/vimtex",
    ft = "tex",
    keys = fignvim.mappings.make_lazy_keymaps(vimtex_keys, true),
    init = function()
      fignvim.config.set_vim_opts({
        g = {
          vimtex_view_method = "zathura", -- set default viewer for vimtex
          vimtex_view_general_viewer = "zathura", -- set default viewer for vimtex
          vimtex_compiler_latexmk = {
            out_dir = "",
            callback = 1,
            continuous = 1,
            executable = "latexmk",
            hooks = {},
            options = {
              "-verbose",
              "-file-line-error",
              "-synctex=1",
              "-interaction=nonstopmode",
              "-shell-escape",
            },
          },
        },
      })
    end,
  },
}
