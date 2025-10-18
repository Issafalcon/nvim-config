vim.pack.add({
  { src = "https://github.com/yetone/avante.nvim" },
})

require("avante").setup({
  provider = "copilot",
  windows = {
    input = {
      prefix = "▶",
      height = 15,
    },
  },
})

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle avante updates",
  group = vim.api.nvim_create_augroup("avante-pack-changed", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" and event.data.spec.name == "avante" then
      vim.notify("avante updated, running make...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      -- Navigate to the avante.nvim directory and run 'make'
      local ok = os.execute("cd " .. event.data.spec.path .. " && make")

      if ok then
        vim.notify("make completed successfully!", vim.log.levels.INFO)
      end
    end
  end,
})
