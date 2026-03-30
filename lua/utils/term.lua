fignvim.term = {}

--- table of user created terminals
fignvim.term.user_terminals = {}

--- Toggle a user terminal if it exists, if not then create a new one and save it
---@param term_details string | table a terminal command string or a table of options for Terminal:new() (Check toggleterm.nvim documentation for table format)
function fignvim.term.toggle_term_cmd(term_details)
  -- if a command string is provided, create a basic table for Terminal:new() options
  if type(term_details) == "string" then
    term_details = { cmd = term_details, hidden = true }
  end
  -- use the command as the key for the table
  local term_key = term_details.cmd
  -- set the count in the term details
  if vim.v.count > 0 and term_details.count == nil then
    term_details.count = vim.v.count
    term_key = term_key .. vim.v.count
  end
  -- if terminal doesn't exist yet, create it
  if fignvim.term.user_terminals[term_key] == nil then
    fignvim.term.user_terminals[term_key] =
      require("toggleterm.terminal").Terminal:new(term_details)
  end
  -- toggle the terminal
  fignvim.term.user_terminals[term_key]:toggle()
end

return fignvim.term
