local status_ok, neoclip = pcall(require, "neoclip")
if not status_ok then
  return
end

neoclip.setup();

vim.api.nvim_set_keymap("n", "<leader>sy", ":Telescope neoclip<cr>", {noremap = true, silent = true})
