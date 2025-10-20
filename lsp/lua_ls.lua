return {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      codeLens = {
        enable = true,
      },
      diagnostics = {
        globals = {
          "vim",
          "require",
        },
      },
      workspace = {
        -- See https://github.com/folke/lazydev.nvim/discussions/94 for whether this is needed or not
        -- library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
