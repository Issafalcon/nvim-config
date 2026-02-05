-- Modern vtsls configuration (replaces ts_ls)
-- Based on LazyVim's TypeScript extras

local function organize_imports()
  vim.lsp.buf.execute_command({
    command = "typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  })
end

local function add_missing_imports()
  vim.lsp.buf.execute_command({
    command = "typescript.addMissingImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  })
end

local function remove_unused_imports()
  vim.lsp.buf.execute_command({
    command = "typescript.removeUnusedImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  })
end

local function fix_all()
  vim.lsp.buf.execute_command({
    command = "typescript.fixAll",
    arguments = { vim.api.nvim_buf_get_name(0) },
  })
end

local function goto_source_definition()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf.execute_command({
    command = "typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  })
end

local function file_references()
  vim.lsp.buf.execute_command({
    command = "typescript.findAllFileReferences",
    arguments = { vim.uri_from_bufnr(0) },
  })
end

local function select_ts_version()
  vim.lsp.buf.execute_command({
    command = "typescript.selectTypeScriptVersion",
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("vtsls-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "vtsls" then
      return
    end

    -- Disable formatting (use conform.nvim instead)
    client.server_capabilities.documentFormattingProvider = false

    local bufnr = args.buf

    -- TypeScript-specific keybindings
    vim.keymap.set("n", "<leader>co", organize_imports, {
      desc = "Organize Imports",
      buffer = bufnr,
    })

    vim.keymap.set("n", "<leader>cM", add_missing_imports, {
      desc = "Add missing imports",
      buffer = bufnr,
    })

    vim.keymap.set("n", "<leader>cu", remove_unused_imports, {
      desc = "Remove unused imports",
      buffer = bufnr,
    })

    vim.keymap.set("n", "<leader>cD", fix_all, {
      desc = "Fix all diagnostics",
      buffer = bufnr,
    })

    vim.keymap.set("n", "gD", goto_source_definition, {
      desc = "Goto Source Definition",
      buffer = bufnr,
    })

    vim.keymap.set("n", "gR", file_references, {
      desc = "File References",
      buffer = bufnr,
    })

    vim.keymap.set("n", "<leader>cV", select_ts_version, {
      desc = "Select TS workspace version",
      buffer = bufnr,
    })
  end,
})

return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
}
