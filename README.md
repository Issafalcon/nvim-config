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

In each module, I've documented some notes about each plugin and how frequently I use that plugin on a 1-5 scale (5 = most frequent use). This helps me to work out which plugins I actually use / need.

### Plugins

- Module containing all the supporting plugins for Neovim plugin development, or other plugins required as a dependency by multiple other plugins
- `plenary` is currently the only plugin installed as a default with this module. Others are explicitly registered

| Plugin                                                                | Notes                                                                                                                                  | Usage                                                                                        |
| --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| **[folke/neodev.nvim](https://github.com/folke/neodev.nvim)**         | Provides full signature help for vim api and plugins. Enabled by default for `lua_ls` LSP. Can introduce performance hit in some cases | <div style="color: green">4</div> - Obviously only used for lua editing.                     |
| **[rafcamlet/nvim-luapad](https://github.com/rafcamlet/nvim-luapad)** | Scratchpad for Lua with virtualtext output. Useful for config or plugin dev.                                                           | <div style="color: orange">3</div> Only when working on Lua files (config and plugins)       |
| **[kkharji/sqllite.lua](https://github.com/kkharji/sqlite.lua)**      | DB for some plugins. Not really used in my workflow                                                                                    | <div style="color: red">1</div> Disabled for the mostpart until I find a plugin that uses it |

### Editing

| Plugin                                                                                | Notes                                                                                                                                       | Usage                                                                                                               |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **[junegunn/vim-easy-align](https://github.com/junegunn/vim-easy-align)**             | Align around arbitrary characters in blocks. Mostly redundant due to LSP and formatters.                                                    | <div style="color: orange">2</div> Not many use cases left.                                                         |
| **[cshuaimin/ssr.nvim](https://github.com/cshuaimin/ssr.nvim)**                       | Structural search and replace. Some uses, but fairly fiddly. Uses treesitter                                                                | <div style="color: red">1</div>                                                                                     |
| **[Wansmer/treesj](https://github.com/Wansmer/treesj)**                               | Excellent splitting/joining plugin for code blocks. No real advanced config used, but could extend for use with C#                          | <div style="color: orange">3</div> Mostly useful in JS / TS dev for me.                                             |
| **[monaqa/dial.nvim](https://github.com/monaqa/dial.nvim)**                           | Nice little plugin for better increment and decrement mappings. Not yet configured any of my own custom augends, but could do in the future | <div style="color: green">4</div> Mostly useful in JS / TS dev for me.                                              |
| **[andymass/vim-matchup](https://github.com/andymass/vim-matchup)**                   | Enhances the `%` vim operator and integrates with treesitter.                                                                               | <div style="color: green">5</div> Very useful                                                                       |
| **[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)**                 | Best autopair plugin. I could configure this a bit more so it works better for me. Needs a bit of extra setup with `nvim-cmp`               | <div style="color: green">5</div> Indespensible                                                                     |
| **[kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)**               | Neovim version of vim-surround. Works nicely. Job done.                                                                                     | <div style="color: green">5</div> Indespensible                                                                     |
| **[tpope/vim-unimpaired](https://github.com/tpope/vim-unimpaired)**                   | Just some extra mappings from `tpope`. I always forget I can encode/decode URLs and XML with these                                          | <div style="color: green">5</div> Indespensible                                                                     |
| **[ThePrimeagen/refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)** | Some additional refactoring enhancements that can be fed into the LSP code actions (language dependent)                                     | <div style="color: orange">3</div> Not using this that much, but could be because I haven't configured it properly. |

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
