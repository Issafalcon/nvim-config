return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "David-Kunz/cmp-npm",
      "lukas-reineke/cmp-rg",
      {
        "onsails/lspkind.nvim",
        event = "BufReadPre",
        config = function()
          local lspkind = require("lspkind")
          fignvim.lspkind = {
            mode = "symbol",
            preset = "codicons",
          }
          lspkind.init(fignvim.lspkind)
        end,
      },
    },
    config = function()
      -- code
      local cmp = require("cmp")

      local sources = {
        nvim_lsp = { name = "nvim_lsp", priority = 1000, keyword_length = 2 },
        nvim_lua = { name = "nvim_lua", priority = 800, keyword_length = 2 },
        luasnip = { name = "luasnip", priority = 750, keyword_length = 2 },
        npm = { name = "npm", priority = 725, keyword_length = 2 },
        emoji = { name = "emoji", priority = 700, keyword_length = 2 },
        buffer = { name = "buffer", priority = 500, keyword_length = 2 },
        path = { name = "path", priority = 250, keyword_length = 2 },
        rg = { name = "rg", priority = 200, keyword_length = 2 },
      }

      local common_sources = {
        sources.nvim_lsp,
        sources.luasnip,
        sources.rg,
        sources.emoji,
        -- sources.buffer,
        sources.path,
      }

      cmp.setup({
        enabled = function()
          if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
          return true
        end,
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = {
            cmp.ItemField.Abbr,
            cmp.ItemField.Kind,
            cmp.ItemField.Menu,
          },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "(" .. strings[2] .. ")"

            return kind
          end,
        },
        snippet = {
          expand = function(args)
            local luasnip_ok, luasnip = pcall(require, "luasnip")
            fignvim.fn.conditional_func(luasnip.lsp_expand, luasnip_ok, args.body)
          end,
        },
        sources = cmp.config.sources(common_sources),
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = {
            border = "none",
          },
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            max_width = 80,
            max_height = 50,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          -- Fix for copilot key-mapping fallback mechanism issue - https://github.com/hrsh7th/nvim-cmp/blob/b16e5bcf1d8fd466c289eab2472d064bcd7bab5d/doc/cmp.txt#L830-L852
          ["<C-x>"] = cmp.mapping(
            function(fallback)
              vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)), "n", true)
            end
          ),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })

      -- Set configuration for specific filetype.
      -- cmp.setup.filetype("gitcommit", {
      --   sources = cmp.config.sources({
      --     { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
      --   }, {
      --     { name = "buffer" },
      --   }),
      -- })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline", keyword_pattern = "[^!]\\k\\+" },
        }),
      })

      cmp.setup.filetype("mysql", {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
        }),
      })
    end,
  },
}
