local terragrunt_ls_config = require("lsp.plugin-config.terragrunt-ls")

return {
  {
    "gruntwork-io/terragrunt-ls",
    ft = "hcl",
    build = "go build -o " .. vim.fn.stdpath("data") .. "/mason/bin/terragrunt-ls",
    opts = terragrunt_ls_config.lazy_opts,
    config = terragrunt_ls_config.lazy_config,
  },
}
