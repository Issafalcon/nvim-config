-- =============================================================================
-- Core
-- =============================================================================
require("plugins.plenary")
require("plugins.nui")

vim.pack.add({
  { src = "https://github.com/echasnovski/mini.nvim" },
})

-- =============================================================================
-- LSP
-- =============================================================================
require("plugins.lsp")
require("plugins.mason")
require("plugins.lsp-progress")

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
require("plugins.telescope")
require("plugins.yazi")
require("plugins.aerial")
require("plugins.harpoon")

-- =============================================================================
-- Misc
-- =============================================================================
require("plugins.snacks")
require("plugins.diffview")
require("plugins.vim-unimpaired")
require("plugins.which-key")
require("plugins.qmk")
require("plugins.cheatsheet")
require("plugins.persistence")
require("plugins.refactoring")
require("plugins.pack-manager")
require("plugins.nx")

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
require("plugins.completion")

-- =============================================================================
-- AI
-- =============================================================================
require("plugins.copilot")
require("plugins.mcphub")
require("plugins.codecompanion")

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
require("plugins.nuget")

-- =============================================================================
-- Terraform
-- =============================================================================
require("plugins.vim-terraform")

-- =============================================================================
-- Markdown
-- =============================================================================
require("plugins.markdown-preview")
require("plugins.render-markdown")

-- =============================================================================
-- Lua / Neovim Development
-- =============================================================================
require("plugins.lazydev")

-- =============================================================================
-- Documentation
-- =============================================================================
require("plugins.obsidian")
require("plugins.neogen")
-- The builtin commenting functionality is sufficient, but leaving this here for reference
-- require("plugins.comment")

-- Stick this one last (too many dependencies)
require("plugins.heirline")
