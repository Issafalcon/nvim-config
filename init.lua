-- Check compatible version of Neovim
if vim.fn.has("nvim-0.8") ~= 1 or vim.version().prerelease then
  vim.schedule(function() fignvim.ui.notify("Unsupported Neovim Version! Please check the requirements", "error") end)
end

-- Get all the required Fignvim API functions and commands required for setup
for _, source in ipairs({
  "api",
  "lsp",
  "core",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

-- Register modules
---@summary Takes a table of lists, indexed by module name
---         The list is the set of named plugins that will match the indexes of
---         the returned specs from the module's "spec.lua" file
fignvim.module.register_modules({
  ["plugins"] = { "sqlite", "neodev", "luapad" },
  ["cheatsheets"] = { "cheatsheet", "legendary", "whichkey" },
  ["editing"] = {
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
    "editorconfig",
  },
  ["ui"] = { "indent-blankline", "notify", "colourschemes", "dressing", "colorizer", "heirline", "bufferline", "maximizer" },
  ["lsp"] = { "lsp_config", "mason", "null-ls", "lsp-overloads", "schemastore" },
  ["completion"] = { "cmp", "copilot" },
  ["treesitter"] = {
    "treesitter",
    "treesitter-context",
    "treesitter-textobjects",
    "ts-autotag",
    "ts-context-commentstring",
    "ts-rainbow",
    "aerial",
  },
  ["navigation"] = { "telescope", "neo_tree", "leap", "rnvimr" },
  ["cut-and-paste"] = { "cutlass", "yanky" },
  ["search-and-replace"] = { "vim-abolish", "spectre", "subversive", "bqf" },
  ["diagnostics"] = { "trouble" },
  ["git"] = { "gitsigns", "diffview", "vim-fugitive", "git-messenger" },
  ["session"] = { "auto-session" },
  ["snippets"] = { "luasnip" },
  ["terminal"] = { "toggleterm" },
  ["debugging"] = { "dap", "dap-ui", "dap-virtual-text", "dap-vscode-js" },
  ["documenting"] = { "neogen", "plantuml", "markdown-preview" },
  ["icons"] = { "devicons", "icon-picker" },
  ["testing"] = { "neotest" },
  ["terraform"] = { "vim-terraform" },
  ["tex"] = { "vimtex" },
  ["dotnet"] = { "omnisharp-extended-lsp" },
})

if vim.fn.has("win32") == 1 then fignvim.config.set_shell_as_powershell() end

if vim.fn.has("wsl") == 1 then fignvim.config.set_win32yank_wsl_as_clip() end

fignvim.plug.initialise_lazy_nvim()
fignvim.plug.setup_lazy_plugins()

-- 5. Set up the LSP servers (also sets keymaps for LSP related actions)
fignvim.lsp.setup_lsp_servers({
  "jsonls",
  "cucumber_language_server",
  "tsserver",
  "sumneko_lua",
  "texlab",
  "omnisharp",
  "terraformls",
  "stylelint_lsp",
  "emmet_ls",
  "bashls",
  "dockerls",
  "html",
  "vimls",
  "yamlls",
  "angularls",
  "cssls",
  "tflint",
  "sqls",
})

-- 6. Create mappings
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { silent = true }) -- Prep for space to be leader key
fignvim.mappings.create_core_mappings()
