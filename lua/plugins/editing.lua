local dial_keys = {
  { "n", "<C-a>", function() return require("dial.map").inc_normal() end, { expr = true, desc = "Increment" } },
  { "n", "<C-x>", function() return require("dial.map").dec_normal() end, { expr = true, desc = "Decrement" } },
}

-- Better increment / decrement
local dial_spec = {
  "monaqa/dial.nvim",
  keys = fignvim.config.make_lazy_keymaps(dial_keys),
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
    if cmp then
      cmp.event:on(
        "confirm_done",
        require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } })
      )
    end
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

return {
  dial_spec,
  matchup_spec,
  autopairs_spec,
  nvim_surround_spec,
  vim_unimpaired_spec,
}
