local copilot_keys = {
  {
    "i",
    "<Plug>(vimrc:copilot-dummy-map)",
    'copilot#Accept("")',
    { desc = "Copilot dummy accept to workaround fallback issues with nvim-cmp", expr = true, silent = true },
  },
}

return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    keys = fignvim.mappings.make_lazy_keymaps(copilot_keys, true),
    init = function()
      fignvim.config.set_vim_opts({
        g = {
          copilot_no_tab_map = true, -- Disable tab mapping in insert mode when using copilot (so you can override the default mapping)
        },
      })
    end,
  },
}
