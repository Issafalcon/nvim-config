fignvim.git = {}
fignvim.git.gitsigns = {}

function fignvim.git.gitsigns.next_hunk()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then return "]c" end
  vim.schedule(function() gs.next_hunk() end)
  return "<Ignore>"
end

function fignvim.git.gitsigns.prev_hunk()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then return "[c" end
  vim.schedule(function() gs.prev_hunk() end)
  return "<Ignore>"
end

return fignvim.git
