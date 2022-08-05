local status_ok, icons = pcall(require, "nvim-web-devicons")
if not status_ok then
  return
end

icons.setup {
 -- your personnal icons can go here (to override)
 -- DevIcon will be appended to `name`
 override = {
    tex = {
      icon = "",
      color = "#3D6117",
      name = "Tex" 
    }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

-- Workaround for a bug in nerd-tree devicons where tex files move across the screen
vim.cmd('let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}')
vim.cmd('let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols["tex"] = ""')
