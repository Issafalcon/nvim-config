---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  cmd_env = {
    TG_LS_LOG = vim.fn.stdpath("data") .. "/terragrunt-ls.log",
  },
}

M.lazy_config = function(_, opts)
  local terragrunt_ls = require("terragrunt-ls")
  terragrunt_ls.setup(opts)
  if terragrunt_ls.client then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "hcl",
      callback = function()
        vim.lsp.buf_attach_client(0, terragrunt_ls.client)
      end,
    })
  end
end

return M
