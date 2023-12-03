return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "NvimTree", text = "", padding = 1 },
          { filetype = "neo-tree", text = "", padding = 1 },
          { filetype = "Outline", text = "", padding = 1 },
        },
        buffer_close_icon = fignvim.ui.get_icon("BufferClose"),
        modified_icon = fignvim.ui.get_icon("FileModified"),
        close_icon = fignvim.ui.get_icon("NeovimClose"),
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and fignvim.ui.get_icon("DiagnosticError") .. diag.error .. " " or "")
            .. (diag.warning and fignvim.ui.get_icon("DiagnosticWarn") .. diag.warning or "")
          return vim.trim(ret)
        end,
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 20,
        separator_style = "thin",
      },
    },
  },
}
