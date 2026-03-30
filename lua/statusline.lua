local icons = require('icons')

local M = {}

-- Unicode slant separators
local SEP_RIGHT = ''
local SEP_LEFT = ''

-- Helper: get current mode name and highlight group
local function mode_info()
  local mode_map = {
    n = { 'NORMAL', 'StatuslineModeNormal', 'StatuslineModeSeparatorNormal' },
    i = { 'INSERT', 'StatuslineModeInsert', 'StatuslineModeSeparatorInsert' },
    v = { 'VISUAL', 'StatuslineModeVisual', 'StatuslineModeSeparatorVisual' },
    V = { 'V-LINE', 'StatuslineModeVisual', 'StatuslineModeSeparatorVisual' },
    ['\22'] = { 'V-BLOCK', 'StatuslineModeVisual', 'StatuslineModeSeparatorVisual' },
    c = { 'COMMAND', 'StatuslineModeCommand', 'StatuslineModeSeparatorCommand' },
    s = { 'SELECT', 'StatuslineModeOther', 'StatuslineModeSeparatorOther' },
    S = { 'S-LINE', 'StatuslineModeOther', 'StatuslineModeSeparatorOther' },
    R = { 'REPLACE', 'StatuslineModeOther', 'StatuslineModeSeparatorOther' },
    t = { 'TERMINAL', 'StatuslineModeOther', 'StatuslineModeSeparatorOther' },
  }
  local mode = vim.api.nvim_get_mode().mode
  local info = mode_map[mode] or { mode, 'StatuslineModeOther', 'StatuslineModeSeparatorOther' }
  return info[1], info[2], info[3]
end

-- Helper: get git branch (if available)
local function git_branch()
  local branch = vim.b.gitsigns_head or ''
  if branch ~= '' then
    return string.format(' %s %s ', icons.git.git_branch, branch)
  end
  return ''
end

-- Helper: get git diff summary with highlights
local function git_diff()
  local signs = vim.b.gitsigns_status_dict or {}
  local added = signs.added or 0
  local changed = signs.changed or 0
  local removed = signs.removed or 0
  local out = {}
  if added > 0 then table.insert(out, string.format('%%#diffAdded#%s%d', icons.git.added, added)) end
  if changed > 0 then table.insert(out, string.format('%%#diffChanged#%s%d', icons.git.modified, changed)) end
  if removed > 0 then table.insert(out, string.format('%%#diffRemoved#%s%d', icons.git.removed, removed)) end
  return #out > 0 and (' ' .. table.concat(out, ' ')) or ''
end

-- Helper: get diagnostics summary with highlights
local function diagnostics()
  local counts = { error = 0, warn = 0, info = 0, hint = 0 }
  for k in pairs(counts) do
    counts[k] = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[k:upper()] })
  end
  local out = {}
  if counts.error > 0 then
    table.insert(out, string.format('%%#DiagnosticError#%s %d', icons.diagnostics.error, counts.error))
  end
  if counts.warn > 0 then
    table.insert(out, string.format('%%#DiagnosticWarn#%s %d', icons.diagnostics.warn, counts.warn))
  end
  if counts.info > 0 then
    table.insert(out, string.format('%%#DiagnosticInfo#%s %d', icons.diagnostics.info, counts.info))
  end
  if counts.hint > 0 then
    table.insert(out, string.format('%%#DiagnosticHint#%s %d', icons.diagnostics.hint, counts.hint))
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

-- Helper: location (line/total_lines (percent%))
local function location()
  local line = vim.fn.line('.');
  local total = vim.fn.line('$');
  local percent = math.floor((line / total) * 100)
  return string.format(' %d/%d (%d%%%%) ', line, total, percent)
end

-- LSP info click handler
function M.lsp_info_click()
  require('statusline').show_lsp_health()
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
  local mode, mode_hl, sep_hl = mode_info()
  local stl = ''

  -- Mode
  stl = stl .. '%#' .. mode_hl .. '# ' .. mode .. ' '
  stl = stl .. '%#' .. sep_hl .. '#' .. SEP_RIGHT

  -- Git branch
  stl = stl .. '%#StatuslineTitle#' .. git_branch()
  stl = stl .. '%#StatuslineTitle#' .. SEP_RIGHT

  -- Git diff
  stl = stl .. git_diff()
  stl = stl .. '%#diffAdded#' .. SEP_RIGHT

  -- File info
  stl = stl .. '%#StatuslineItalic#' .. file_info()
  stl = stl .. '%#StatuslineItalic#' .. SEP_RIGHT

  -- Align right
  stl = stl .. '%=' 

  -- Diagnostics
  stl = stl .. diagnostics()
  stl = stl .. '%#DiagnosticInfo#' .. SEP_LEFT

  -- LSP info: clickable
  stl = stl .. '%#StatuslineSpinner#%@v:lua.require"statusline".lsp_info_click@' .. lsp_servers() .. '%T'
  stl = stl .. '%#StatuslineSpinner#' .. SEP_LEFT

  -- Location
  stl = stl .. '%#StatuslineTitle#' .. location()

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
