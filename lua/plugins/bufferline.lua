vim.pack.add({
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
      local diag_icons = require("icons").diagnostics
      local ret = (diag.error and diag_icons.error .. diag.error .. " " or "")
        .. (diag.warning and diag_icons.warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {},
    ---@param opts bufferline.IconFetcherOpts
    get_element_icon = function(opts)
      return fignvim.ui.get_icon("filetype", opts.filetype)
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

vim.keymap.set("n", "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Pin Buffer" })
vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "]b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "[B", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move Buffer Left" })
vim.keymap.set("n", "]B", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move Buffer Right" })
