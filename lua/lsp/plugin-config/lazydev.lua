---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
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
    -- add the cmp source for completion of:
    -- `require "modname"`
    -- `---@module "modname"`
    cmp = true,
    coq = false,
  },
}

M.setup = function()
  require("lazydev").setup(M.lazy_opts)
end

return M
