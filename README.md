# Issafalcon Neovim Configuration

## Highlights

- Simplified port of [AstroNvim](https://github.com/AstroNvim/AstroNvim) tailored for my own specific tastes
- API convenience functions (many of which are courtesy of the AstroNvim codebase) under the `api` folder
- Centralised configuration under the `user-configs` folder
  - Allowing for easier visualisation and modification of keymaps
  - LSP Server configurations
  - Custom options to control / toggle behaviour of plugins

## Functionality

### Utilities

#### Plugins

| Plugin Name    | URL                                        | Description                                                        |
| -------------- | ------------------------------------------ | ------------------------------------------------------------------ |
| Mason          | https://github.com/williamboman/mason.nvim | Package manager for LSP clients, DAP adapters, Linters and more... |

### Searching

#### Plugins

| Plugin Name          | URL                                                         | Description                                                                                       |
| --------------       | --------------                                              | --------------                                                                                    |
| Telescope            | https://github.com/nvim-telescope/telescope.nvim            | The ultimate, extensible fuzzy finder                                                             |
| Telescope-fzy-native | https://github.com/nvim-telescope/telescope-fzy-native.nvim | Replaces the native file and generic sorter that comes with Telescope                             |
| Spectre              | https://github.com/nvim-pack/nvim-spectre                   | Find and replace search panel with regex capabilities and file globbing for inclusion / exclusion |

### Commenting

#### Plugins

| Plugin Name                   | URL                                                            | Description                                                                            |
| ----------------              | ---------------                                                | ---------------                                                                        |
| Comment.nvim                  | https://github.com/numToStr/Comment.nvim                       | Most feature rich commenting plugin for Neovim out there                               |
| nvim-ts-context-commentstring | https://github.com/JoosepAlviste/nvim-ts-context-commentstring | Sets `commentstring` option based on cursor location in file (Used mainly for tsx etc) |

## TODO List

- Add virtual mappings for `vim-surround`
- Add virtual mappings for `vim-unimpaired`
