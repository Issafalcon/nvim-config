local vimtex_keys = {
  {
    "n",
    "\\lg",
    ":term latexmk-custom-launch.sh %:p<CR>",
    { desc = "Run a custom script to launch latex with bibliography", silent = true, noremap = true },
  },
}

local vimtex_spec = {
  "lervag/vimtex",
  ft = "tex",
  keys = fignvim.mappings.make_lazy_keymaps(vimtex_keys, true),
  init = function()
    fignvim.config.set_vim_opts({
      g = {
        vimtex_view_method = "zathura", -- set default viewer for vimtex
        vimtex_view_general_viewer = "zathura", -- set default viewer for vimtex
        vimtex_compiler_latexmk = {
          build_dir = "",
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
}

return fignvim.module.enable_registered_plugins({
  ["vimtex"] = vimtex_spec,
}, "tex")
