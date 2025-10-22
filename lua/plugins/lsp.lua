vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.lsp.enable("lua_ls")
  end,
  desc = "Start Python LSP",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    vim.lsp.enable("ts_ls")
  end,
  desc = "Start TypeScript/JavaScript LSP",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tf", "terraform" },
  callback = function()
    vim.lsp.enable("terraformls")
  end,
  desc = "Start terraform LSP",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local capabilities = client.server_capabilities

    vim.keymap.set("n", "[g", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "Go to previous diagnostic", buffer = args.buf })

    vim.keymap.set("n", "]g", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "Go to next diagnostic", buffer = args.buf })

    vim.keymap.set("n", "<leader>gs", function()
      require("telescope.builtin").lsp_document_symbols()
    end, { desc = "List document symbols in Telescope", buffer = args.buf })

    vim.keymap.set("n", "<leader>gS", function()
      require("telescope.builtin").lsp_workspace_symbols()
    end, { desc = "List workspace symbols in Telescope", buffer = args.buf })

    vim.keymap.set("n", "<leader>ih", function()
      if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
      else
        vim.lsp.inlay_hint.enable(true)
      end
    end, { desc = "Toggles inlay hints", buffer = args.buf })

    if capabilities.codeActionProvider then
      vim.keymap.set({ "n", "v" }, "<leader>ca", function()
        vim.lsp.buf.code_action()
      end, { desc = "Opens the default Code Action Window", buffer = args.buf })
    end

    if capabilities.declarationProvider then
      vim.keymap.set("n", "gD", function()
        vim.lsp.buf.declaration()
      end, { desc = "Go to declaration of current symbol", buffer = args.buf })
    end

    if capabilities.definitionProvider or capabilities.typeDefinitionProvider then
      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
      end, { desc = "Go to definition of current symbol", buffer = args.buf })
    end

    if capabilities.documentFormattingProvider then
      vim.keymap.set(
        { "n", "v" },
        "<leader>f",
        "<cmd>FigNvimFormat<cr>",
        { desc = "Format current buffer or selection", buffer = args.buf }
      )

      vim.keymap.set(
        "n",
        "<leader>taf",
        "<cmd>FigNvimToggleAutoFormat<cr>",
        { desc = "Toggle autoformat-on-save", buffer = args.buf }
      )
    end

    if capabilities.hoverProvider then
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({
          border = "rounded",
        })
      end, { desc = "Hover documentation", buffer = args.buf })
    end

    if capabilities.implementationProvider then
      vim.keymap.set("n", "gI", function()
        require("telescope.builtin").lsp_implementations()
      end, { desc = "Go to implementation of current symbol using Telescope", buffer = args.buf })
    end

    if capabilities.referencesProvider then
      vim.keymap.set("n", "gr", function()
        require("telescope.builtin").lsp_references()
      end, { desc = "Go to references of current symbol using Telescope", buffer = args.buf })
    end

    if capabilities.renameProvider then
      vim.keymap.set("n", "rn", function()
        vim.lsp.buf.rename()
      end, { desc = "Rename current symbol", buffer = args.buf })
    end

    if capabilities.documentHighlightProvider then
      local highlight_name = vim.fn.printf("lsp_document_highlight_%d", args.buf)
      vim.api.nvim_create_augroup(highlight_name, {})
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = highlight_name,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = highlight_name,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end

    if capabilities.signatureHelpProvider then
      -- Setup lsp overloads plugin an mappings
      local lsp_overloads_ok, lsp_overloads = pcall(require, "lsp-overloads")
      if lsp_overloads_ok then
        lsp_overloads.setup(client, {
          ui = {
            close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre" },
            floating_window_above_cur_line = true,
            silent = true,
            border = "rounded",
          },
        })
      end

      vim.keymap.set(
        "n",
        "<A-s>",
        ":LspOverloadsSignature<CR>",
        { desc = "Show signature help with overloads", buffer = args.buf }
      )

      vim.keymap.set(
        "i",
        "<A-s>",
        "<cmd>LspOverloadsSignature<CR>",
        -- function() vim.lsp.buf.signature_help() end,
        { desc = "Show signature help in insert mode", buffer = args.buf }
      )
    end

    if client.name == "ts_ls" then
      vim.keymap.set(
        "n",
        "<leader>to",
        ":TSLspOrganize<CR>",
        { desc = "Organize imports using tsserver", buffer = args.buf }
      )

      vim.keymap.set(
        "n",
        "<leader>trn",
        ":TSLspRenameFile<CR>",
        { desc = "Rename file using tsserver", buffer = args.buf }
      )

      vim.keymap.set(
        "n",
        "<leader>ti",
        ":TSLspImportAll<CR>",
        { desc = "Import all missing imports using tsserver", buffer = args.buf }
      )
    end
  end,
})
