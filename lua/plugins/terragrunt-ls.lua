-- Terragrunt Language Server plugin
-- See: https://github.com/gruntwork-io/terragrunt-ls
vim.pack.add({
  { src = "https://github.com/gruntwork-io/terragrunt-ls" },
})

local ok, terragrunt_ls = pcall(require, "terragrunt-ls")

if not ok then
  vim.notify("Failed to load terragrunt-ls plugin", vim.log.levels.ERROR)
  return
else
  terragrunt_ls.setup({
    cmd_env = {
      -- Enable logging for debugging (comment out in production)
      TG_LS_LOG = vim.fn.stdpath("data") .. "/terragrunt-ls.log",
    },
  })

  -- Attach the language server to HCL files
  if terragrunt_ls.client then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "hcl",
      callback = function()
        vim.lsp.buf_attach_client(0, terragrunt_ls.client)
      end,
      desc = "Attach terragrunt-ls to HCL files",
    })
  end
end
