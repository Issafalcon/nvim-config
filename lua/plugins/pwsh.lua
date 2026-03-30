local pwsh_loaded = false

vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = { "*.ps1", "*.psm1" },
  callback = function()
    if not pwsh_loaded then
      vim.pack.add({
        {
          src = "https://github.com/TheLeoP/powershell.nvim",
        },
      })

      require("powershell").setup({
        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
      })

      pwsh_loaded = true
    end
  end,
})
