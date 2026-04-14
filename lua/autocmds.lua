-- Run a shell command asynchronously and route its stdout/stderr directly into
-- a snacks/noice notification window once it completes.
local function run_cmd_notify(cmd, cwd, title)
  vim.notify("Running…", vim.log.levels.INFO, { title = title })

  vim.system(
    { "sh", "-c", cmd },
    { cwd = cwd, text = true },
    vim.schedule_wrap(function(result)
      local stdout = vim.trim(result.stdout or "")
      local stderr = vim.trim(result.stderr or "")
      -- Prefer stderr for build tools (most relevant errors live there), fall
      -- back to stdout, fall back to a generic message.
      local output = stderr ~= "" and stderr or stdout

      -- Trim to the last 60 lines so the notification window stays readable.
      if output ~= "" then
        local lines = vim.split(output, "\n")
        if #lines > 60 then
          lines = vim.list_slice(lines, #lines - 59, #lines)
          table.insert(lines, 1, "… (output truncated, showing last 60 lines)")
        end
        output = table.concat(lines, "\n")
      end

      if result.code == 0 then
        vim.notify(output ~= "" and output or "Completed successfully.", vim.log.levels.INFO, { title = title })
      else
        vim.notify(
          output ~= "" and output or ("Failed (exit code " .. result.code .. ")."),
          vim.log.levels.ERROR,
          { title = title }
        )
      end
    end)
  )
end

-- Run a Vimscript command/function and route its captured output into a
-- snacks/noice notification window.
local function vimcmd_notify(cmd, title)
  vim.notify("Running…", vim.log.levels.INFO, { title = title })
  local ok, result = pcall(vim.api.nvim_exec2, cmd, { output = true })
  local output = ok and vim.trim(result.output or "") or tostring(result)
  local level = ok and vim.log.levels.INFO or vim.log.levels.WARN
  vim.notify(output ~= "" and output or (ok and "Done." or "Not available, skipping."), level, { title = title })
end

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle vim.pack updates",
  group = vim.api.nvim_create_augroup("pipeline-pack-changed", { clear = true }),
  callback = function(event)
    local path = event.data.path

    -- Pipeline
    if event.data.kind ~= "delete" and event.data.spec.name == "pipeline" then
      run_cmd_notify("make", path, "pipeline: make")
    end

    -- Markdown Preview
    if event.data.kind ~= "delete" and event.data.spec.name == "markdown-preview.nvim" then
      if not event.data.active then
        vim.cmd.packadd("markdown-preview.nvim")
      end
      vimcmd_notify("call mkdp#util#install()", "markdown-preview: install")
    end

    -- fzf
    if event.data.kind ~= "delete" and event.data.spec.name == "fzf" then
      vimcmd_notify("call fzf#install()", "fzf: install")
    end

    -- Treesitter
    if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
      vimcmd_notify("TSUpdate", "nvim-treesitter: TSUpdate")
    end

    -- Swagger Preview
    if event.data.kind ~= "delete" and event.data.spec.name == "swagger-preview.nvim" then
      run_cmd_notify("npm i", path, "swagger-preview: npm i")
    end

    -- Terragrunt Language Server – install then build sequentially via chained callbacks
    if event.data.kind ~= "delete" and event.data.spec.name == "terragrunt-ls" then
      local bin_path = vim.fn.stdpath("data") .. "/mason/bin/terragrunt-ls"
      vim.notify("Running…", vim.log.levels.INFO, { title = "terragrunt-ls: install" })
      vim.system(
        { "sh", "-c", "mise install && go install" },
        { cwd = path, text = true },
        vim.schedule_wrap(function(install_result)
          local out = vim.trim((install_result.stderr or "") .. (install_result.stdout or ""))
          if install_result.code ~= 0 then
            vim.notify(out ~= "" and out or "Failed.", vim.log.levels.ERROR, { title = "terragrunt-ls: install" })
            return
          end
          vim.notify(out ~= "" and out or "Done.", vim.log.levels.INFO, { title = "terragrunt-ls: install" })
          run_cmd_notify("go build -o " .. bin_path, path, "terragrunt-ls: go build")
        end)
      )
    end

    -- blink.cmp
    if event.data.kind ~= "delete" and event.data.spec.name == "blink.cmp" then
      if vim.fn.executable("cargo") == 0 then
        vim.notify("Cargo not in PATH, skipping build.", vim.log.levels.WARN, { title = "blink.cmp: build" })
        return
      end
      run_cmd_notify("cargo build --release", path, "blink.cmp: cargo build")
    end

    -- nvim-mcp
    if event.data.kind ~= "delete" and event.data.spec.name == "nvim-mcp" then
      if vim.fn.executable("cargo") == 0 then
        vim.notify("Cargo not in PATH, skipping install.", vim.log.levels.WARN, { title = "nvim-mcp: cargo install" })
        return
      end
      run_cmd_notify("cargo install --path .", path, "nvim-mcp: cargo install")
    end

    -- molten-nvim
    if event.data.kind ~= "delete" and event.data.spec.name == "molten-nvim" then
      vimcmd_notify("UpdateRemotePlugins", "molten-nvim: UpdateRemotePlugins")
    end
  end,
})
