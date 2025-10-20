vim.pack.add({
  { src = "https://github.com/seblyng/roslyn.nvim" },
})

return {
  "seblyng/roslyn.nvim",
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {
    -- your configuration comes here; leave empty for default settings
  },
}
