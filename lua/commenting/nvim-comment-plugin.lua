require("nvim_comment").setup(
  {
    hook = function()
      require("ts_context_commentstring.internal").update_commentstring()
    end
  }
)

require "nvim-treesitter.configs".setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  }
}


vim.api.nvim_set_keymap("n", "<leader>/", ":CommentToggle<CR>", { silent = true })
vim.api.nvim_set_keymap("v", "<leader>/", ":CommentToggle<CR>", { silent = true })
