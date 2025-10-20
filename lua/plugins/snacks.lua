vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

local notify = vim.notify

require("snacks").setup({
  image = { enabled = true },
  scroll = { enabled = true },
  lazygit = { enabled = true },
  gitbrowse = { enabled = true },
  styles = {
    styles = {
      lazygit = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
  },
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  input = { enabled = false },
  picker = { enabled = false },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
  terminal = { enabled = false },
})

local noice_installed, _ = pcall(vim.pack.get(), {"noice.nvim"})
if noice_installed then
  -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
  -- this is needed to have early notifications show up in noice history
  vim.notify = notify
end

vim.keymap.set("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "Open lazygit in Snacks" })
