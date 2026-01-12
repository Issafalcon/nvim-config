vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle vim.pack updates",
  group = vim.api.nvim_create_augroup("pipeline-pack-changed", { clear = true }),
  callback = function(event)
    -- Pipeline
    if event.data.kind ~= "delete" and event.data.spec.name == "pipeline" then
      vim.notify("pipeline updated, running make...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      -- Navigate to the avante.nvim directory and run 'make'
      local ok = os.execute("cd " .. event.data.spec.path .. " && make")

      if ok then
        vim.notify("make completed successfully!", vim.log.levels.INFO)
      end
    end

    -- Markdown Preview
    if event.data.kind ~= "delete" and event.data.spec.name == "markdown-preview.nvim" then
      fignvim.ui.notify("markdown-preview updated, running Install...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch

      if not event.data.active then
        vim.cmd.packadd("markdown-preview.nvim")
      end

      local ok = pcall(vim.fn.call("mkdp#util#install", {}))
      if ok then
        fignvim.ui.notify("mkdp#util#install completed successfully!", vim.log.levels.INFO)
      else
        fignvim.ui.notify("mkdp#util#install function not available yet, skipping", vim.log.levels.WARN)
      end
    end

    -- fzf
    if event.data.kind ~= "delete" and event.data.spec.name == "fzf" then
      vim.notify("fzf updated, running Install...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.fn["fzf#install"])
      if ok then
        vim.notify("fzf#install completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("fzf#install function not available yet, skipping", vim.log.levels.WARN)
      end
    end

    -- Treesitter
    if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
      vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})
