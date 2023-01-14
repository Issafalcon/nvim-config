---@diagnostic disable: missing-parameter
fignvim.lsp.mappings = {}

--- Sets buffer mappings for the given client, if the client supports them.
---@param capabilities table The current server capabilities for the language server
---@param client_name string Name of the current language server client
---@param bufnr number the buffer number to set mappings for
function fignvim.lsp.mappings.set_buf_mappings(capabilities, client_name, bufnr)
  local lsp_mappings = require("user-configs.mappings").lsp_mappings
  local lsp_keymaps = {}
  vim.list_extend(lsp_keymaps, {
    "n",
    "[g",
    function() vim.diagnostic.goto_prev() end,
    { desc = "Go to previous diagnostic" },
  })
  vim.list_extend(lsp_keymaps, {
    "n",
    "]g",
    function() vim.diagnostic.goto_prev() end,
    { desc = "Go to next diagnostic" },
  })
  vim.list_extend(lsp_keymaps, {
    "n",
    "<leader>ld",
    function() vim.diagnostic.goto_prev() end,
    { desc = "Hover diagnostics" },
  })
  vim.list_extend(lsp_keymaps, {
    "n",
    "<leader>gs",
    function() require("telescope.builtin").lsp_document_symbols() end,
    { desc = "List document symbols in Telescope" },
  })
  vim.list_extend(lsp_keymaps, {
    "n",
    "<leader>gS",
    function() require("telescope.builtin").lsp_workspace_symbols() end,
    { desc = "List workspace symbols in Telescope" },
  })

  if capabilities.codeActionProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "<leader>ca",
      function() vim.lsp.buf.code_action() end,
      { desc = "Opens the default Code Action Window" },
    })
  end

  if capabilities.declarationProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "<leader>gD",
      function() vim.lsp.buf.declaration() end,
      { desc = "Go to declaration of current symbol" },
    })
  end

  if capabilities.definitionProvider or capabilities.typeDefinitionProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "<leader>gd",
      function() vim.lsp.buf.definition() end,
      { desc = "Go to definition of current symbol" },
    })
  end

  if capabilities.documentFormattingProvider then
    vim.list_extend(
      lsp_keymaps,
      { { "n", "v" }, "<leader>f", fignvim.lsp.formatting.format, { desc = "Format code in file, or the selected portion of code" } }
    )
    vim.list_extend(lsp_keymaps, {
      "n",
      "<leader>taf",
      fignvim.ui.toggle_autoformat,
      { desc = "Toggle autoformatting on save" },
    })
  end

  if capabilities.hoverProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "K",
      function() vim.lsp.buf.hover() end,
      { desc = "Hover documentation" },
    })
  end

  if capabilities.implementationProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "gI",
      function() require("telescope.builtin").lsp_implementations() end,
      { desc = "Go to implementation of current symbol using Telescope" },
    })
  end

  if capabilities.referencesProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "gr",
      function() require("telescope.builtin").lsp_references() end,
      { desc = "Go to references of current symbol using Telescope" },
    })
  end

  if capabilities.renameProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "rn",
      function() vim.lsp.buf.rename() end,
      { desc = "Rename current symbol" },
    })
  end

  if capabilities.signatureHelpProvider then
    vim.list_extend(lsp_keymaps, {
      "n",
      "<A-s>",
      ":LspOverloadsSignature<CR>",
      { desc = "Show signature help with overloads" },
    })
    vim.list_extend(lsp_keymaps, {
      "i",
      "<A-s>",
      function() vim.lsp.buf.signature_help() end,
      { desc = "Show signature help in insert mode" },
    })
  end

  if client_name == "tsserver" then
    vim.list_extend(lsp_keymaps, {
      "n",
      "<leader>to",
      ":TSLspOrganize<CR>",
      { desc = "Organize imports using tsserver" },
    })
    vim.list_extend(lsp_keymaps, {
      "n",
      "<leader>trn",
      ":TSLspRenameFile<CR>",
      { desc = "Rename file using tsserver" },
    })
    vim.list_extend(lsp_keymaps, {
      "n",
      "<leader>ti",
      ":TSLspImportAll<CR>",
      { desc = "Import all missing imports using tsserver" },
    })
  end

  fignvim.config.register_keymap_group("LSP", lsp_keymaps, true)
end

return fignvim.lsp.mappings
