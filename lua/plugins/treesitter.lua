-- =============================================================================
-- nvim-treesitter (main branch) for Neovim 0.12+
--
-- The main branch is a full rewrite:
--   - No module system (matchup, playground, autotag modules removed)
--   - Highlighting/indentation via Neovim builtins + FileType autocmds
--   - Playground replaced by built-in :InspectTree
--   - Textobjects and autotag use their own standalone setup()
-- =============================================================================

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
})

require("nvim-treesitter").setup({})

-- Install parsers (async, no-op if already installed)
require("nvim-treesitter").install({
  "angular",
  "arduino",
  "awk",
  "bash",
  "bibtex",
  "bicep",
  "c",
  "c_sharp",
  "cmake",
  "comment",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "dot",
  "embedded_template",
  "fish",
  "fsh",
  "func",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "graphql",
  "hcl",
  "html",
  "htmldjango",
  "http",
  "java",
  "javascript",
  "jq",
  "jsdoc",
  "json",
  "json5",
  "jsonnet",
  "llvm",
  "lua",
  "luadoc",
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "ocaml",
  "ocaml_interface",
  "passwd",
  "proto",
  "python",
  "query",
  "r",
  "regex",
  "ruby",
  "rust",
  "scheme",
  "scss",
  "sparql",
  "sql",
  "svelte",
  "tablegen",
  "terraform",
  "todotxt",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
})

-- Enable treesitter highlighting for all filetypes with an available parser
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if args.match == "latex" then
      return
    end
    pcall(vim.treesitter.start)
  end,
  desc = "Enable treesitter highlighting",
})

-- Enable treesitter-based indentation (experimental)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if vim.bo.filetype == "latex" then
      return
    end
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
  desc = "Enable treesitter indentation",
})

-- Autotag (standalone setup, no longer an nvim-treesitter module)
require("nvim-ts-autotag").setup({})

-- Context-aware commentstring (standalone setup)
-- Integration with Neovim's native gc commenting (0.10+)
require("ts_context_commentstring").setup({
  enable_autocmd = false,
})

local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
    or get_option(filetype, option)
end

-- Textobjects (standalone setup on main branch)
require("nvim-treesitter-textobjects").setup({
  move = { set_jumps = true },
})

local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "Next class end" })
vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next parameter" })
vim.keymap.set({ "n", "x", "o" }, "]A", function() move.goto_next_end("@parameter.inner", "textobjects") end, { desc = "Next parameter end" })
vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev function end" })
vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class start" })
vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Prev class end" })
vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Prev parameter" })
vim.keymap.set({ "n", "x", "o" }, "[A", function() move.goto_previous_end("@parameter.inner", "textobjects") end, { desc = "Prev parameter end" })
-- stylua: ignore end

vim.keymap.set("n", "<leader>xp", function()
  swap.swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })
vim.keymap.set("n", "<leader>xP", function()
  swap.swap_previous("@parameter.inner")
end, { desc = "Swap previous parameter" })

-- Configure Angular parser for component templates
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = { "*.component.html", "*.container.html" },
  callback = function()
    vim.treesitter.start(nil, "angular")
  end,
  desc = "Use Angular parser for component templates",
})
