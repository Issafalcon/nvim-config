local status_ok, nvim_comment = pcall(require, "nvim_comment")
if not status_ok then
	return
end
nvim_comment.setup(
  {
    hook = function()
      require("ts_context_commentstring.internal").update_commentstring()
    end
  }
)

vim.api.nvim_set_keymap("n", "<leader>/", ":CommentToggle<CR>", { silent = true })
vim.api.nvim_set_keymap("v", "<leader>/", ":CommentToggle<CR>", { silent = true })

local ts_config_status_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ts_config_status_ok then
	return
end

ts_configs.setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  }
}
