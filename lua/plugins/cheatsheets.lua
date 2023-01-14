local cheatsheet_keys = {
  { "n", "<leader>?", ":Cheatsheet<CR>", { desc = "Toggles Cheatsheet help window in Telescope" } },
}

local cheatsheet_spec = {
  "sudormrfbin/cheatsheet.nvim",
  keys = fignvim.config.make_lazy_keymaps(cheatsheet_keys, false),
  config = true,
}

local whichkey_spec = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      spelling = { enabled = true },
      presets = { operators = false },
    },
    window = {
      border = "rounded",
      padding = { 2, 2, 2, 2 },
    },
    disable = { filetypes = { "TelescopePrompt" } },
  },
}

local legendary_spec = {
  "mrjones2014/legendary.nvim",
  cmd = "Legendary",
}

return {
  cheatsheet_spec,
  whichkey_spec,
  legendary_spec,
}
