local M = {}

M.Core = {}

M.Core.Lists = {
  ToggleQuickFix = {
    "n",
    "<C-q>",
    function()
      fignvim.ui.toggle_fix_list(true)
    end,
    { desc = "Toggle quickfix window" },
  },
  ToggleLocationList = {
    "n",
    "<leader>q",
    function()
      fignvim.ui.toggle_fix_list(false)
    end,
    { desc = "Toggle location list window" },
  },
}

M.Core.Window = {
  MoveLeft = { "n", "<C-h>", "<C-w>h", { desc = "Move to next window to the left" } },
  MoveRight = { "n", "<C-l>", "<C-w>l", { desc = "Move to next window to the right" } },
  MoveDown = { "n", "<C-j>", "<C-w>j", { desc = "Move to next window down" } },
  MoveUp = { "n", "<C-k>", "<C-w>k", { desc = "Move to next window up" } },
  ResizeUp = { "n", "<C-Up>", ":resize +2<CR>", { desc = "Resize window horizontally up" } },
  ResizeDown = { "n", "<C-Down>", ":resize -2<CR>", { desc = "Resize window horizontally down" } },
  ResizeLeft = { "n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Resize window vertically to the left" } },
  ResizeRight = { "n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Resize window vertically to the right" } },
}

M.Core.Terminal = {
  NormalMode = { "t", "<esc>", [[<C-\><C-n>]], { desc = "Enter normal mode in terminal" } },
}

M.Core.Editing = {
  EscapeInsert = { "i", "jk", "<ESC>", { desc = "Escape insert mode" } },
  IndentSelectionLeft = { "v", "<", "<gv", { desc = "Indent selection left" } },
  IndentSelectionRight = { "v", ">", ">gv", { desc = "Indent selection right" } },
  MoveSelectedLinesUp = { { "n", "v" }, "<A-j>", ":m .+1<CR>==", { desc = "Move selected lines up" } },
  MoveSelectedLinesDown = { { "n", "v" }, "<A-k>", ":m .-2<CR>==", { desc = "Move selected lines down" } },
  MoveLineUp = { "x", { "J", "<A-j>" }, ":move '>+1<CR>gv-gv", { desc = "Move current line up" } },
  MoveLineDown = { "x", { "K", "A-k" }, ":move '<-2<CR>gv-gv", { desc = "Move current line down" } },
  MoveLineUpInInsert = { "i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line up" } },
  MoveLineDownInInsert = { "i", "<A-K>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line down" } },
  CloseAllBuffersExceptCurrent = {
    "n",
    "<leader>bo",
    "<cmd>%bd|e#<cr>",
    { desc = "Close all buffers except the current one" },
  },

  -- Create new text objects
  TextObjectBuffer = {
    "o",
    "ie",
    ":exec 'normal! ggVG'<cr>",
    { desc = "Creates new text object to operate on entire buffer" },
  },
  TextObjectView = {
    "o",
    "iv",
    ":exec 'normal! HVL'<cr>",
    { desc = "Creates new text object to operate on all text in view" },
  },
}

M.Core.Navigation = {
  MoveNextBuffer = { "n", "<S-l>", ":bnext<CR>", { desc = "Move to next buffer" } },
  MovePreviousBuffer = { "n", "<S-h>", ":bprevious<CR>", { desc = "Move to previous buffer" } },
  CloseCurrentBuffer = { "n", "<C-x>", ":bdelete<CR>", { desc = "Close current buffer" } },
  ToggleLineNumbers = {
    "n",
    "<leader>l",
    function()
      fignvim.ui.toggle_line_numbers()
    end,
    { desc = "Toggle line numbers" },
  },
  ToggleRelativeLineNumbers = {
    "n",
    "<leader>rn",
    function()
      fignvim.ui.toggle_relative_line_numbers()
    end,
    { desc = "Toggle relative line numbers" },
  },
  SetMark = { "n", "\\m", "m", { desc = "Set a mark" } },
}

M.Completion = {
  SelectPrevItem = "<C-k>",
  SelectNextItem = "<C-j>",
  SelectPrevItemInsert = "<Up>",
  SelectNextItemInsert = "<Down>",
  ScrollDocsUp = "<C-b>",
  ScrollDocsDown = "<C-f>",
  Complete = "<C-space>",
  Disable = "<C-y>",
  Abort = "<C-e>",
  Confirm = "<CR>",
  AcceptCopilotSuggestion = "<C-x>",
  SuperTab = "<Tab>",
  SuperTabBack = "<S-Tab>",
}

M.Annotations = {
  GenerateFileAnnotations = {
    "n",
    "<leader>/F",
    function()
      require("neogen").generate({ type = "file" })
    end,
    { desc = "Generates filetype specific annotations for the nearest file" },
  },
  GenerateFunctionAnnotations = {
    "n",
    "<leader>/f",
    function()
      require("neogen").generate({ type = "func" })
    end,
    { desc = "Generates filetype specific annotations for the nearest function" },
  },
  GenerateClassAnnotations = {
    "n",
    "<leader>/c",
    function()
      require("neogen").generate({ type = "class" })
    end,
    { desc = "Generates filetype specific annotations for the nearest class" },
  },
  GenerateTypeAnnotations = {
    "n",
    "<leader>/t",
    function()
      require("neogen").generate({ type = "type" })
    end,
    { desc = "Generates filetype specific annotations for the nearest type" },
  },
}

M.Lsp = {
  Format = {
    { "n", "v" },
    "<leader>f",
    fignvim.lsp.formatting.format,
    { desc = "Format code in file, or the selected portion of code" },
  },
  FormatInjectedLangs = {
    { "n", "v" },
    "<leader>cF",
    function()
      require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
    end,
    { desc = "Format Injected Langs" },
  },
  ToggleAutoFormatOnSave = {
    "n",
    "<leader>taf",
    fignvim.formatting.toggle,
    { desc = "Toggle autoformatting on save" },
  },
  DiagnosticsNext = {
    "n",
    "]g",
    function()
      vim.diagnostic.goto_next()
    end,
    { desc = "Go to next diagnostic" },
  },
  DiagnosticsPrev = {
    "n",
    "[g",
    function()
      vim.diagnostic.goto_prev()
    end,
    { desc = "Go to previous diagnostic" },
  },
  ListDocumentSymbols = {
    "n",
    "<leader>gs",
    function()
      require("telescope.builtin").lsp_document_symbols()
    end,
    { desc = "List document symbols in Telescope" },
  },
  ListWorkspaceSymbols = {
    "n",
    "<leader>gS",
    function()
      require("telescope.builtin").lsp_workspace_symbols()
    end,
    { desc = "List workspace symbols in Telescope" },
  },
  ToggleInlayHints = {
    "n",
    "<leader>ih",
    function()
      if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
      else
        vim.lsp.inlay_hint.enable(true)
      end
    end,
    { desc = "Toggles inlay hints" },
  },
  CodeActions = {
    { "n", "v" },
    "<leader>ca",
    function()
      vim.lsp.buf.code_action()
    end,
    { desc = "Opens the default Code Action Window" },
  },
  GotoDeclaration = {
    "n",
    "gD",
    function()
      vim.lsp.buf.declaration()
    end,
    { desc = "Go to declaration of current symbol" },
  },
  GotoDefinition = {
    "n",
    "gd",
    function()
      vim.lsp.buf.definition()
    end,
    { desc = "Go to definition of current symbol" },
  },
  HoverDocumentation = {
    "n",
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    { desc = "Hover documentation" },
  },
  GotoTelescopeImplementations = {
    "n",
    "gI",
    function()
      require("telescope.builtin").lsp_implementations()
    end,
    { desc = "Go to implementation of current symbol using Telescope" },
  },
  GotoTelescopeReferences = {
    "n",
    "gr",
    function()
      require("telescope.builtin").lsp_references()
    end,
    { desc = "Go to references of current symbol using Telescope" },
  },
  RenameSymbol = {
    "n",
    "rn",
    function()
      vim.lsp.buf.rename()
    end,
    { desc = "Rename current symbol" },
  },
  ShowSignatureHelp = {
    { "n", "i" },
    "<A-s>",
    "<cmd>LspOverloadsSignature<CR>",
    { desc = "Show signature help with overloads" },
  },
  TypeScriptOrganizeImports = {
    "n",
    "<leader>to",
    ":TSLspOrganize<CR>",
    { desc = "Organize imports using tsserver" },
  },
  TypeScriptRenameFile = {
    "n",
    "<leader>trn",
    ":TSLspRenameFile<CR>",
    { desc = "Rename file using tsserver" },
  },
  TypescriptImportAll = {
    "n",
    "<leader>ti",
    ":TSLspImportAll<CR>",
    { desc = "Import all missing imports using tsserver" },
  },
}

M.Editing = {
  SearchAndReplace = {
    { "n", "v" },
    "<leader>sr",
    function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.open({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      })
    end,
    { desc = "Search and Replace" },
  },
  Refactor = {
    { "n", "v" },
    "<leader>R",
    function()
      require("telescope").extensions.refactoring.refactors()
    end,
    { desc = "Refactor Actions" },
  },
}

M.UI = {
  OpenTerminalFileManager = {
    { "n", "v" },
    "-",
    "<cmd>Yazi<cr>",
    {
      desc = "Open yazi at the current file",
    },
  },
  OpenFileManagerInWorkingDirectory = {
    "n",
    "<leader>cw",
    "<cmd>Yazi cwd<cr>",
    {
      desc = "Open the file manager in nvim's working directory",
    },
  },
  ResumeLastFileManagerSession = {
    "n",
    "<c-up>",
    "<cmd>Yazi toggle<cr>",
    {
      desc = "Resume the last yazi session",
    },
  },
}

return M
