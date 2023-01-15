local easy_align_keys = {
  { { "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Easy align in visual mode, or for a motion" } },
}
local ssr_keys = {
  { { "n", "x" }, "<leader>sR", function() require("ssr").open() end, { desc = "Structural Replace" } },
}

local treesj_keys = {
  { "n", "J", "<cmd>TSJToggle<cr>", { desc = "Join Toggle" } },
}

local dial_keys = {
  { "n", "<C-a>", function() return require("dial.map").inc_normal() end, { expr = true, desc = "Increment" } },
  { "n", "<C-x>", function() return require("dial.map").dec_normal() end, { expr = true, desc = "Decrement" } },
}

local undotree_keys = {
  { "n", "<A-u>", ":UndotreeToggle<CR>", { desc = "Undotree: Toggle undotree" } },
}

local trouble_keys = {
  { "n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true } },
  { "n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", { silent = true, noremap = true } },
  { "n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { silent = true, noremap = true } },
  { "n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true } },
  { "n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true } },
}
-- Treesitter based structural search and replace
local ssr_spec = {
  "cshuaimin/ssr.nvim",
  keys = fignvim.config.make_lazy_keymaps(ssr_keys, true),
}

-- Enhanced join / split functionality
local treesj_spec = {
  "Wansmer/treesj",
  keys = fignvim.config.make_lazy_keymaps(treesj_keys, true),
  opts = { use_default_keymaps = false, max_join_length = 150 },
}

-- Better increment / decrement
local dial_spec = {
  "monaqa/dial.nvim",
  keys = fignvim.config.make_lazy_keymaps(dial_keys, true),
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
      },
    })

    fignvim.config.register_keymap_group("Editing", dial_keys)
  end,
}

-- Enhanced '%' match finder (treesitter integration available)
local matchup_spec = {
  "andymass/vim-matchup",
  event = "BufReadPost",
  config = function() vim.g.matchup_matchparen_offscreen = { method = "status_manual" } end,
}

local autopairs_spec = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0,
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    local cmp = fignvim.plug.load_module_file("cmp")
    if cmp then cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } })) end
  end,
}

local nvim_surround_spec = {
  "kylechui/nvim-surround",
  event = "BufReadPost",
}

-- Misc keymaps for navigation, encoding and quickfix / loc lists
local vim_unimpaired_spec = {
  "tpope/vim-unimpaired",
  event = "BufReadPost",
}

local undotree_spec = {
  "mbbill/undotree",
  cmd = "UndoTreeToggle",
  keys = fignvim.config.make_lazy_keymaps(undotree_keys, true),
}

local refactoring_spec = {
  "ThePrimeagen/refactoring.nvim",
  config = true,
}

local trouble_spec = {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  keys = fignvim.config.make_lazy_keymaps(trouble_keys, true),
  opts = {
    use_diagnostic_signs = true,
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  },
}

local easy_align_spec = {
  "junegunn/vim-easy-align",
  keys = fignvim.config.make_lazy_keymaps(easy_align_keys, true),
}

return {
  dial_spec,
  matchup_spec,
  autopairs_spec,
  nvim_surround_spec,
  vim_unimpaired_spec,
  undotree_spec,
  ssr_spec,
  treesj_spec,
  refactoring_spec,
  trouble_spec,
  easy_align_spec,
  "editorconfig/editorconfig-vim",
}
