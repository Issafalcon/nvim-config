-- Sessions
vim.opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winpos,terminal"

local status_ok, auto_session = pcall(require, "auto-session")
if not status_ok then
  return
end

auto_session.setup({
  auto_session_enabled = false,
  auto_session_create_enabled = false,
  auto_session_use_git_branch = true
})

local lens_status_ok, session_lens = pcall(require, "session-lens")
if not lens_status_ok then
  return
end

session_lens.setup()

vim.api.nvim_set_keymap("n", "<leader>sl", ":lua require('session-lens').search_session()<cr>", { silent = true, noremap = true })
