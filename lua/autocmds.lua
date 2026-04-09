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

    -- Swagger Preview
    if event.data.kind ~= "delete" and event.data.spec.name == "swagger-preview.nvim" then
      vim.notify("swagger-preview.nvim updated, running npm i...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = os.execute("cd " .. event.data.path .. " && npm i")
      if ok then
        vim.notify("npm i completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("npm i failed, please check the output for details", vim.log.levels.ERROR)
      end
    end

    -- Terragrunt Language Server
    if event.data.kind ~= "delete" and event.data.spec.name == "terragrunt-ls" then
      vim.notify("terragrunt-ls updated, running go install...", vim.log.levels.INFO)

      local ok = os.execute("cd " .. event.data.path .. " && mise install && go install")

      if ok then
        vim.notify("go install completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("go install failed, please check the output for details", vim.log.levels.ERROR)
      end

      local build_ok = os.execute(
        "cd " .. event.data.path .. " && go build -o " .. vim.fn.stdpath("data") .. "/mason/bin/terragrunt-ls"
      )

      if build_ok then
        vim.notify("terragrunt-ls built successfully!", vim.log.levels.INFO)
      else
        vim.notify("Failed to build terragrunt-ls, please check the output for details", vim.log.levels.ERROR)
      end
    end

    -- blink.cmp
    if event.data.kind ~= "delete" and event.data.spec.name == "blink.cmp" then
      vim.notify("blink.cmp updated, running cargo build --release...", vim.log.levels.INFO)

      if vim.fn.executable("cargo") == 0 then
        vim.notify("Cargo is not installed or not in PATH, skipping build for blink.cmp", vim.log.levels.WARN)
        return
      end

      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = os.execute("cd " .. event.data.path .. " && cargo build --release")

      if ok then
        vim.notify("blink.cmp built successfully!", vim.log.levels.INFO)
      else
        vim.notify("blink.cmp build failed, please check the output for details", vim.log.levels.ERROR)
      end
    end

    -- nvim-mcp
    if event.data.kind ~= "delete" and event.data.spec.name == "nvim-mcp" then
      vim.notify("nvim-mcp updated, running cargo install...", vim.log.levels.INFO)
      -- Check if cargo is available
      if vim.fn.executable("cargo") == 0 then
        vim.notify("Cargo is not installed or not in PATH, skipping cargo install for nvim-mcp", vim.log.levels.WARN)
        return
      end

      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = os.execute("cd " .. event.data.path .. " && cargo install --path .")

      if ok then
        vim.notify("cargo install completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("cargo install failed, please check the output for details", vim.log.levels.ERROR)
      end
    end
  end,
})
