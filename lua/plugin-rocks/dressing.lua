require("dressing").setup({
  input = {
    default_prompt = "➤ ",
    win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
  },
  select = {
    backend = { "telescope", "builtin" },
    builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
  },
})

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(...)
  vim.cmd("packadd dressing.nvim")
  return vim.ui.select(...)
end
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(...)
  vim.cmd("packadd dressing.nvim")
  return vim.ui.input(...)
end
