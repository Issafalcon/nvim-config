local function ToggleLineNumbers()
  vim.wo.number = not vim.wo.number 
end

local function ToggleRelativeLineNumbers()
  vim.wo.relativenumber = not vim.wo.relativenumber 
end

return {
  ToggleLineNumbers = ToggleLineNumbers,
  ToggleRelativeLineNumbers = ToggleRelativeLineNumbers
}
