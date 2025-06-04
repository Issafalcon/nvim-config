-- Get all the required Fignvim API functions and commands required for setupinitinit
for _, source in ipairs({
  "api",
  "core",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_echo({ { "Failed to load " .. source .. "\n\n" .. fault } }, true, { err = true })
  end
end

-- Load core API functions (needed for upcoming setup)
require("core.api")

fignvim.core.module.register_modules({
  "editing",
  "ui",
  "completion",
  "formatting",
  "linting",
  "lsp",
  "ai",
  "documentation",
  "treesitter",
  "git",
  "misc",
  "dotnet",
  "debugging",
  "testing",
})

fignvim.core.module.register_plugins({
  -- Plugin Development
  -- "sqlite",
  "luapad",

  -- Keybinds and Cheatsheets
  "cheatsheet",
  "whichkey",

  -- General Editing
  "undotree",
  "treesj",
  "dial",
  "nvim-surround",
  "vim-unimpaired",
  "comment",
  "indent-blankline",

  -- UI
  "colorizer",
  "maximizer",

  -- Completions and Snippets
  "copilot-chat",
  "aerial",

  -- Navigation
  "telescope",
  -- "neo_tree",
  "netrw_nvim",
  "leap",
  "nvim-navic", -- https://github.com/SmiteshP/nvim-navic

  -- Cut and paste
  -- "yanky"  - Performance is an issue when using this plugin. Pastes / yanks are slow

  -- Search and replace
  "vim-abolish",
  "substitute",
  "bqf",

  -- Diagnostics
  "trouble",

  -- Session management
  "auto-session",

  -- Terminal
  "toggleterm",

  -- Icons
  "nvim-web-devicons",
  "icon-picker",

  -- Colours
  "colorutils",

  -- Terraform
  "vim-terraform",
  "vim-helm",

  -- LaTeX
  "vimtex",

  -- .NET
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
  fignvim.core.module.register_plugins({
    "neosharper-nvim",
  })
end

if vim.fn.isdirectory(vim.fn.expand("$PROJECTS/neosharper")) == 1 then
  fignvim.core.module.register_plugins({
    "neosharper",
  })
end

fignvim.core.module.load_module_apis()

if vim.fn.has("win32") == 1 then
  fignvim.config.set_shell_as_powershell()
end

if vim.fn.has("wsl") == 1 then
  fignvim.config.set_win32yank_wsl_as_clip()
end

fignvim.plug.initialise_lazy_nvim()
fignvim.plug.setup_lazy_plugins()

-- 6. Create mappings
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { silent = true }) -- Prep for space to be leader key
fignvim.mappings.create_core_mappings()

-- 7. Setup formatters
fignvim.formatting.setup()
