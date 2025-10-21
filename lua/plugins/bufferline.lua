vim.map.add({
  { src = "https://github.com/akinsho/bufferline.nvim" },
})

require("bufferline").setup({
  options = {
    -- stylua: ignore
    close_command = function(n) Snacks.bufdelete(n) end,
    -- stylua: ignore
    right_mouse_command = function(n) Snacks.bufdelete(n) end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    diagnostics_indicator = function(_, _, diag)
      local diag_icons = icons.diagnostics
      local ret = (diag.error and diag_icons.Error .. diag.error .. " " or "")
        .. (diag.warning and diag_icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {},
    ---@param opts bufferline.IconFetcherOpts
    get_element_icon = function(opts)
      -- return icons.ft[opts.filetype]
    end,
  },
})

-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
  callback = function()
    vim.schedule(function()
      pcall(nvim_bufferline)
    end)
  end,
})
