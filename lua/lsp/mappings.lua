---@diagnostic disable: missing-parameter
fignvim.lsp.mappings = {}

--- Sets buffer mappings for the given client, if the client supports them.
---@param capabilities table The current server capabilities for the language server
---@param client_name string Name of the current language server client
---@param buffer number the buffer number to set mappings for
function fignvim.lsp.mappings.set_buf_mappings(capabilities, client_name, bufnr)
  local lsp_keymaps = {}
  table.insert(lsp_keymaps, {
    "n",
    "[g",
    function()
      vim.diagnostic.goto_prev()
    end,
    { desc = "Go to previous diagnostic", buffer = bufnr },
  })
  table.insert(lsp_keymaps, {
    "n",
    "]g",
    function()
      vim.diagnostic.goto_prev()
    end,
    { desc = "Go to next diagnostic", buffer = bufnr },
  })
  table.insert(lsp_keymaps, {
    "n",
    "<leader>ld",
    function()
      vim.diagnostic.goto_prev()
    end,
    { desc = "Hover diagnostics", buffer = bufnr },
  })
  table.insert(lsp_keymaps, {
    "n",
    "<leader>gs",
    function()
      require("telescope.builtin").lsp_document_symbols()
    end,
    { desc = "List document symbols in Telescope", buffer = bufnr },
  })
  table.insert(lsp_keymaps, {
    "n",
    "<leader>gS",
    function()
      require("telescope.builtin").lsp_workspace_symbols()
    end,
    { desc = "List workspace symbols in Telescope", buffer = bufnr },
  })

  if capabilities.codeActionProvider then
    table.insert(lsp_keymaps, {
      "n",
      "<leader>ca",
      function()
        vim.lsp.buf.code_action()
      end,
      { desc = "Opens the default Code Action Window", buffer = bufnr },
    })
  end

  if capabilities.declarationProvider then
    table.insert(lsp_keymaps, {
      "n",
      "gD",
      function()
        vim.lsp.buf.declaration()
      end,
      { desc = "Go to declaration of current symbol", buffer = bufnr },
    })
  end

  if capabilities.definitionProvider or capabilities.typeDefinitionProvider then
    table.insert(lsp_keymaps, {
      "n",
      "gd",
      function()
        vim.lsp.buf.definition()
      end,
      { desc = "Go to definition of current symbol", buffer = bufnr },
    })
  end

  if capabilities.documentFormattingProvider then
    table.insert(lsp_keymaps, {
      { "n", "v" },
      "<leader>f",
      fignvim.lsp.formatting.format,
      { desc = "Format code in file, or the selected portion of code", buffer = bufnr },
    })
    table.insert(lsp_keymaps, {
      "n",
      "<leader>taf",
      fignvim.ui.toggle_autoformat,
      { desc = "Toggle autoformatting on save", buffer = bufnr },
    })
  end

  if capabilities.hoverProvider then
    table.insert(lsp_keymaps, {
      "n",
      "K",
      function()
        vim.lsp.buf.hover()
      end,
      { desc = "Hover documentation", buffer = bufnr },
    })
  end

  if capabilities.implementationProvider then
    table.insert(lsp_keymaps, {
      "n",
      "gI",
      function()
        require("telescope.builtin").lsp_implementations()
      end,
      { desc = "Go to implementation of current symbol using Telescope", buffer = bufnr },
    })
  end

  if capabilities.referencesProvider then
    table.insert(lsp_keymaps, {
      "n",
      "gr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      { desc = "Go to references of current symbol using Telescope", buffer = bufnr },
    })
  end

  if capabilities.renameProvider then
    table.insert(lsp_keymaps, {
      "n",
      "rn",
      function()
        vim.lsp.buf.rename()
      end,
      { desc = "Rename current symbol", buffer = bufnr },
    })
  end

  if capabilities.signatureHelpProvider then
    table.insert(lsp_keymaps, {
      "n",
      "<A-s>",
      ":LspOverloadsSignature<CR>",
      { desc = "Show signature help with overloads", buffer = bufnr },
    })
    table.insert(lsp_keymaps, {
      "i",
      "<A-s>",
      function()
        vim.lsp.buf.signature_help()
      end,
      { desc = "Show signature help in insert mode", buffer = bufnr },
    })
  end

  if client_name == "tsserver" then
    table.insert(lsp_keymaps, {
      "n",
      "<leader>to",
      ":TSLspOrganize<CR>",
      { desc = "Organize imports using tsserver", buffer = bufnr },
    })
    table.insert(lsp_keymaps, {
      "n",
      "<leader>trn",
      ":TSLspRenameFile<CR>",
      { desc = "Rename file using tsserver", buffer = bufnr },
    })
    table.insert(lsp_keymaps, {
      "n",
      "<leader>ti",
      ":TSLspImportAll<CR>",
      { desc = "Import all missing imports using tsserver", buffer = bufnr },
    })
  end

  fignvim.config.register_keymap_group("LSP", lsp_keymaps, true)
end

return fignvim.lsp.mappings
