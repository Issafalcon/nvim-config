fignvim.plug = {}

--- Bootstraops Lazy.nvim
function fignvim.plug.initialise_lazy_nvim()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

--- Sets up Lazy.nvim and loads all the plugin specs that have been registered in init.lua
function fignvim.plug.setup_lazy_plugins()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.rtp:prepend(lazypath)

  local import_list = {}

  -- Essential Plugins first
  table.insert(import_list, { "nvim-lua/plenary.nvim" })

  for _, plugin_name in ipairs(vim.g.fignvim_plugins) do
    table.insert(import_list, { import = "plugins." .. plugin_name })
  end

  local status_ok, lazy = pcall(require, "lazy")
  if status_ok then
    local project_path = os.getenv("PROJECTS")
    lazy.setup({
      spec = import_list,
      defaults = {
        lazy = true,
      },
      dev = {
        path = project_path,
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = { "Issafalcon" },
        fallback = true,
      },
      checker = {
        enabled = true,
      },
      install = { colorscheme = { "catppuccin" }, missing = true },
      diff = {
        cmd = "diffview.nvim",
      },
      performance = {
        cache = {
          enabled = true,
          -- disable_events = {},
        },
        rtp = {
          disabled_plugins = {
            "gzip",
            "matchit",
            "matchparen",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    })
  end
end

return fignvim.plug
