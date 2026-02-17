local icons = require('icons')

local M = {}

-- Helper: get current mode name and highlight group
local function mode_info()
  local mode_map = {
    n = { 'NORMAL', 'StatuslineModeNormal' },
    i = { 'INSERT', 'StatuslineModeInsert' },
    v = { 'VISUAL', 'StatuslineModeVisual' },
    V = { 'V-LINE', 'StatuslineModeVisual' },
    ['\22'] = { 'V-BLOCK', 'StatuslineModeVisual' },
    c = { 'COMMAND', 'StatuslineModeCommand' },
    s = { 'SELECT', 'StatuslineModeOther' },
    S = { 'S-LINE', 'StatuslineModeOther' },
    R = { 'REPLACE', 'StatuslineModeOther' },
    t = { 'TERMINAL', 'StatuslineModeOther' },
  }
  local mode = vim.api.nvim_get_mode().mode
  local info = mode_map[mode] or { mode, 'StatuslineModeOther' }
  return info[1], info[2]
end

-- Helper: get git branch (if available)
local function git_branch()
  local branch = vim.b.gitsigns_head or ''
  if branch ~= '' then
    return string.format(' %s %s ', icons.git.git_branch, branch)
  end
  return ''
end

-- Helper: get diagnostics summary
local function diagnostics()
  local counts = { error = 0, warn = 0, info = 0, hint = 0 }
  for k in pairs(counts) do
    counts[k] = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[k:upper()] })
  end
  local out = {}
  for k, v in pairs(counts) do
    if v > 0 then
      table.insert(out, string.format('%s %d', icons.diagnostics[k], v))
    end
  end
  return #out > 0 and (' ' .. table.concat(out, ' ')) or ''
end

-- Helper: get LSP servers for current buffer
local function lsp_servers()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  if #clients == 0 then return '' end
  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end
  return string.format(' %s %s ', icons.lsp.active, table.concat(names, ','))
end

-- Helper: file info
local function file_info()
  local name = vim.fn.expand('%:t')
  local modified = vim.bo.modified and icons.files.file_modified or ''
  local readonly = vim.bo.readonly and icons.files.file_read_only or ''
  return string.format(' %s%s%s ', name, modified, readonly)
end

-- Helper: location
local function location()
  return string.format(' %3d:%-2d ', unpack(vim.api.nvim_win_get_cursor(0)))
end

-- LSP info click handler
local function lsp_info_click()
  vim.cmd([[lua require('statusline').show_lsp_health() ]])
end

-- Show floating window with :checkhealth vim.lsp
function M.show_lsp_health()
  local lines = vim.fn.execute('checkhealth vim.lsp')
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(lines, '\n'))
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
  })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<cr>', { nowait = true, noremap = true, silent = true })
end

-- Compose the statusline string
function M.statusline()
  local mode, mode_hl = mode_info()
  local stl = ''
  stl = stl .. '%#' .. mode_hl .. '# ' .. mode .. ' '
  stl = stl .. '%#StatusLine#'
  stl = stl .. git_branch()
  stl = stl .. file_info()
  stl = stl .. '%=' -- align right
  stl = stl .. diagnostics()
  -- LSP info: clickable
  stl = stl .. '%@v:lua.require"statusline".lsp_info_click@'
  stl = stl .. lsp_servers()
  stl = stl .. '%T'
  stl = stl .. location()
  return stl
end

-- Toggle between native and Heirline statusline
local using_native = false
function M.toggle()
  if using_native then
    vim.o.statusline = ''
    vim.cmd([[packadd heirline.nvim]])
    require('plugins.heirline')
    using_native = false
    vim.notify('Heirline statusline enabled')
  else
    vim.o.statusline = "%!v:lua.require'statusline'.statusline()"
    using_native = true
    vim.notify('Native statusline enabled')
  end
end

vim.api.nvim_create_user_command('ToggleStatusline', function()
  require('statusline').toggle()
end, {})

return M
