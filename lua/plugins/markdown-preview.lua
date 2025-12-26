vim.pack.add({
  {
    src = "https://github.com/iamcco/markdown-preview.nvim",
  },
})

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle fzf updates",
  group = vim.api.nvim_create_augroup("fzf-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind ~= "delete" and event.data.spec.name == "markdown-preview.nvim" then
      fignvim.ui.notify("markdown-preview updated, running Install...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.fn.call("mkdp#util#install", {}))
      if ok then
        fignvim.ui.notify("mkdp#util#install completed successfully!", vim.log.levels.INFO)
      else
        fignvim.ui.notify("mkdp#util#install function not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})
