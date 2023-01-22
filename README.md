
<p align="center">
<img src="https://user-images.githubusercontent.com/19861614/213907796-edbb5f52-90b9-438a-bc87-2eb45a3756eb.PNG" width="50%" height="50%" alt="Issafalcon Richaaard" /> 
</p>

<hr>

# Issafalcon Neovim Configuration

## 🚀 Highlights

- Modular Neovim Configuration
- API convenience functions (many of which are courtesy of the AstroNvim codebase) under the `api` folder
- Core Neovim Configuration in the `core` folder
- LSP area with self contained API and LSP-Server configurations
- Plugin modules loaded with [Lazy.nvim](https://github.com/folke/lazy.nvim) for optimized lazy loaded plugins 

## Modules

All plugins are installed and configured via the `modules` folders. Each one contains a `spec.lua` file which brings together all the plugin specs for `Lazy.nvim` to load. 

All modules and their plugins are registered in the `init.lua` root file, so modules and plugins can be disabled by removing / commenting out from the registration function.

### Plugins

- Module containing all the supporting plugins for Neovim plugin development, or other plugins required as a dependency by multiple other plugins
- `plenary` is currently the only plugin installed as a default with this module. Others are explicitly registered

### Editing
### Cheatsheets

- Contains plugins to enable keymaps and commands to be added to cheatsheets like `Legendary` 
- Currently essential to keep in as mappigns cannot be created without the plugins in this module (except `cheatsheet`)

### Cut And Paste
### Search And Replace
### Navigation
### UI
### LSP
### Completion
### Snippets
### Treesitter
### Diagnostics
### Git
### Terminal
### Debugging
### Session
### Documenting
### Icons
### Testing
### Terraform
### .NET (dotnet)

## Roadmap / TODO

- Investigate [vim-dadbod](https://github.com/tpope/vim-dadbod)
 - Look into setting up additional related plugins [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) and [vim-dadbod-completion](https://github.com/kristijanhusak/vim-dadbod-completion)
- Provide smarter way for reloading neovim configuration without leaving neovim
- Create toggle commands for certain neovim / plugin functionality
