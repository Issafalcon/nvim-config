_G.fignvim = {} -- Create global fignvim table

require("utils")
require("autocmds")
require("options")
require("mappings")

require("plugins")

require("ui")

require("diagnostics")

local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Quit Nvim when only sidebars are left
augroup("auto_quit", { clear = true })
cmd("BufEnter", {
  desc = "Quit AstroNvim if more than one window is open and only sidebar windows are list",
  group = "auto_quit",
  callback = function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    -- Both neo-tree and aerial will auto-quit if there is only a single window left
    if #wins <= 1 then
      return
    end
    local sidebar_fts = { aerial = true, ["neo-tree"] = true }
    for _, winid in ipairs(wins) do
      if vim.api.nvim_win_is_valid(winid) then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        -- If any visible windows are not sidebars, early return
        if not sidebar_fts[vim.api.nvim_buf_get_option(bufnr, "filetype")] then
          return
        end
      end
    end
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd.tabclose()
    else
      vim.cmd.qall()
    end
  end,
})

-- Modifies settings and mappings for certain plugin buffer types
augroup("support_buffers", { clear = true })
cmd("FileType", {
  desc = "Close the matching buffer types with 'q'",
  group = "support_buffers",
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "grug-far" },
  callback = function()
    vim.keymap.set("n", "q", ":close<CR>", { silent = true, buffer = true })
    vim.api.nvim_set_option_value("buflisted", false, { scope = "local" })
  end,
})

-- Sets spelling option for certain filetypes
augroup("enable_spelling", { clear = true })
cmd("FileType", {
  desc = "Enable spell checking for certain filetypes",
  group = "enable_spelling",
  pattern = { "markdown", "text", "tex", "org" },
  callback = function()
    vim.api.nvim_set_option_value("spell", true, { scope = "local" })
  end,
})
