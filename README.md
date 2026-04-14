<p align="center">
<img src="https://user-images.githubusercontent.com/19861614/213907796-edbb5f52-90b9-438a-bc87-2eb45a3756eb.PNG" width="50%" height="50%" alt="Issafalcon Neovim" />
</p>

<hr>

# Issafalcon Neovim Configuration

A comprehensive Neovim setup built for polyglot development across C#/.NET, Python/Data Science, Terraform/Kubernetes, Markdown/Quarto, and general full-stack work. It prioritises keyboard-driven workflows, rich LSP integration, and a clean, distraction-free UI.

## Table of Contents

- [Structure](#structure)
- [Adding Plugins](#adding-plugins)
- [Core](#core)
- [LSP](#lsp)
- [Editing](#editing)
- [UI](#ui)
- [Navigation](#navigation)
- [Miscellaneous](#miscellaneous)
- [Git](#git)
- [Completions](#completions)
- [AI](#ai)
- [GitHub](#github)
- [Testing](#testing)
- [Debugging](#debugging)
- [Terminals](#terminals)
- [.NET](#net)
- [Data Science / Python / Quarto](#data-science--python--quarto)
- [Terraform & Helm](#terraform--helm)
- [Markdown & Images](#markdown--images)
- [PowerShell](#powershell)
- [Lua / Neovim Development](#lua--neovim-development)
- [HTTP](#http)
- [Documentation](#documentation)
- [Status Line](#status-line)

---

## Structure

```
.config/nvim/
├── lua/
│   ├── api/          # Convenience wrappers (terminal helpers, quarto utils, etc.)
│   ├── core/         # Core Neovim settings (options, keymaps, autocmds)
│   └── plugins/
│       ├── init.lua  # Plugin registration — comment out to disable any group
│       └── *.lua     # One file per plugin or plugin family
└── init.lua          # Entry point
```

Key design principles:
- **One file per plugin** — each `lua/plugins/<name>.lua` handles `vim.pack.add`, setup, and keymaps for that plugin in one place.
- **Grouped registration** — `plugins/init.lua` loads plugins in logical sections (LSP, Editing, UI, etc.). Comment out any `require(...)` line to disable a plugin without touching its config file.
- **API helpers** — shared utilities live under `lua/api/` to avoid duplication across plugin configs.

---

## Adding Plugins

Plugins are installed with Neovim's built-in `vim.pack` system (no external plugin manager required). The pattern used throughout is:

```lua
-- lua/plugins/my-plugin.lua
vim.pack.add({
  { src = "https://github.com/author/my-plugin.nvim" },
})

require("my-plugin").setup({ ... })

vim.keymap.set("n", "<leader>x", "<cmd>MyPlugin<cr>", { desc = "do the thing" })
```

Then register it in `plugins/init.lua`:

```lua
require("plugins.my-plugin")
```

To disable a plugin, comment out its `require(...)` line in `init.lua`.

---

## Core

**Why**: Every plugin-heavy config needs a stable foundation of utility libraries and UI plumbing loaded before anything else.

| Plugin | Purpose |
|---|---|
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library used by many plugins (async, path, etc.) |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library for popups and inputs |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | All-in-one: picker, notifications, lazygit, scroll, git browse |
| [noice.nvim](https://github.com/folke/noice.nvim) | Replaces cmdline, messages, and popupmenu with rich rendering |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | Collection of minimal, composable Lua modules (see per-section) |

> `snacks` and `noice` are loaded first so build/install notifications route through them rather than the default cmdline.

### Key shortcuts

| Key | Action |
|---|---|
| `<leader>lg` | Open lazygit |
| `<leader>G` | Open file/line in GitHub browser |
| `<leader>nd` | Dismiss all notifications |
| `<leader>nh` | Notification history |
| `<C-p>` | Find git-tracked files (Snacks picker) |
| `<leader>tf` | Find files |
| `<leader>tgl` | Git log |
| `<leader>tgd` | Git diff |
| `<leader>tr` | Registers |
| `<leader>tS` | Workspace symbols |
| `<leader>th` | Help tags |
| `<leader>tb` | Open buffers |
| `<leader>bd` | Close current buffer |

---

## LSP

**Why**: A consistent LSP experience across all languages — diagnostics, completion, go-to-definition, rename, and hover — without needing language-specific plugin sets.

| Plugin | Purpose |
|---|---|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Configures Neovim's built-in LSP client for each language server |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | Installs/manages LSP servers, linters, and formatters |
| [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Auto-installs Mason tools on startup |
| [lsp-progress.nvim](https://github.com/linrongbin16/lsp-progress.nvim) | Shows LSP indexing progress in the status line |
| [schemastore.nvim](https://github.com/b0o/schemastore.nvim) | JSON/YAML schemas for `yamlls` and `jsonls` |
| [lsp-overloads.nvim](https://github.com/Issafalcon/lsp-overloads.nvim) | Cycles through function signature overloads |
| terragrunt-ls | HCL language server for Terragrunt files |

### Typical workflow

Open any file → LSP attaches automatically → hover with `K`, jump to definition with `gd`, rename with `rn`, code actions with `<leader>ca`. Diagnostics navigate with `[g`/`]g`.

### Key shortcuts

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `gr` | Go to references |
| `K` | Hover documentation |
| `rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<A-s>` | Signature help / cycle overloads |
| `[g` / `]g` | Previous / next diagnostic |
| `<leader>ih` | Toggle inlay hints |

---

## Editing

**Why**: The editing group replaces or extends Neovim's default operators and text objects to make common transformations faster — formatting, surround, alignment, join/split, substitution — without breaking muscle memory.

| Plugin | Purpose |
|---|---|
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Format on save or on demand (prettier, stylua, black, etc.) |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Async linting per filetype |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Add/change/delete surrounding characters (`ys`, `cs`, `ds`) |
| [substitute.nvim](https://github.com/gbprod/substitute.nvim) | Exchange operator — swap two regions without a register |
| [cutlass.nvim](https://github.com/gbprod/cutlass.nvim) | `d`/`D`/`x` delete without polluting the default register; use `m` to cut |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Interactive project-wide search and replace (ast-grep or ripgrep) |
| [treesj](https://github.com/Wansmer/treesj) | Smart join/split of argument lists, arrays, and objects |
| [undotree](https://github.com/mbbill/undotree) | Visual undo history browser |
| [vim-matchup](https://github.com/andymass/vim-matchup) | Enhanced `%` matching for language-aware bracket/block pairs |
| [icon-picker.nvim](https://github.com/ziontee113/icon-picker.nvim) | Searchable emoji/icon picker |
| [mini.align](https://github.com/echasnovski/mini.nvim) | Interactive column alignment |
| [mini.pairs](https://github.com/echasnovski/mini.nvim) | Smart auto-pairs with markdown code fence awareness |
| [mini.ai](https://github.com/echasnovski/mini.nvim) | Extended text objects (functions, classes, arguments, blocks) |

### Typical workflow

- **Formatting**: `<leader>f` formats the buffer; autoformat runs on save.
- **Surround**: `ysiw"` surround word in quotes; `cs"'` change to single quotes; `ds"` delete.
- **Exchange**: `x` on region 1, `x` on region 2 — they swap.
- **Split/join**: `<leader>j` on a function call toggles between one-line and multi-line.
- **Search/replace**: `<leader>sr` opens grug-far with the project — type, confirm, done.
- **Undo**: `<A-u>` opens the undo tree to travel back to any past state.

### Key shortcuts

| Key | Action |
|---|---|
| `<leader>f` | Format buffer / selection |
| `<leader>taf` | Toggle autoformat on save |
| `<leader>sr` | Search and replace (grug-far) |
| `<leader>j` | Toggle join / split (treesj) |
| `<A-u>` | Toggle undotree |
| `s` / `ss` / `S` | Substitute operator / line / to EOL |
| `x` / `X` | Exchange operator / visual |
| `<leader>ga` | Start interactive alignment |
| `m` | Cut (move) to register |

---

## UI

**Why**: A clear, information-dense interface without visual noise — syntax highlighting via Treesitter, contextual breadcrumbs, buffer tabs, indentation guides, and colour utilities.

| Plugin | Purpose |
|---|---|
| [catppuccin](https://github.com/catppuccin/nvim) | Catppuccin Mocha colour scheme with broad plugin integrations |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, indentation, and structural navigation |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Tab bar showing open buffers with diagnostics and pinning |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides with current scope highlight |
| [nvim-navic](https://github.com/SmiteshP/nvim-navic) | LSP breadcrumb trail in the status line |
| [nvim-colorizer](https://github.com/NvChad/nvim-colorizer.lua) | Inline colour swatches for hex, rgb(), hsl() |
| [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) | Enhanced quickfix with preview and filtering |
| [vim-maximizer](https://github.com/szw/vim-maximizer) | Toggle single-window zoom |
| [mini.icons](https://github.com/echasnovski/mini.nvim) | Icon/glyph rendering (replaces nvim-web-devicons) |
| [colortils.nvim](https://github.com/max397574/colortils.nvim) | Colour picker and conversion utility |

### Key shortcuts

| Key | Action |
|---|---|
| `<leader>mm` | Toggle window maximizer |
| `<S-h>` / `[b` | Previous buffer |
| `<S-l>` / `]b` | Next buffer |
| `[B` / `]B` | Move buffer left / right |
| `<leader>bp` | Pin buffer |
| `<leader>bP` | Close all unpinned buffers |
| `<leader>br` / `<leader>bl` | Close buffers to the right / left |
| `]f` / `[f` | Next / prev function (Treesitter) |
| `]c` / `[c` | Next / prev class (Treesitter) |
| `]a` / `[a` | Next / prev argument (Treesitter) |

---

## Navigation

**Why**: Fast movement at every scale — character jumps, file switching, symbol outlines, and a full-featured file manager — all without leaving the keyboard.

| Plugin | Purpose |
|---|---|
| [leap.nvim](https://codeberg.org/andyg/leap.nvim) | Two-character label jump to any visible position |
| [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) | Yazi file manager embedded in Neovim (replaces netrw) |
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | LSP/Treesitter symbol outline sidebar |
| [harpoon](https://github.com/ThePrimeagen/harpoon) | Bookmark up to 8 files for instant switching |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder (used as fallback/extension host; Snacks is primary picker) |

### Typical workflow

- **File navigation**: `-` to open Yazi; browse/select a file; press `Enter` to open it.
- **Bookmarks**: `<leader>ha` on key files, then `<leader>1`–`<leader>8` to jump back instantly.
- **Symbol outline**: `<leader>a` to open aerial; `[y`/`]y` to jump between symbols.
- **Fast motion**: type `<C-m>` then two characters to jump anywhere on screen.

### Key shortcuts

| Key | Action |
|---|---|
| `<C-m>` / `<C-n>` | Leap forward / backward |
| `gs` | Leap across windows |
| `-` | Open Yazi at current file |
| `<leader>cw` | Open Yazi at cwd |
| `<C-up>` | Resume last Yazi session |
| `<leader>a` | Toggle aerial outline |
| `[y` / `]y` | Previous / next symbol (aerial) |
| `<leader>hh` | Harpoon menu |
| `<leader>ha` | Add file to harpoon |
| `<leader>1`–`8` | Jump to harpoon file 1–8 |

---

## Miscellaneous

| Plugin | Purpose |
|---|---|
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap hint popup with group labels |
| [persistence.nvim](https://github.com/folke/persistence.nvim) | Auto-save and restore sessions per directory |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Full-screen Git diff and file history viewer |
| [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) | Extract variable/function, inline, etc. |
| [vim-unimpaired](https://github.com/tpope/vim-unimpaired) | Paired `[`/`]` shortcuts for quickfix, loclist, buffers |
| [nx.nvim](https://github.com/Equilibris/nx.nvim) | Nx monorepo task runner |
| [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim) | Paste images from clipboard into Markdown (non-WSL only) |
| [qmk.nvim](https://github.com/codethread/qmk.nvim) | QMK keyboard layout editor |

### Key shortcuts

| Key | Action |
|---|---|
| `<leader>ps` | Load session for cwd |
| `<leader>pS` | Select session |
| `<leader>pl` | Load last session |
| `<leader>pd` | Don't save current session |
| `<leader>nx` | Nx task picker |
| `<leader>ii` | Paste image from clipboard (Markdown) |
| `:DiffviewLoad` | Open diffview (lazy-loaded) |

---

## Git

**Why**: Full git workflow inside Neovim — inline hunk signs, staging, blame, commit history, and CI pipeline status — so context-switching to a terminal or browser is rarely needed.

| Plugin | Purpose |
|---|---|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Hunk signs, staging, reset, inline blame, and diff |
| [git-messenger.vim](https://github.com/rhysd/git-messenger.vim) | Pop-up blame with full commit message for the current line |
| [pipeline.nvim](https://github.com/topaxi/pipeline.nvim) | View GitHub/GitLab CI pipeline runs inline |

### Typical workflow

Stage a hunk with `<leader>gs`, preview it with `<leader>gp`, open the full diff with `<leader>gd`, push and check CI with `<leader>gh`.

### Key shortcuts

| Key | Action |
|---|---|
| `]c` / `[c` | Next / prev hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gu` | Undo stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` / `<leader>gR` | Stage / reset buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line (inline) |
| `<leader>gB` | Toggle persistent blame |
| `<leader>gd` / `<leader>gD` | Diff against index / main |
| `<leader>gh` | Open CI pipeline viewer |
| `<leader>lg` | Open lazygit |
| `ih` | Select hunk (text object) |

---

## Completions

**Why**: Fast, accurate completions from LSP, snippets, buffer, and specialised sources (NuGet, npm, emoji) in a single unified menu.

| Plugin | Purpose |
|---|---|
| [blink.cmp](https://github.com/saghen/blink.cmp) | Rust-powered completion engine — LSP, snippets, buffer, ripgrep |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine with VSCode-style snippet support |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Community snippet collection for all common languages |
| blink-emoji | Emoji completions via `:emoji_name:` |
| cmp-rg | Ripgrep completions across the project |
| cmp-npm / cmp-nuget | npm and NuGet package name/version completions |

### Key shortcuts

| Key | Action |
|---|---|
| `<CR>` | Accept completion |
| `<C-space>` | Trigger completion |
| `<C-e>` | Dismiss completion |
| `<Up>` / `<Down>` | Navigate items |
| `<Tab>` / `<S-Tab>` | Jump snippet placeholders or select item |
| `<C-k>` | Show signature help |
| `<C-l>` | Cycle LuaSnip choice node |

---

## AI

| Plugin | Purpose |
|---|---|
| [copilot.vim](https://github.com/github/copilot.vim) | GitHub Copilot ghost-text completions |
| [nvim-mcp](https://github.com/linw1995/nvim-mcp) | Model Context Protocol client for AI tool integrations |

| Key | Action |
|---|---|
| `<C-x>` | Accept Copilot suggestion (insert mode) |

---

## GitHub

**Why**: Review and manage GitHub issues and pull requests without leaving Neovim.

[octo.nvim](https://github.com/pwntester/octo.nvim) provides a full GitHub UI — browse issues, comment, review diffs, approve, merge.

### Typical workflow

`:Octo pr list` → open a PR → `<leader>pd` to see the diff → `<leader>vs` to start a review → `<leader>ca` to add a review comment → `<leader>pm` to merge.

### Selected key shortcuts (PR/Issue buffers)

| Key | Action |
|---|---|
| `<leader>il` | List issues |
| `<leader>po` | Checkout PR branch |
| `<leader>pm` | Merge PR |
| `<leader>pf` | Show changed files |
| `<leader>pd` | Show PR diff |
| `<leader>vs` | Start review |
| `<leader>ca` | Add comment |
| `]c` / `[c` | Next / prev comment |
| `<C-b>` | Open in browser |
| `<C-y>` | Copy URL |

---

## Testing

**Why**: Run tests from inside the editor with inline pass/fail feedback and direct integration with the debugger.

[neotest](https://github.com/nvim-neotest/neotest) provides a unified runner for Python (pytest), .NET (xunit/nunit), Jest, and Lua (plenary).

### Key shortcuts

| Key | Action |
|---|---|
| `<leader>un` | Run nearest test |
| `<leader>uf` | Run all tests in file |
| `<leader>ua` | Run full test suite |
| `<leader>ud` | Debug nearest test |
| `<leader>us` | Toggle test summary panel |

---

## Debugging

**Why**: A full DAP (Debug Adapter Protocol) client replaces the need for an external IDE for step-through debugging across Python, JavaScript/TypeScript, .NET, and Lua.

| Plugin | Purpose |
|---|---|
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Core DAP client |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | Scopes, watches, breakpoints, REPL panels |
| [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) | Show variable values as virtual text inline |
| [persistent-breakpoints.nvim](https://github.com/Weissle/persistent-breakpoints.nvim) | Breakpoints survive restarts |
| [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python) | Python debugging via debugpy |
| [nvim-dap-vscode-js](https://github.com/mxsdev/nvim-dap-vscode-js) | JS/TS debugging via vscode-js-debug |
| [one-small-step-for-vimkind](https://github.com/jbyuki/one-small-step-for-vimkind) | Lua debugging |

### Key shortcuts

| Key | Action |
|---|---|
| `<F5>` | Launch debugger |
| `<F9>` | Continue |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>de` | Set exception breakpoints |
| `<leader>dbc` | Clear all breakpoints |
| `<leader>dj` | Step into |
| `<leader>dl` | Step over |
| `<leader>dk` | Step out |
| `<leader>dc` | Disconnect |
| `<leader>dC` | Terminate |
| `<F12>` | Hover variable |
| `<leader>d?` | Scopes panel |
| `<leader>dr` | Open REPL |

---

## Terminals

[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) provides floating, horizontal, and vertical terminal windows that persist across buffer switches.

> **Note**: For sending code to a REPL with vim-slime, prefer the listed terminal splits opened via `<leader>cp`/`<leader>ci` (see [Data Science](#data-science--python--quarto)) — ToggleTerm buffers are unlisted and work best for general shell use.

| Key | Action |
|---|---|
| `<F7><F7>` / `<C-'>` | Toggle terminal |
| `<F7>f` | Floating terminal |
| `<F7>h` | Horizontal split terminal |
| `<F7>v` | Vertical split terminal |
| `<F7>p` | Python 3 terminal |
| `<F7>n` | Node terminal |
| `<F7>d` | LazyDotnet terminal |

---

## .NET

| Plugin | Purpose |
|---|---|
| [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) | Full C# LSP via the Roslyn language server (replaces omnisharp) |
| [nuget.nvim](https://github.com/d7omdev/nuget.nvim) | NuGet package name and version completion in `.csproj` files |

Roslyn attaches automatically when a `.cs` file is opened inside a solution. NuGet completions activate in `<PackageReference>` elements.

---

## Data Science / Python / Quarto

This is one of the richest areas of the configuration. Three complementary tools cover the full notebook-style development loop:

| Plugin | Purpose |
|---|---|
| [vim-slime](https://github.com/jpalardy/vim-slime) | Send code cells or visual selections to any running REPL |
| [quarto-nvim](https://github.com/quarto-dev/quarto-nvim) | `.qmd` file support — LSP in embedded chunks, cell runner, preview |
| [otter.nvim](https://github.com/jmbuhr/otter.nvim) | Language context detection for embedded code blocks |
| [molten-nvim](https://github.com/benlubas/molten-nvim) | Jupyter kernel client — run cells, display inline outputs and images |
| [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) | Pick a Python virtual environment and wire it to LSP/linters |
| [vim-dadbod](https://github.com/tpope/vim-dadbod) + [dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) | Database query runner and browser |
| [image.nvim](https://github.com/3rd/image.nvim) | Render images inline (ueberzug backend — see [Markdown & Images](#markdown--images)) |

### Smart cell routing

The central mechanism is a `send_cell()` function in `slime.lua`. On every `<c-cr>` / `<leader><cr>`:

1. It checks whether Molten has an active kernel (`molten.status.kernels()`).
2. If yes → `QuartoSend` (routes through Molten, with inline output).
3. If no → `slime#send_cell` (sends to whichever REPL terminal is configured).

This means **the same shortcut works regardless of whether you are in slime mode or molten mode** — you switch modes simply by initialising or deinitialising Molten.

### Workflow A — Slime + IPython (lightweight, no kernel required)

```
1. <leader>ci      Open a new IPython terminal split (listed, visible to slime)
                   slime will auto-prompt to select this terminal on first send.
2. <c-cr>          Run the cell under the cursor — output appears in the terminal.
3. <cr>  (visual)  Send a visual selection to the terminal.
4. <leader>cs      Re-run slime config to switch to a different terminal.
```

> If slime says "terminal not found", run `<leader>cs` to pick the terminal manually,
> or open a new one with `<leader>ci` / `<leader>cp` (these create *listed* splits that slime
> can always see, unlike ToggleTerm which creates unlisted buffers).

### Workflow B — Molten + Jupyter kernel (full notebook experience)

```
1. <localleader>mi   MoltenInit — pick "python3" (the neovim venv kernel).
2. <c-cr>            Run cell — output appears as inline virtual text / popup.
3. <localleader>ms   Enter the output window (scroll, copy results).
4. <localleader>mh   Hide output.
5. <localleader>mr   Re-evaluate current cell.
6. <localleader>mR   Restart the kernel.
7. <localleader>md   MoltenDeinit — routing reverts to slime automatically.
```

The `python3` Jupyter kernel is registered as a user-wide kernel during `nvim/install.sh`
so it is always discoverable by Molten without activating the venv manually:

```bash
source ~/python3/envs/neovim/bin/activate
python3 -m ipykernel install --user --name python3 --display-name "Python 3 (neovim)"
```

### Quarto preview and conversion

```
<localleader>qp     Start quarto preview (live browser preview of the .qmd file).
<localleader>qq     Stop preview.
<localleader>rq     Pick an output format and render (PDF, HTML, DOCX, etc.).
```

To render to Markdown (`.md`) from the terminal:

```bash
quarto render my-doc.qmd --to gfm          # GitHub Flavored Markdown
quarto render my-doc.qmd --to commonmark   # CommonMark
```

Or from inside Neovim, use `<localleader>rq` and select `gfm` from the format picker.

### Inserting code chunks

| Key | Action |
|---|---|
| `<localleader>op` | Insert Python code chunk |
| `<localleader>or` | Insert R code chunk |
| `<localleader>ob` | Insert Bash code chunk |
| `<localleader>ol` | Insert Lua code chunk |

If the cursor is already inside a chunk of the same language, the chunk is split at that point.

### All Data Science keymaps

| Key | Action |
|---|---|
| `<c-cr>` / `<s-cr>` | Run cell (smart: molten if active, else slime) |
| `<leader><cr>` | Run cell (normal mode) |
| `<cr>` | Run visual selection |
| `<leader>ci` | New IPython terminal split |
| `<leader>cp` | New Python terminal split |
| `<leader>cr` | New R terminal split |
| `<leader>cn` | New shell terminal split |
| `<leader>cs` | Set / re-configure slime terminal |
| `<leader>cm` | Print current terminal job ID |
| `<localleader>rc` | Run cell (quarto runner, explicit) |
| `<localleader>ra` | Run cell and all above |
| `<localleader>rA` | Run all cells |
| `<localleader>rl` | Run current line |
| `<localleader>mi` | Initialise Molten kernel |
| `<localleader>md` | Deinitialise Molten |
| `<localleader>ms` | Show / enter output window |
| `<localleader>mh` | Hide output |
| `<localleader>mr` | Re-evaluate cell |
| `<localleader>mR` | Restart kernel |
| `<localleader>mp` | Image popup (molten) |
| `<localleader>mb` | Open output in browser |
| `<localleader>qp` | Quarto preview |
| `<localleader>qq` | Close quarto preview |
| `<localleader>rq` | Render quarto (pick format) |
| `<leader>Du` | Toggle dadbod UI |
| `<leader>Df` | Find dadbod buffer |

---

## Terraform & Helm

| Plugin | Purpose |
|---|---|
| [vim-terraform](https://github.com/hashivim/vim-terraform) | Terraform HCL syntax, folding, and `terraform fmt` alignment |
| [vim-helm](https://github.com/towolf/vim-helm) | Helm chart template syntax highlighting |

Both attach automatically on the relevant filetypes. Combined with the LSP config (`terraformls`, `helm_ls`), full hover, completion, and diagnostics are available in `.tf`, `.hcl`, and Helm `templates/` files.

---

## Markdown & Images

| Plugin | Purpose |
|---|---|
| [image.nvim](https://github.com/3rd/image.nvim) | Render images inline using ueberzug++ as the backend |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Concealed headings, code fences, and links in normal mode |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Live browser preview of Markdown files |

### image.nvim setup

`image.nvim` uses **ueberzug++** as its rendering backend (WezTerm's kitty protocol support is incomplete). The backend is installed as its own dotfiles module:

```bash
./bootstrap.sh -i -m ueberzugpp
```

ImageMagick (required by image.nvim for conversion) is also a standalone module:

```bash
./bootstrap.sh -i -m imagemagick
```

Both are installed automatically as dependencies when running `./bootstrap.sh -i -m nvim`.

Images are rendered automatically in Markdown/Quarto buffers and when opening an image file directly (`*.png`, `*.jpg`, `*.jpeg`, `*.gif`, `*.webp`, `*.avif`).

---

## PowerShell

[powershell.nvim](https://github.com/TheLeoP/powershell.nvim) provides a PowerShell LSP and script runner, lazy-loaded on `.ps1`/`.psm1` files. No additional keymaps — use standard LSP shortcuts.

---

## Lua / Neovim Development

| Plugin | Purpose |
|---|---|
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Neovim Lua API type annotations and LSP integration |
| [nvim-luapad](https://github.com/rafcamlet/nvim-luapad) | Interactive Lua scratch pad with live evaluation |

Open luapad with `:LuapadLoad`, then `<leader>lp`. Useful for prototyping plugin configs and testing Neovim API calls.

---

## HTTP

[kulala.nvim](https://github.com/mistweaverco/kulala.nvim) turns `.http` files into an executable REST client. Write requests directly in the buffer, send with `<leader>k`, and inspect responses in a split — no Postman or Insomnia needed.

---

## Documentation

| Plugin | Purpose |
|---|---|
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Obsidian vault integration — note linking, backlinks, templates, daily notes |
| [neogen](https://github.com/danymat/neogen) | Generate doc comments (xmldoc, jsdoc, pydoc, etc.) from function signatures |
| [vimtex](https://github.com/lervag/vimtex) | LaTeX compilation, viewer integration, and motion |
| [plantuml-syntax](https://github.com/aklt/plantuml-syntax) | PlantUML diagram syntax highlighting |
| [plantuml-previewer.vim](https://github.com/weirongxu/plantuml-previewer.vim) | Live PlantUML preview in browser |
| [swagger-preview.nvim](https://github.com/vinnymeller/swagger-preview.nvim) | Live OpenAPI/Swagger spec preview |

### Key shortcuts

| Key | Action |
|---|---|
| `gf` | Follow Obsidian wiki/markdown link |
| `<leader>/f` | Generate function docstring |
| `<leader>/F` | Generate file docstring |
| `<leader>/c` | Generate class docstring |
| `<leader>/t` | Generate type docstring |

---

## Status Line

[heirline.nvim](https://github.com/rebelot/heirline.nvim) provides a fully custom status line showing:
- Current mode indicator
- Git branch and hunk counts (via gitsigns)
- LSP diagnostics counts
- LSP server name and progress
- Breadcrumb navigation (via nvim-navic)
- File encoding, line ending format
- Cursor position and scroll percentage

No keymaps — purely informational.
