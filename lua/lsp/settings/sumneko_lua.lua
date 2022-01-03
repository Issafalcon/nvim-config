local opts = {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        globals = {"vim"}
      },
      workspace = {
        library = { vim.api.nvim_get_runtime_file("", true), vim.fn.expand("$DOTFILES/nvim/.config/nvim") },
        maxPreload = 100000,
        preloadFileSize = 1000
      }
    }
  }
}

return opts
