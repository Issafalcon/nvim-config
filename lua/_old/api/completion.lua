fignvim.completion = {}

function fignvim.completion.create_undo()
  local create_undo = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(create_undo, "n", false)
  end
end

return fignvim.completion
