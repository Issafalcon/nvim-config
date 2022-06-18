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
  last_signature.config = config

  add_sig_popup_mapping(last_signature.mode, 'sig_next', '<C-j>', M.modify_sig, 1, 0)
  M.custom_signature_help(err, result, ctx, config)
end

--- Converts `textDocument/SignatureHelp` response to markdown lines.
---
---@param signature_help Response of `textDocument/SignatureHelp`
---@param ft optional filetype that will be use as the `lang` for the label markdown code block
---@param triggers optional list of trigger characters from the lsp server. used to better determine parameter offsets
---@returns list of lines of converted markdown.
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_signatureHelp
function M.custom_convert_signature_help_to_markdown_lines(signature_help, ft, triggers)
  if not signature_help.signatures then
    return
  end
  --The active signature. If omitted or the value lies outside the range of
  --`signatures` the value defaults to zero or is ignored if `signatures.length
  --=== 0`. Whenever possible implementors should make an active decision about
  --the active signature and shouldn't rely on a default value.
  local contents = {}
  local active_hl
  local active_signature = signature_help.activeSignature or 0
  -- If the activeSignature is not inside the valid range, then clip it.
  -- In 3.15 of the protocol, activeSignature was allowed to be negative
  if active_signature >= #signature_help.signatures or active_signature < 0 then
    active_signature = 0
  end
  local signature = signature_help.signatures[active_signature + 1]
  if not signature then
    return
  end
  local label = signature.label
  if ft then
    -- wrap inside a code block so stylize_markdown can render it properly
    label = ("```%s\n%s\n```"):format(ft, label)
  end
  vim.list_extend(contents, vim.split(label, '\n', true))
  if signature.documentation then
    vim.lsp.util.convert_input_to_markdown_lines(signature.documentation, contents)
  end

  if #signature_help.signatures > 1 then
    vim.list_extend(contents, { "", "overload " .. active_signature + 1 .. " of " .. #signature_help.signatures , "" })
  end

  if signature.parameters and #signature.parameters > 0 then
    local active_parameter = (signature.activeParameter or signature_help.activeParameter or 0)
    if active_parameter < 0
    then active_parameter = 0
    end

    -- If the activeParameter is > #parameters, then set it to the last
    -- NOTE: this is not fully according to the spec, but a client-side interpretation
    if active_parameter >= #signature.parameters then
      active_parameter = #signature.parameters - 1
    end

    local parameter = signature.parameters[active_parameter + 1]
    if parameter then
      --[=[
      --Represents a parameter of a callable-signature. A parameter can
      --have a label and a doc-comment.
      interface ParameterInformation {
        --The label of this parameter information.
        --
        --Either a string or an inclusive start and exclusive end offsets within its containing
        --signature label. (see SignatureInformation.label). The offsets are based on a UTF-16
        --string representation as `Position` and `Range` does.
        --
        --*Note*: a label of type string should be a substring of its containing signature label.
        --Its intended use case is to highlight the parameter label part in the `SignatureInformation.label`.
        label: string | [number, number];
        --The human-readable doc-comment of this parameter. Will be shown
        --in the UI but can be omitted.
        documentation?: string | MarkupContent;
      }
      --]=]
      if parameter.label then
        if type(parameter.label) == "table" then
          active_hl = parameter.label
        else
          local offset = 1
          -- try to set the initial offset to the first found trigger character
          for _, t in ipairs(triggers or {}) do
            local trigger_offset = signature.label:find(t, 1, true)
            if trigger_offset and (offset == 1 or trigger_offset < offset) then
              offset = trigger_offset
            end
          end
          for p, param in pairs(signature.parameters) do
            offset = signature.label:find(param.label, offset, true)
            if not offset then break end
            if p == active_parameter + 1 then
              active_hl = { offset - 1, offset + #parameter.label - 1 }
              break
            end
            offset = offset + #param.label + 1
          end
        end
      end
      if parameter.documentation then
        vim.lsp.util.convert_input_to_markdown_lines(parameter.documentation, contents)
      end
    end
  end
  return contents, active_hl
end

-- Taken from the Neovim code proper
function M.custom_signature_help(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  -- When use `autocmd CompleteDone <silent><buffer> lua vim.lsp.buf.signature_help()` to call signatureHelp handler
  -- If the completion item doesn't have signatures It will make noise. Change to use `print` that can use `<silent>` to ignore
  if not (result and result.signatures and result.signatures[1]) then
    if config.silent ~= true then
      print('No signature help available')
    end
    return
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local triggers = vim.tbl_get(client.server_capabilities, 'signatureHelpProvider', 'triggerCharacters')
  local ft = vim.api.nvim_buf_get_option(ctx.bufnr, 'filetype')

  -- TODO: Make a custom version of this that adds custom overload count and parameter section with label
  local lines, hl = M.custom_convert_signature_help_to_markdown_lines(result, ft, triggers)
  lines = vim.lsp.util.trim_empty_lines(lines)
  if vim.tbl_isempty(lines) then
    if config.silent ~= true then
      print('No signature help available')
    end
    return
  end
  local fbuf, fwin = vim.lsp.util.open_floating_preview(lines, 'markdown', config)
  if hl then
    vim.api.nvim_buf_add_highlight(fbuf, -1, 'LspSignatureActiveParameter', 0, unpack(hl))
  end
  return fbuf, fwin
end

M.modify_sig = function(sig_modifier, param_modifier)
  vim.fn.timer_start(0, function()
    last_signature.activeSignature = last_signature.activeSignature + (sig_modifier or 0)
    last_signature.activeParameter = last_signature.activeParameter + (param_modifier or 0)
    put("Made it into modify sig")
    put(last_signature)
    M.custom_signature_help(last_signature.err, last_signature, last_signature.ctx,
      last_signature.config)
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
