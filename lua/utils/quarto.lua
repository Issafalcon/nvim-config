fignvim.quarto = {}

local api = vim.api

-- Helper to extract all 'format' values from YAML front matter
local function get_formats_from_front_matter(bufnr)
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if lines[1] ~= "---" then
    return nil
  end
  local formats = {}
  local in_format_block = false
  local format_indent = nil
  for i = 2, #lines do
    if lines[i] == "---" then
      break
    end
    -- Check for 'format:' line
    if lines[i]:match("^format:%s*$") then
      in_format_block = true
      format_indent = nil
    elseif in_format_block then
      -- Detect indentation level of the first format key
      local key, rest = lines[i]:match("^(%s*)([%w_-]+):")
      if key and rest then
        if not format_indent then
          format_indent = #key
        end
        -- Only consider keys at the correct indentation (direct children of 'format:')
        if #key == format_indent then
          table.insert(formats, rest)
        elseif #key < format_indent then
          -- End of format block
          break
        end
      elseif lines[i]:match("^%S") then
        -- End of format block if a non-indented line is found
        break
      end
    end
  end
  if #formats > 0 then
    return formats
  end
  return nil
end

function fignvim.quarto.render_quarto()
  local bufnr = api.nvim_get_current_buf()
  local filepath = api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    vim.notify("Buffer has no file path!", vim.log.levels.ERROR)
    return
  end

  local formats = get_formats_from_front_matter(bufnr)
  if not formats then
    vim.notify("No 'format' found in front matter!", vim.log.levels.ERROR)
    return
  end

  Snacks.picker.select(formats, {
    prompt = "Select format to render:",
  }, function(selected)
    if not selected then
      return
    end
    local cmd = string.format("quarto render %s --to %s", vim.fn.shellescape(filepath), selected)
    vim.cmd("split | terminal " .. cmd)
  end)
end

--- Convert a .qmd file to Obsidian-compatible markdown with inline rendered output.
--- Uses `quarto render --to gfm` to produce a .md file with executed code output
--- and embedded chart images alongside the source .qmd file.
--- @param opts? { venv?: string, remove_code?: boolean }
---   venv: path to a Python venv to activate before rendering (default: ~/python3/envs/neovim)
---   remove_code: if true, strip source code blocks from the output, keeping only results (default: false)
function fignvim.quarto.convert_to_obsidian_md(opts)
  opts = opts or {}
  local bufnr = api.nvim_get_current_buf()
  local filepath = api.nvim_buf_get_name(bufnr)

  if filepath == "" then
    vim.notify("Buffer has no file path!", vim.log.levels.ERROR)
    return
  end

  if not filepath:match("%.qmd$") then
    vim.notify("Current file is not a .qmd file!", vim.log.levels.ERROR)
    return
  end

  local venv = opts.venv or vim.fn.expand("~/python3/envs/neovim")
  local activate_script = venv .. "/bin/activate"

  if vim.fn.filereadable(activate_script) == 0 then
    vim.notify("Python venv not found at: " .. venv, vim.log.levels.ERROR)
    return
  end

  local escaped_path = vim.fn.shellescape(filepath)
  local cmd = string.format(
    "source %s && quarto render %s --to gfm",
    vim.fn.shellescape(activate_script),
    escaped_path
  )

  vim.notify("Converting to Obsidian markdown...", vim.log.levels.INFO)

  vim.fn.jobstart({ "bash", "-c", cmd }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code ~= 0 then
          vim.notify("Quarto render failed (exit code " .. exit_code .. ")", vim.log.levels.ERROR)
          return
        end

        local md_path = filepath:gsub("%.qmd$", ".md")

        if opts.remove_code then
          fignvim.quarto._strip_code_blocks(md_path)
        end

        vim.notify("Converted: " .. vim.fn.fnamemodify(md_path, ":t"), vim.log.levels.INFO)
      end)
    end,
  })
end

--- Strip source code blocks from a rendered markdown file, keeping output blocks.
--- @param md_path string
function fignvim.quarto._strip_code_blocks(md_path)
  local lines = {}
  for line in io.lines(md_path) do
    table.insert(lines, line)
  end

  local result = {}
  local in_code_block = false
  local skip_block = false

  for _, line in ipairs(lines) do
    if not in_code_block and line:match("^```%s*python") then
      in_code_block = true
      skip_block = true
    elseif in_code_block and line:match("^```%s*$") then
      in_code_block = false
      if skip_block then
        skip_block = false
      else
        table.insert(result, line)
      end
    elseif not skip_block then
      table.insert(result, line)
    end
  end

  local f = io.open(md_path, "w")
  if f then
    f:write(table.concat(result, "\n") .. "\n")
    f:close()
  end
end

-- User Commands
vim.api.nvim_create_user_command("QuartoRender", function()
  fignvim.quarto.render_quarto()
end, { desc = "Render current .qmd file to a selected format" })

vim.api.nvim_create_user_command("QuartoToObsidian", function(args)
  local opts = {}
  if args.bang then
    opts.remove_code = true
  end
  fignvim.quarto.convert_to_obsidian_md(opts)
end, { bang = true, desc = "Convert .qmd to Obsidian markdown (! to strip code blocks)" })

return fignvim.quarto
