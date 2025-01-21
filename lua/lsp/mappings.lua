---@diagnostic disable: missing-parameter
fignvim.lsp.mappings = {}

--- Sets buffer mappings for the given client, if the client supports them.
---@param capabilities table The current server capabilities for the language server
---@param client_name string Name of the current language server client
---@param bufnr number the buffer number to set mappings for
---@param force_mappings boolean Whether to force the mappings to be set, regardless of client capabilities
function fignvim.lsp.mappings.set_buf_mappings(
  capabilities,
  client_name,
  bufnr,
  force_mappings
)
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
      vim.diagnostic.goto_next()
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
  table.insert(lsp_keymaps, {
    "n",
    "<leader>ih",
    function()
      if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
      else
        vim.lsp.inlay_hint.enable(true)
      end
    end,
    { desc = "Toggles inlay hints", buffer = bufnr },
  })

  if capabilities.codeActionProvider or force_mappings then
    table.insert(lsp_keymaps, {
      { "n", "v" },
      "<leader>ca",
      function()
        vim.lsp.buf.code_action()
      end,
      { desc = "Opens the default Code Action Window", buffer = bufnr },
    })
  end

  if capabilities.declarationProvider or force_mappings then
    table.insert(lsp_keymaps, {
      "n",
      "gD",
      function()
        vim.lsp.buf.declaration()
      end,
      { desc = "Go to declaration of current symbol", buffer = bufnr },
    })
  end

  if
    capabilities.definitionProvider
    or capabilities.typeDefinitionProvider
    or force_mappings
  then
    table.insert(lsp_keymaps, {
      "n",
      "gd",
      function()
        vim.lsp.buf.definition()
      end,
      { desc = "Go to definition of current symbol", buffer = bufnr },
    })
  end

  if capabilities.documentFormattingProvider or force_mappings then
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

  if capabilities.hoverProvider or force_mappings then
    table.insert(lsp_keymaps, {
      "n",
      "K",
      function()
        vim.lsp.buf.hover()
      end,
      { desc = "Hover documentation", buffer = bufnr },
    })
  end

  if capabilities.implementationProvider or force_mappings then
    table.insert(lsp_keymaps, {
      "n",
      "gI",
      function()
        require("telescope.builtin").lsp_implementations()
      end,
      { desc = "Go to implementation of current symbol using Telescope", buffer = bufnr },
    })
  end

  if capabilities.referencesProvider or force_mappings then
    table.insert(lsp_keymaps, {
      "n",
      "gr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      { desc = "Go to references of current symbol using Telescope", buffer = bufnr },
    })
  end

  if capabilities.renameProvider or force_mappings then
    table.insert(lsp_keymaps, {
      "n",
      "rn",
      function()
        vim.lsp.buf.rename()
      end,
      { desc = "Rename current symbol", buffer = bufnr },
    })
  end

  if capabilities.signatureHelpProvider or force_mappings then
    table.insert(lsp_keymaps, {
      "n",
      "<A-s>",
      ":LspOverloadsSignature<CR>",
      { desc = "Show signature help with overloads", buffer = bufnr },
    })
    table.insert(lsp_keymaps, {
      "i",
      "<A-s>",
      "<cmd>LspOverloadsSignature<CR>",
      -- function() vim.lsp.buf.signature_help() end,
      { desc = "Show signature help in insert mode", buffer = bufnr },
    })
  end

  fignvim.mappings.create_keymaps(lsp_keymaps)
end

return fignvim.lsp.mappings
