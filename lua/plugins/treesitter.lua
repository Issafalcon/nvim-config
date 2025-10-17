vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master",
  },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
})

vim.g.skip_ts_context_commentstring_module = true

require("ts_context_commentstring").setup({})

require("nvim-treesitter.configs").setup({
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
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
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
  matchup = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  },
})

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
      vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})
