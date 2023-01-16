local cheatsheet_keys = {
  { "n", "<leader>?", ":Cheatsheet<CR>", { desc = "Toggles Cheatsheet help window in Telescope" } },
}

local cheatsheet_spec = {
  "sudormrfbin/cheatsheet.nvim",
  keys = fignvim.mappings.make_lazy_keymaps(cheatsheet_keys, true),
  config = true,
}

local whichkey_spec = {
  "folke/which-key.nvim",
  lazy = false,
  priority = 950,
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
  lazy = false,
  priority = 900,
}

return fignvim.module.enable_registered_plugins({
  ["cheatsheet"] = cheatsheet_spec,
  ["whichkey"] = whichkey_spec,
  ["legendary"] = legendary_spec
}, "cheatsheets")