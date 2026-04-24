vim.pack.add({
  { src = "https://github.com/folke/noice.nvim" },
})

require("noice").setup({
  views = {
    hover = {
      border = {
        style = "rounded",
      },
    },
  },
  lsp = {
    signature = {
      enabled = false, -- Use lsp_overloads instead
    },
    -- override markdown rendering so that LSP and other plugins use Treesitter
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  messages = {
    enabled = false,
  },
  notify = {
    enables = false, --Use Snacks notifier instead
  },
  cmdline = {
    enabled = true, --Use Snacks cmdline instead
    view = "cmdline",
  },
  routes = {
    {
      view = "split",
      filter = { event = "msg_show", min_height = 20 },
    },
  },
})
