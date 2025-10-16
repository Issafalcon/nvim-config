vim.pack.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
    name = "conform.nvim",
    version = "stable",
  },
})

local prettier_filetpyes = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
  "htmlangular",
}

local opts = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_format = "fallback", -- not recommended to change
  },
  formatters_by_ft = {
    lua = { "stylua" },
    fish = { "fish_indent" },
    sh = { "shfmt" },
    python = { "black" },
    c = { "clang_format" },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
    prettier = {
      options = {
        -- Use a specific prettier parser for a filetype
        -- Otherwise, prettier will try to infer the parser from the file name
        ft_parsers = {
          javascript = "babel",
          javascriptreact = "babel",
          typescript = "typescript",
          typescriptreact = "typescript",
          vue = "vue",
          css = "css",
          scss = "scss",
          less = "less",
          html = "html",
          json = "json",
          jsonc = "json",
          yaml = "yaml",
          markdown = "markdown",
          ["markdown.mdx"] = "mdx",
          graphql = "graphql",
          handlebars = "glimmer",
        },
        -- Use a specific prettier parser for a file extension
        ext_parsers = {
          -- qmd = "markdown",
        },
      },
    },
  },
}

for _, ft in ipairs(prettier_filetpyes) do
  opts.formatters_by_ft[ft] = { "prettierd", "prettier", stop_after_first = true }
end

require("conform").setup(opts)

-- User Commands
vim.api.nvim_create_user_command("FigNvimFormat", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_create_user_command("FigNvimToggleAutoFormat", function()
  vim.g.disable_autoformat = not (vim.g.disable_autoformat or false)
  if vim.g.disable_autoformat then
    print("Autoformat disabled")
  else
    print("Autoformat enabled")
  end
end, {
  desc = "Toggle autoformat-on-save",
})

-- Special autoformat command on save to run lsp commands first for some clients
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format before save",
  pattern = "*",
  group = vim.api.nvim_create_augroup("FormatConfig", { clear = true }),
  callback = function(ev)
    local conform_opts = { bufnr = ev.buf, lsp_format = "fallback", timeout_ms = 2000 }

    -- Disable autoformat on certain filetypes
    local ignore_filetypes = { "sql", "java", "ts_ls" }
    if vim.tbl_contains(ignore_filetypes, vim.bo[ev.buf].filetype) then
      return
    end

    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[ev.buf].disable_autoformat then
      return
    end
    -- Disable autoformat for files in a certain path
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if bufname:match("/node_modules/") then
      return
    end

    local client = vim.lsp.get_clients({ name = "ts_ls", bufnr = ev.buf })[1]

    if not client then
      require("conform").format(conform_opts)
      return
    end

    local request_result = client:request_sync("workspace/executeCommand", {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(ev.buf) },
    })

    if request_result and request_result.err then
      vim.notify(request_result.err.message, vim.log.levels.ERROR)
      return
    end

    require("conform").format(conform_opts)
  end,
})

-- Keymaps
vim.keymap.set({ "n", "v" }, "<leader>f", "<cmd>FigNvimFormat<cr>", { desc = "Format current buffer or selection" })
vim.keymap.set("n", "<leader>taf", "<cmd>FigNvimToggleAutoFormat<cr>", { desc = "Toggle autoformat-on-save" })
