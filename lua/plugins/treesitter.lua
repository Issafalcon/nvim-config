return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "arduino",
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
        "jsonc",
        "jsonnet",
        "latex",
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
        "ocamllex",
        "org",
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
      },
      ignore_install = {},
      highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "latex" },
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      autotag = { enable = true },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>xp"] = "@parameter.inner" },
          swap_previous = { ["<leader>xP"] = "@parameter.inner" },
        },
        lsp_interop = {
          enable = true,
          border = "none",
          peek_definition_code = {
            ["<leader>pf"] = "@function.outer",
            ["<leader>pc"] = "@class.outer",
          },
        },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
      },
      matchup = { enable = true },
    },
    dependencies = {
      -- Enable treesitter playground
      "nvim-treesitter/playground",
      "vim-matchup",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- Easier configuration of TS text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufReadPost",
  },
  -- Auto-close HTML tags in various filetypes
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
  },
  -- Provide context based commentstring
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPost",
    init = function()
      fignvim.config.set_vim_opts({
        g = {
          skip_ts_context_commentstring_module = true,
        },
      })
    end,
  },
}
