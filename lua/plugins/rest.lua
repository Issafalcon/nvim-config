return {
  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    init = function()
      fignvim.config.set_vim_opts({
        g = {
          custom_dynamic_variables = {},
        },
      })
    end,
  },
}
