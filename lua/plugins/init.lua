-- =============================================================================
-- Core
-- =============================================================================
require("plugins.plenary")
require("plugins.nui")

-- Load notification UIs early so that PackChanged autocmds (post-install build
-- hooks, etc.) can display through snacks/noice rather than the default cmdline.
require("plugins.snacks")
require("plugins.noice")

vim.pack.add({
  { src = "https://github.com/echasnovski/mini.nvim" },
})

-- =============================================================================
-- LSP
-- =============================================================================
require("plugins.schemastore") -- For yamlls and json-lsp
require("plugins.lsp")
require("plugins.mason")
require("plugins.lsp-progress")

require("plugins.terragrunt-ls")

-- =============================================================================
-- Editing
-- =============================================================================
require("plugins.vim-matchup")
require("plugins.conform")
require("plugins.nvim-lint")
require("plugins.grug-far")
require("plugins.substitute")
require("plugins.cutlass")
require("plugins.icon-picker")
require("plugins.treesj")
require("plugins.nvim-surround")
require("plugins.undotree")
require("plugins.mini-align")
require("plugins.mini-pairs")
require("plugins.mini-ai")

-- =============================================================================
-- UI
-- =============================================================================
require("plugins.catppuccin") -- Theme
require("plugins.mini-icons")
require("plugins.treesitter")
require("plugins.maximizer")
require("plugins.bufferline")
require("plugins.bqf")
require("plugins.colorutils")
require("plugins.indent-blankline")
require("plugins.nvim-navic")
require("plugins.colorizer")

-- =============================================================================
-- Navigation
-- =============================================================================
require("plugins.leap")
require("plugins.telescope") -- Not main picker but still required by some plugins
require("plugins.yazi")
require("plugins.aerial")
require("plugins.harpoon")

-- =============================================================================
-- Misc
-- =============================================================================
require("plugins.diffview")
require("plugins.vim-unimpaired")
require("plugins.which-key")
require("plugins.qmk")
require("plugins.persistence")
require("plugins.refactoring")
require("plugins.nx")

-- Needs xclip which is not available in WSL by default, and clipboard integration
-- is generally more difficult in WSL, so skip this plugin there
if vim.fn.has("wsl") == 0 then
  require("plugins.img-clip")
end

-- =============================================================================
-- Git
-- =============================================================================
require("plugins.git-signs")
require("plugins.git-messenger")
require("plugins.pipeline")

-- =============================================================================
-- Completions
-- =============================================================================
require("plugins.luasnip")
require("plugins.blink-cmp")

-- =============================================================================
-- AI
-- =============================================================================
require("plugins.copilot")
require("plugins.agentic")
-- require("plugins.mcphub")
-- require("plugins.codecompanion")
require("plugins.nvim-mcp")

-- =============================================================================
-- GitHub
-- =============================================================================
require("plugins.octo")

-- =============================================================================
-- Testing
-- =============================================================================
require("plugins.neotest")

-- =============================================================================
-- Debugging
-- =============================================================================

-- Install after testing as it has nvim-nio dependency
require("plugins.debugging")

-- =============================================================================
-- Terminals
-- =============================================================================
require("plugins.toggleterm")

-- =============================================================================
-- .NET
-- =============================================================================
require("plugins.roslyn")
-- require("plugins.easy-dotnet") -- 23-01-2026: Still has issues. Can't load multiple solutions in different tabs. Solution select fails and gets confused.
require("plugins.nuget")

-- =============================================================================
-- Data Science / Python
-- =============================================================================
-- require("plugins.iron-nvim")
require("plugins.slime")
require("plugins.quarto-nvim")
require("plugins.venv-selector")
require("plugins.molten")
require("plugins.dadbod")

-- =============================================================================
-- Terraform
-- =============================================================================
require("plugins.vim-terraform")
require("plugins.vim-helm")

-- =============================================================================
-- Markdown
-- =============================================================================
-- image.nvim uses the kitty graphics protocol which doesn't work in WSL via WezTerm
if vim.fn.has("wsl") == 0 then
  require("plugins.image-nvim")
end
require("plugins.markdown-preview")
require("plugins.render-markdown")

-- =============================================================================
-- PowerShell
-- =============================================================================
require("plugins.pwsh")

-- =============================================================================
-- Lua / Neovim Development
-- =============================================================================
require("plugins.lazydev")
require("plugins.luapad")

-- =============================================================================
-- .http
-- =============================================================================
require("plugins.kulala")

-- =============================================================================
-- Documentation
-- =============================================================================
require("plugins.obsidian")
require("plugins.neogen")
require("plugins.plantuml")
require("plugins.swagger-preview")
require("plugins.vimtex")
-- The builtin commenting functionality is sufficient, but leaving this here for reference
-- require("plugins.comment")

-- Stick this one last (too many dependencies)
require("plugins.heirline")
