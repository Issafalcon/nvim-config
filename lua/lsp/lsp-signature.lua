local M = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local util = require('vim.lsp.util')
local handler
local clients = {}
local sig_popup_mappings = {}
local last_signature = {}

local add_sig_popup_mapping = function(mode, mapName, default_lhs, rhs, ...)
  put(mode)
  put(mapName)
  put(default_lhs)
  put(rhs)
  put(...)
  extra_args = ...
  local config_lhs = sig_popup_mappings[mapName] or default_lhs
  if config_lhs == nil then
    return
  end
  vim.keymap.set(mode, config_lhs, function()
    put("Modifiers:")
    put(extra_args)
    rhs(extra_args)
  end, { buffer = true, expr = true, nowait = true })
  sig_popup_mappings.mapName = config_lhs
end

local signature_handler = function(err, result, ctx, config)
  put(result)
  last_signature = {}
  -- Call the standard handler
  last_signature = result
  last_signature.err = err
  last_signature.mode = vim.fn.mode()
  last_signature.ctx = ctx

  add_sig_popup_mapping(last_signature.mode, 'sig_next', '<C-j>', M.modify_sig, 1, 0)
  vim.lsp.handlers["textDocument/signatureHelp"](err, result, ctx)
end

M.modify_sig = function(sig_modifier, param_modifier)
  vim.fn.timer_start(0, function()
    last_signature.activeSignature = last_signature.activeSignature + (sig_modifier or 0)
    last_signature.activeParameter = last_signature.activeParameter + (param_modifier or 0)
    put("Made it into modify sig")
    put(last_signature)
    vim.lsp.handlers["textDocument/signatureHelp"](last_signature.err, last_signature, last_signature.ctx)
  end)
end

local popup_map_wrapper = function(rhs)
  vim.cmd("execute printf('call timer_start(0, {-> %s})'," .. rhs .. ")")
  return "\\<Ignore>"
end

local check_trigger_char = function(line_to_cursor, triggers)
  if not triggers then
    return false
  end

  for _, trigger_char in ipairs(triggers) do
    local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
    local prev_char = line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
    if current_char == trigger_char then
      return true
    end
    if current_char == ' ' and prev_char == trigger_char then
      return true
    end
  end
  return false
end

local open_signature = function()
  local triggered = false

  for _, client in pairs(clients) do
    local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

    -- csharp has wrong trigger chars for some odd reason
    if client.name == 'csharp' then
      triggers = { '(', ',' }
    end

    local pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local line_to_cursor = line:sub(1, pos[2])

    if not triggered then
      triggered = check_trigger_char(line_to_cursor, triggers)
    end
  end

  if triggered then
    local params = util.make_position_params()
    vim.lsp.buf_request(
      0,
      'textDocument/signatureHelp',
      params,
      vim.lsp.with(signature_handler, {
        border = 'single',
        silent = true,
        focusable = false,
      }))
  end
end

M.setup = function(client)
  handler = vim.lsp.with(signature_handler, {
    border = 'single',
    silent = true,
    focusable = false,
  })

  table.insert(clients, client)

  local group = augroup('LspSignature', { clear = false })
  vim.api.nvim_clear_autocmds({ group = group, pattern = '<buffer>' })
  autocmd('TextChangedI', {
    group = group,
    pattern = '<buffer>',
    callback = function()
      -- Guard against spamming of method not supported after
      -- stopping a language serer with LspStop
      local active_clients = vim.lsp.get_active_clients()
      if #active_clients < 1 then
        return
      end
      open_signature()
    end,
  })
end

return M
