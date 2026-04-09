vim.pack.add({
  { src = "https://github.com/folke/lazydev.nvim" },
})

require("lazydev").setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
  integrations = {
    -- Fixes lspconfig's workspace management for LuaLS
    -- Only create a new workspace if the buffer is not part
    -- of an existing workspace or one of its libraries
    lspconfig = true,
    -- blink.cmp uses its own lazydev provider (see plugins/blink-cmp.lua)
    cmp = false,
    coq = false,
  },
})
