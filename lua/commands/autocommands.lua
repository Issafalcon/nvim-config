local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Adds custom highlights from user config
augroup("fignvim_highlights", { clear = true })
cmd({ "VimEnter", "ColorScheme" }, {
  desc = "Load custom highlights from user configuration",
  group = "fignvim_highlights",
  callback = function()
    if vim.g.colours_name then
      for group, spec in pairs(require("user-configs.ui").theme.highlights) do
        vim.api.nvim_set_hl(0, group, spec)
      end
    end
  end,
})
-- Adds URL highlighting to the buffer
augroup("highlighturl", { clear = true })
cmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = "highlighturl",
  pattern = "*",
  callback = function()
    fignvim.ui.set_url_match()
  end,
})

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
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    fignvim.config.map(
      "n",
      "q",
      ":close<CR>",
      { silent = true, buffer = true },
      "Buffers",
      "close_buf",
      "Closes buffers related to plugin menus etc."
    )
    vim.api.nvim_set_option("buflisted", false)
  end,
})

-- C# Indent Settings
augroup("csharp", { clear = true })
cmd("FileType", {
  desc = "C# Indent Settings",
  group = "csharp",
  pattern = "cs",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.tabstop = 4
    vim.api.nvim_set_option_value("foldlevelstart", 2, { scope = "local" })
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

-- Alpha (dashboard) configuration when it exists
if fignvim.plug.is_available("alpha-nvim") then
  augroup("alpha_settings", { clear = true })
  if fignvim.plug.is_available("bufferline.nvim") then
    cmd("FileType", {
      desc = "Disable tabline for alpha",
      group = "alpha_settings",
      pattern = "alpha",
      callback = function()
        local prev_showtabline = vim.opt.showtabline
        vim.opt.showtabline = 0
        vim.opt_local.winbar = nil
        cmd("BufUnload", {
          pattern = "<buffer>",
          callback = function()
            vim.opt.showtabline = prev_showtabline
          end,
        })
      end,
    })
  end
  cmd("FileType", {
    desc = "Disable statusline for alpha",
    group = "alpha_settings",
    pattern = "alpha",
    callback = function()
      local prev_status = vim.opt.laststatus
      vim.opt.laststatus = 0
      cmd("BufUnload", {
        pattern = "<buffer>",
        callback = function()
          vim.opt.laststatus = prev_status
        end,
      })
    end,
  })
  cmd("VimEnter", {
    desc = "Start Alpha when vim is opened with no arguments",
    group = "alpha_settings",
    callback = function()
      -- optimized start check from https://github.com/goolord/alpha-nvim
      local alpha_avail, alpha = pcall(require, "alpha")
      if alpha_avail then
        local should_skip = false
        if vim.fn.argc() > 0 or vim.fn.line2byte("$") ~= -1 or not vim.o.modifiable then
          should_skip = true
        else
          for _, arg in pairs(vim.v.argv) do
            if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
              should_skip = true
              break
            end
          end
        end
        if not should_skip then
          alpha.start(true)
        end
      end
    end,
  })
end
