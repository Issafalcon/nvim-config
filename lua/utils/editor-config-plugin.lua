vim.g.EditorConfig_exclude_patterns = {'fugitive://.*'}

vim.cmd [[
  augroup editor_config
    autocmd!
    autocmd FileType gitcommit let b:EditorConfig_disable = 1
  augroup end
]]
