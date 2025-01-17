require("ts_context_commentstring").setup()

fignvim.config.set_vim_opts({
  g = {
    skip_ts_context_commentstring_module = true,
  },
})
