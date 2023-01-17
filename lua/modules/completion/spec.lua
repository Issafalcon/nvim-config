local copilot_keys = {
  {
    "i",
    "<Plug>(vimrc:copilot-dummy-map)",
    'copilot#Accept("")',
    { desc = "Copilot dummy accept to workaround fallback issues with nvim-cmp", expr = true, silent = true },
  },
}

local copilot_spec = {
  "github/copilot.vim",
  event = "InsertEnter",
  keys = fignvim.mappings.make_lazy_keymaps(copilot_keys, true),
  config = function()
    fignvim.mappings.make_legendary_keymaps(copilot_keys, false)
  end
}

return fignvim.module.enable_registered_plugins({
  ["cmp"] = require("modules.completion.cmp"),
  ["copilot"] = copilot_spec
}, "lsp")
