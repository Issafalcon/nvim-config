fignvim.plug = {}

function fignvim.plug.initialise_lazy_nvim()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=v7.9.0",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

function fignvim.plug.setup_lazy_plugins()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.rtp:prepend(lazypath)

  local import_list = {}
  for module_name, _ in pairs(vim.g.fignvim_modules) do
    table.insert(import_list, { import = "modules." .. module_name .. ".spec" })
  end

  local status_ok, lazy = pcall(require, "lazy")
  if status_ok then
    lazy.setup({
      spec = import_list,
      defaults = {
        lazy = true,
      },
      dev = {
        path = "$PROJECTS",
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = {},
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

--- Special mapping callback for git_signs so mappings are created per buffer during the on_attach callback
---@param bufnr number The buffer number to create mappings for
function fignvim.plug.gitsigns_on_attach_cb(bufnr)
  local plugin = "gitsigns.nvim"
  local mappings = fignvim.config.get_plugin_mappings(plugin)
  for _, map in pairs(mappings) do
    fignvim.config.create_mapping(map, bufnr)
  end
end

return fignvim.plug
