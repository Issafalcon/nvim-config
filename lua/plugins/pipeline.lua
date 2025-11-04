vim.pack.add({
  { src = "https://github.com/topaxi/pipeline.nvim" },
})

vim.keymap.set("n", "<leader>gh", "<cmd>Pipeline<cr>", { desc = "Open Pipeline" })

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle pipeline updates",
  group = vim.api.nvim_create_augroup("pipeline-pack-changed", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" and event.data.spec.name == "pipeline" then
      vim.notify("pipeline updated, running make...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      -- Navigate to the avante.nvim directory and run 'make'
      local ok = os.execute("cd " .. event.data.spec.path .. " && make")

      if ok then
        vim.notify("make completed successfully!", vim.log.levels.INFO)
      end
    end
  end,
})

require("pipeline").setup({
  browser = "wsl-open",
})
