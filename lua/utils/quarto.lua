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

return fignvim.quarto
