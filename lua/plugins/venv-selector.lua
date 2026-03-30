---@diagnostic disable: missing-fields
vim.pack.add({
  {
    src = "https://github.com/jmbuhr/otter.nvim",
  },
  {
    src = "https://github.com/quarto-dev/quarto-nvim",
  },
  {
    src = "https://github.com/linux-cultist/venv-selector.nvim",
  },
})

require("venv-selector").setup({
  search = {
    -- Some tweaks to config from the docs
    -- 1. /usr/bin/fd is not fd-find — on mint os systems it's the "FD(File & Directory tool)" Japanese file manager. Running fd from the plugin's command launches that TUI app and returns nothing useful.
    -- 2. python is a symlink — so even if you had fd-find, the --full-path regex match against /bin/python$ with -type f would miss it since it's a symlink to python3.
    -- The fix replaces the command with find ~/python3/envs/neovim/bin -name 'python', which correctly returns /home/adam/python3/envs/neovim/bin/python and doesn't depend on fd-find being installed.
    nvim_venv = {
      command = "find ~/python3/envs/neovim/bin -name 'python'",
    },
  },
  options = {
    picker = "auto",
    log_level = "DEBUG",
  },
})
