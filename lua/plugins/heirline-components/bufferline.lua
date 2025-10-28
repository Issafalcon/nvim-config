local utils = require("heirline.utils")

local TablineBufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. "."
  end,
  hl = { fg = "" },
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TablineFileName = {
  provider = function(self)
    -- self.filename will be defined later, just keep looking at the example!
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
local TablineFileFlags = {
  {
    condition = function(self)
      return #vim.diagnostic.get(self.bufnr) > 0
    end,
    static = {
      error_icon = fignvim.ui.get_icon("DiagnosticError"),
      warn_icon = fignvim.ui.get_icon("DiagnosticWarn"),
      info_icon = fignvim.ui.get_icon("DiagnosticInfo"),
      hint_icon = fignvim.ui.get_icon("DiagnosticHint"),
    },

    update = { "DiagnosticChanged", "BufEnter" },

    {
      provider = " ",
    },
    {
      provider = function(self)
        -- 0 is just another output, we can decide to print it or not!
        return self.errors > 0 and self.error_icon
      end,
      hl = { fg = "diag_error" },
    },
    {
      provider = function(self)
        return self.errors == 0 and self.warnings > 0 and self.warn_icon
      end,
      hl = { fg = "diag_warn" },
    },
    {
      provider = function(self)
        return self.errors == 0
          and self.warnings == 0
          and self.info > 0
          and self.info_icon
      end,
      hl = { fg = "diag_info" },
    },
    {
      provider = function(self)
        return self.errors == 0
          and self.warnings == 0
          and self.info == 0
          and self.hints > 0
          and self.hint_icon
      end,
      hl = { fg = "diag_hint" },
    },
  },
  {
    condition = function(self)
      return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
    end,
    provider = fignvim.ui.get_icon("FileModified") .. " ",

    hl = { fg = "filename_fg" },
  },
  {
    condition = function(self)
      return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
    end,
    provider = function(self)
      if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
        return "  "
      else
        return ""
      end
    end,
    hl = { fg = "orange" },
  },
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    self.errors =
      #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
    self.warnings =
      #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
    self.hints =
      #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.HINT })
    self.info =
      #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.INFO })
  end,
  hl = function(self)
    if self.is_active then
      return "TabLineSel"
    else
      return "TabLine"
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == "m" then -- close on mouse middle click
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_buffer_callback",
  },
  TablineBufnr,
  require("plugins.heirline-components.file_icon"), -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
  TablineFileName,
  TablineFileFlags,
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
  condition = function(self)
    return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
  end,
  { provider = " " },
  {
    provider = "󰅗 ",
    hl = { fg = "gray" },
    on_click = {
      callback = function(_, minwid)
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = "heirline_tabline_close_buffer_callback",
    },
  },
}

-- The final touch!
local TablineBufferBlock = utils.surround({ "", "" }, function(self)
  if self.is_active then
    return utils.get_highlight("TabLineSel").bg
  else
    return utils.get_highlight("TabLine").bg
  end
end, { TablineFileNameBlock, TablineCloseButton })

-- and here we go
local BufferLine = utils.make_buflist(
  TablineBufferBlock,
  { provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
  { provider = "", hl = { fg = "gray" } } -- right trunctation, also optional (defaults to ...... yep, ">")
  -- by the way, open a lot of buffers and try clicking them ;)
)

return BufferLine
