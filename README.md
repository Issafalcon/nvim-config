# Issafalcon Neovim Configuration

[TOC]

## Highlights

- Simplified port of [AstroNvim](https://github.com/AstroNvim/AstroNvim) tailored for my own specific tastes
- API convenience functions (many of which are courtesy of the AstroNvim codebase) under the `api` folder
- Centralised configuration under the `user-configs` folder
  - Allowing for easier visualisation and modification of keymaps
  - LSP Server configurations
  - Custom options to control / toggle behaviour of plugins

## Functionality

### Package Installation

- Uses [Packer.nvim](https://github.com/wbthomason/packer.nvim) for plugin management
- Plugin configuration is kept in `lua/user-configs/plugins.lua`

Additional package management for third party dependencies is done via [Mason](https://github.com/williamboman/mason.nvim)

### Copy - Paste workflow

- Use [vim-cutlass](https://github.com/svermeulen/vim-cutlass) to prevent deletions from overriding the yank registers
 - Combined with a remap of the `create marks` mapping to use `\m` instead so it isn't shadowed by the new cutlass move command
- Uses a combination of [nvim-neoclip](https://github.com/AckslD/nvim-neoclip.lua) to cycle through yanks in the session,
[vim-subversive](https://github.com/svermeulen/vim-subversive) to easily substitute using motions, and [vim-abolish](https://github.com/tpope/vim-abolish) to find and replace
while preserving case and plurality.

### Searching workflow

## Roadmap / TODO

- Investigate [vim-dadbod](https://github.com/tpope/vim-dadbod)
 - Look into setting up additional related plugins [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) and [vim-dadbod-completion](https://github.com/kristijanhusak/vim-dadbod-completion)
- Provide smarter way for reloading neovim configuration without leaving neovim
- Create a package management snapshot and provide helper function to manage snapshots
- Create toggle commands for certain neovim / plugin functionality
- Organize the options
