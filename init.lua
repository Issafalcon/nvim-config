-- Get all the required Fignvim API functions and commands required for setup
for _, source in ipairs({
  "api",
  "lsp",
  "core",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end

fignvim.module.register_plugins({
  -- Plugin Development
  -- "sqlite",
  "neodev",
  "luapad",

  -- Keybinds and Cheatsheets
  "cheatsheet",
  "whichkey",

  -- General Editing
  "undotree",
  "refactoring",
  "easyalign",
  "ssr",
  "treesj",
  "dial",
  "matchup",
  "autopairs",
  "nvim-surround",
  "vim-unimpaired",
  "comment",
  "indent-blankline",

  -- UI
  "notify",
  "heirline",
  "colourschemes",
  "dressing",
  "colorizer",
  "maximizer",
  "transparent",

  -- LSP
  "lsp_config",
  "mason",
  "none-ls",
  "lsp-overloads",
  "lsp-progress",
  "schemastore",

  -- Completions and Snippets
  "cmp",
  "copilot",
  "copilot-chat",
  "luasnip",

  -- Treesitter
  "treesitter", -- Loads treesitter-related plugins as well
  "aerial",

  -- Navigation
  "telescope",
  -- "neo_tree",
  "netrw_nvim",
  "leap",
  "rnvimr",
  "nvim-navic", -- https://github.com/SmiteshP/nvim-navic

  -- Cut and paste
  "cutlass",
  -- "yanky"  - Performance is an issue when using this plugin. Pastes / yanks are slow

  -- Search and replace
  "vim-abolish",
  "spectre",
  "substitute",
  "bqf",

  -- Diagnostics
  "trouble",

  -- Git
  "gitsigns",
  "diffview",
  "git-messenger",
  "octo",
  "gh-actions",

  -- Session management
  "auto-session",

  -- Terminal
  "toggleterm",

  -- Debugging
  "dap",
  "dap-ui",
  "dap-virtual-text",

  -- Documenting
  "neogen",
  "plantuml",
  "markdown-preview",
  "render-markdown",
  "obsidian",
  "swagger-preview",

  -- Icons
  "nvim-web-devicons",
  "icon-picker",

  -- Colours
  "colorutils",

  -- Testing
  "neotest",

  -- Terraform
  "vim-terraform",
  "vim-helm",

  -- LaTeX
  "vimtex",

  -- .NET
  "omnisharp-extended-lsp",
  "roslyn",
  "easy-dotnet",
  "nuget",

  -- C++
  "vim-cmake",

  -- Databases
  "dadbod",

  -- Nx
  "nx",

  -- Packages
  "luarocks",
})

if vim.fn.isdirectory(vim.fn.expand("$PROJECTS/neosharper.nvim")) == 1 then
  fignvim.module.register_plugins({
    "neosharper",
  })
end

if vim.fn.has("win32") == 1 then
  fignvim.config.set_shell_as_powershell()
end

if vim.fn.has("wsl") == 1 then
  fignvim.config.set_win32yank_wsl_as_clip()
end

fignvim.plug.initialise_lazy_nvim()
fignvim.plug.setup_lazy_plugins()

-- 5. Set up the LSP servers (also sets keymaps for LSP related actions)
fignvim.lsp.setup_lsp_servers({
  "jsonls",
  "cucumber_language_server",
  "ts_ls",
  "lua_ls",
  "texlab",
  -- "omnisharp",
  "roslyn.nvim", -- Not directly language server - See https://github.com/jmederosalvarado/roslyn.nvim
  -- "csharp_ls",
  "terraformls",
  "stylelint_lsp",
  "emmet_ls",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "html",
  "vimls",
  "yamlls",
  "angularls",
  "cssls",
  "tflint",
  "powershell_es",
  "eslint",
  "clangd",
  "cmake",
  "pyright",
  "tailwindcss",
  "helm_ls",
  -- "ruff_lsp",
})

-- 6. Create mappings
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { silent = true }) -- Prep for space to be leader key
fignvim.mappings.create_core_mappings()
