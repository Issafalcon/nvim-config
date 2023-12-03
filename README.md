<p align="center">
<img src="https://user-images.githubusercontent.com/19861614/213907796-edbb5f52-90b9-438a-bc87-2eb45a3756eb.PNG" width="50%" height="50%" alt="Issafalcon Richaaard" />
</p>

<hr>

# Issafalcon Neovim Configuration

## 🚀 Highlights

- API convenience functions (many of which are courtesy of the AstroNvim codebase) under the `api` folder
- Core Neovim Configuration in the `core` folder
- LSP area with self contained API and LSP-Server configurations
- Plugin modules loaded with [Lazy.nvim](https://github.com/folke/lazy.nvim) for optimized lazy loaded plugins

## Plugins

All plugins are installed and configured via the `plugins` folders. Each one contains a `.lua` file which brings together all the plugin specs for `Lazy.nvim` to load.

All plugins are registered in the `init.lua` root file, so modules and plugins can be disabled by removing / commenting out from the registration function.
