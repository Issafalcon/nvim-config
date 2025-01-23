-- https://github.com/github/copilot.vim
local copilot_keys = {
  {
    "i",
    "<Plug>(vimrc:copilot-dummy-map)",
    'copilot#Accept("")',
    {
      desc = "Copilot dummy accept to workaround fallback issues with nvim-cmp",
      expr = true,
      silent = true,
    },
  },
}

fignvim.config.set_vim_opts({
  g = {
    copilot_no_tab_map = true, -- Disable tab mapping in insert mode when using copilot (so you can override the default mapping)
    copilot_proxy_strict_ssl = false,
  },
})

fignvim.mappings.create_keymaps(copilot_keys)
