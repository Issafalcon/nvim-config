local easy_align_keys = {
  { { "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Easy align in visual mode, or for a motion" } },
}

local easy_align_spec = {
  "junegunn/vim-easy-align",
  init = function() fignvim.mappings.register_keymap_group("Editing", easy_align_keys, false) end,
  keys = fignvim.mappings.make_lazy_keymaps(easy_align_keys, true),
}

-- Treesitter based structural search and replace
local ssr_keys = {
  { { "n", "x" }, "<leader>sR", function() require("ssr").open() end, { desc = "Structural Replace" } },
}

local ssr_spec = {
  "cshuaimin/ssr.nvim",
  init = function() fignvim.mappings.register_keymap_group("Editing", ssr_keys, false) end,
  keys = fignvim.mappings.make_lazy_keymaps(ssr_keys, true),
}

-- Enhanced join / split functionality
local treesj_keys = {
  { "n", "<leader>j", "<cmd>TSJToggle<cr>", { desc = "Join Toggle" } },
}

local treesj_spec = {
  "Wansmer/treesj",
  keys = fignvim.mappings.make_lazy_keymaps(treesj_keys, true),
  init = function() fignvim.mappings.register_keymap_group("Editing", treesj_keys, false) end,
  opts = { use_default_keymaps = false, max_join_length = 140 },
}

-- Better increment / decrement
local dial_keys = {
  { "n", "<C-a>", function() return require("dial.map").inc_normal() end, { expr = true, desc = "Increment" } },
  { "n", "<C-x>", function() return require("dial.map").dec_normal() end, { expr = true, desc = "Decrement" } },
}

local dial_spec = {
  "monaqa/dial.nvim",
  keys = fignvim.mappings.make_lazy_keymaps(dial_keys, true),
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

    fignvim.mappings.register_keymap_group("Editing", dial_keys, false)
  end,
}

-- Enhanced '%' match finder (treesitter integration available)
local matchup_spec = {
  "andymass/vim-matchup",
  event = "BufReadPost",
  config = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
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
    local cmp_ok, cmp = pcall(require, "cmp")
    if cmp_ok then cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } })) end
  end,
}

local nvim_surround_spec = {
  "kylechui/nvim-surround",
  event = "BufReadPost",
  config = true,
}

-- Misc keymaps for navigation, encoding and quickfix / loc lists
local vim_unimpaired_spec = {
  "tpope/vim-unimpaired",
  event = "BufReadPost",
}

local refactoring_spec = {
  "ThePrimeagen/refactoring.nvim",
  config = true,
}

local undotree_keys = {
  { "n", "<A-u>", ":UndotreeToggle<CR>", { desc = "Undotree: Toggle undotree" } },
}

local undotree_spec = {
  "mbbill/undotree",
  cmd = "UndoTreeToggle",
  init = function() fignvim.mappings.register_keymap_group("Editing", undotree_keys, false) end,
  keys = fignvim.mappings.make_lazy_keymaps(undotree_keys, true),
}

local comment_spec = {
  "numToStr/Comment.nvim",
  event = "BufReadPost",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- code
    local comment = require("Comment")
    comment.setup({
      opleader = {
        line = "gc",
        block = "gb",
      },
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
}

local editorconfig_spec = {
  "editorconfig/editorconfig-vim",
  event = "VeryLazy",
}

return fignvim.module.enable_registered_plugins({
  ["easyalign"] = easy_align_spec,
  ["ssr"] = ssr_spec,
  ["treesj"] = treesj_spec,
  ["dial"] = dial_spec,
  ["matchup"] = matchup_spec,
  ["autopairs"] = autopairs_spec,
  ["nvim-surround"] = nvim_surround_spec,
  ["vim-unimpaired"] = vim_unimpaired_spec,
  ["refactoring"] = refactoring_spec,
  ["undotree"] = undotree_spec,
  ["comment"] = comment_spec,
  ["editorconfig"] = editorconfig_spec,
}, "editing")
