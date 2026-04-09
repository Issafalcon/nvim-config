vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/saghen/blink.compat" },
  { src = "https://github.com/moyiz/blink-emoji.nvim" },
  -- nvim-cmp sources consumed via blink.compat
  { src = "https://github.com/lukas-reineke/cmp-rg" },
  { src = "https://github.com/David-Kunz/cmp-npm" },
  { src = "https://github.com/PasiBergman/cmp-nuget" },
})

require("blink.compat").setup()

require("blink.cmp").setup({
  keymap = {
    -- 'enter' preset: <CR> accepts, <C-space> shows menu, <C-e> hides,
    -- <C-n>/<C-p> and <Up>/<Down> navigate the menu, <C-b>/<C-f> scroll docs.
    preset = "enter",

    -- <C-k>/<C-j> are window-navigation keys in normal mode; in insert mode
    -- repurpose <C-k> for signature help (replaces the old cmp select_prev role).
    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

    -- Arrow keys navigate the menu.
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },

    -- Tab: jump to the next snippet placeholder first, then navigate the
    -- completion menu, then fall back to normal Tab (indentation).
    -- S-Tab: reverse direction. This eliminates the old C-k/C-j clash with
    -- LuaSnip keymaps – snippet jumping now lives entirely on Tab/S-Tab.
    ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
  },

  -- Delegate snippet expansion and placeholder jumping to LuaSnip.
  snippets = { preset = "luasnip" },

  appearance = {
    -- Keep nvim-cmp highlight groups as fallback while themes catch up.
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      treesitter_highlighting = true,
      window = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        max_width = 80,
        max_height = 50,
      },
    },
    menu = {
      border = "rounded",
      draw = {
        -- Treesitter syntax highlighting in the menu for LSP items.
        treesitter = { "lsp" },
      },
    },
    list = {
      selection = {
        -- Match the old cmp behaviour: nothing is pre-selected and items are
        -- not auto-inserted when navigating the menu.
        preselect = false,
        auto_insert = false,
      },
    },
    accept = {
      auto_brackets = { enabled = true },
    },
  },

  signature = {
    enabled = true,
    window = { border = "rounded" },
  },

  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer", "rg", "npm", "emoji" },

    per_filetype = {
      -- markdown gets spell completion in addition to the standard set.
      markdown = { "lsp", "snippets", "path", "buffer", "spell" },
      mysql = { "dadbod" },
      xml = { "lsp", "path", "snippets", "nuget", "rg" },
    },

    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },

      rg = {
        name = "Ripgrep",
        module = "blink.compat.source",
        score_offset = -10,
        opts = { additional_arguments = "--smart-case" },
      },

      npm = {
        name = "npm",
        module = "blink.compat.source",
        score_offset = -5,
        enabled = function()
          return vim.tbl_contains(
            { "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
            vim.bo.filetype
          )
        end,
      },

      nuget = {
        name = "nuget",
        module = "blink.compat.source",
      },

      emoji = {
        name = "Emoji",
        module = "blink-emoji",
        score_offset = -5,
      },

      dadbod = {
        name = "vim-dadbod-completion",
        module = "blink.compat.source",
      },

      spell = {
        name = "spell",
        module = "blink.compat.source",
        score_offset = -5,
        -- Only activate when spell checking is enabled for the buffer.
        enabled = function()
          return vim.bo.spell
        end,
        opts = {
          keep_all_entries = false,
          enable_in_context = function()
            return true
          end,
        },
      },
    },
  },

  cmdline = {
    enabled = true,
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      if type == ":" then
        return { "cmdline", "path" }
      end
      return {}
    end,
  },

  -- Use the Rust fuzzy binary built via the PackChanged autocmd in autocmds.lua.
  -- Falls back silently to the Lua implementation until the build has run.
  fuzzy = { implementation = "prefer_rust" },
})
