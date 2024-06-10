fignvim.git = {}
fignvim.git.gitsigns = {}

function fignvim.git.gitsigns.next_hunk()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    gs.next_hunk()
  end)
  return "<Ignore>"
end

function fignvim.git.gitsigns.prev_hunk()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    gs.prev_hunk()
  end)
  return "<Ignore>"
end

function fignvim.git.list_branches()
  local branches = vim.fn.systemlist([[git branch 2>/dev/null]])
  local new_branch_prompt = "Create new branch"
  table.insert(branches, 1, new_branch_prompt)

  vim.ui.select(branches, {
    prompt = "Git branches",
  }, function(choice)
    if choice == nil then
      return
    end

    if choice == new_branch_prompt then
      local new_branch = ""
      vim.ui.input({ prompt = "New branch name:" }, function(branch)
        if branch ~= nil then
          vim.fn.systemlist("git checkout -b " .. branch)
        end
      end)
    else
      vim.fn.systemlist("git checkout " .. choice)
    end
  end)
end

return fignvim.git
