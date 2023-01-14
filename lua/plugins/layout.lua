local maximizer_keys = {
  { "n", "<leader>m", ":MaximizerToggle!<CR>", { desc = "Toggle maximizer (current window)" } },
}

local maximizer_spec = {
  "szw/vim-maximizer",
  cmd = "MaximizerToggle",
  keys = fignvim.config.make_lazy_keymaps(maximizer_keys),
}

local bufferline_spec = {
  "akinsho/bufferline.nvim",
  event = "BufAdd",
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
}

local window_picker_spec = {
  "s1n7ax/nvim-window-pickerh",
  event = "BufReadPost",
  opts = function()
    local colours = require("user-configs.ui").colours
    return {
      use_winbar = "smart",
      other_win_hl_color = colours.grey_4,
    }
  end,
}

local heirline_spec = {
  "rebelot/heirline.nvim",
  event = "BufEnterPre",
  config = function()
    local heirline = require("heirline")
    local c = require("user-configs.ui").colours

    local function setup_colors()
      local statusline = fignvim.ui.get_hlgroup("statusline", { fg = c.fg, bg = c.grey_4 })
      local winbar = fignvim.ui.get_hlgroup("winbar", { fg = c.grey_2, bg = c.bg })
      local winbarnc = fignvim.ui.get_hlgroup("winbarnc", { fg = c.grey, bg = c.bg })
      local conditional = fignvim.ui.get_hlgroup("conditional", { fg = c.purple_1, bg = c.grey_4 })
      local string = fignvim.ui.get_hlgroup("string", { fg = c.green, bg = c.grey_4 })
      local typedef = fignvim.ui.get_hlgroup("typedef", { fg = c.yellow, bg = c.grey_4 })
      local heirlinenormal = fignvim.ui.get_hlgroup("herlinenormal", { fg = c.blue, bg = c.grey_4 })
      local heirlineinsert = fignvim.ui.get_hlgroup("heirlineinsert", { fg = c.green, bg = c.grey_4 })
      local heirlinevisual = fignvim.ui.get_hlgroup("heirlinevisual", { fg = c.purple, bg = c.grey_4 })
      local heirlinereplace = fignvim.ui.get_hlgroup("heirlinereplace", { fg = c.red_1, bg = c.grey_4 })
      local heirlinecommand = fignvim.ui.get_hlgroup("heirlinecommand", { fg = c.yellow_1, bg = c.grey_4 })
      local heirlineinactive = fignvim.ui.get_hlgroup("heirlineinactive", { fg = c.grey_7, bg = c.grey_4 })
      local gitsignsadd = fignvim.ui.get_hlgroup("gitsignsadd", { fg = c.green, bg = c.grey_4 })
      local gitsignschange = fignvim.ui.get_hlgroup("gitsignschange", { fg = c.orange_1, bg = c.grey_4 })
      local gitsignsdelete = fignvim.ui.get_hlgroup("gitsignsdelete", { fg = c.red_1, bg = c.grey_4 })
      local diagnosticerror = fignvim.ui.get_hlgroup("diagnosticerror", { fg = c.red_1, bg = c.grey_4 })
      local diagnosticwarn = fignvim.ui.get_hlgroup("diagnosticwarn", { fg = c.orange_1, bg = c.grey_4 })
      local diagnosticinfo = fignvim.ui.get_hlgroup("diagnosticinfo", { fg = c.white_2, bg = c.grey_4 })
      local diagnostichint = fignvim.ui.get_hlgroup("diagnostichint", { fg = c.yellow_1, bg = c.grey_4 })
      local colors = {
        fg = statusline.fg,
        bg = statusline.bg,
        section_fg = statusline.fg,
        section_bg = statusline.bg,
        git_branch_fg = conditional.fg,
        treesitter_fg = string.fg,
        scrollbar = typedef.fg,
        git_added = gitsignsadd.fg,
        git_changed = gitsignschange.fg,
        git_removed = gitsignsdelete.fg,
        diag_error = diagnosticerror.fg,
        diag_warn = diagnosticwarn.fg,
        diag_info = diagnosticinfo.fg,
        diag_hint = diagnostichint.fg,
        normal = heirlinenormal.fg,
        insert = heirlineinsert.fg,
        visual = heirlinevisual.fg,
        replace = heirlinereplace.fg,
        command = heirlinecommand.fg,
        inactive = heirlineinactive.fg,
        winbar_fg = winbar.fg,
        winbar_bg = winbar.bg,
        winbarnc_fg = winbarnc.fg,
        winbarnc_bg = winbarnc.bg,
        blank_bg = fignvim.ui.get_hlgroup("folded").fg,
        file_info_bg = fignvim.ui.get_hlgroup("visual").bg,
        nav_icon_bg = fignvim.ui.get_hlgroup("string").fg,
        folder_icon_bg = fignvim.ui.get_hlgroup("error").fg,
      }

      for _, section in ipairs({
        "git_branch",
        "file_info",
        "git_diff",
        "diagnostics",
        "lsp",
        "macro_recording",
        "treesitter",
        "nav",
      }) do
        if not colors[section .. "_bg"] then colors[section .. "_bg"] = colors["section_bg"] end
        if not colors[section .. "_fg"] then colors[section .. "_fg"] = colors["section_fg"] end
      end
      return colors
    end

    heirline.load_colors(setup_colors())
    local heirline_opts = {
      -- statusline
      {
        hl = { fg = "fg", bg = "bg" },
        fignvim.status.component.mode({
          mode_text = { icon = { kind = "vimicon", padding = { right = 1, left = 1 } } },
          -- define the highlight color for the text
          hl = { fg = "bg" },
          -- surround the component with a separators
          surround = {
            -- it's a left element, so use the left separator
            separator = "left",
            -- set the color of the surrounding based on the current mode using fignvim.status module
            color = function() return { main = fignvim.status.hl.mode_bg(), right = "blank_bg" } end,
          },
        }),
        -- we want an empty space here so we can use the component builder to make a new section with just an empty string
        fignvim.status.component.builder({
          { provider = "" },
          surround = { separator = "left", color = { main = "blank_bg", right = "file_info_bg" } },
        }),
        -- add a section for the currently opened file information
        fignvim.status.component.file_info({
          filename = {
            fname = function() return vim.fn.expand("%") end,
            modify = ":.",
          },
          -- enable the file_icon and disable the highlighting based on filetype
          file_icon = { padding = { left = 0 } },
          -- add padding
          padding = { right = 1 },
          -- define the section separator
          surround = { separator = "left", condition = false },
        }),
        fignvim.status.component.git_branch({ surround = { separator = "none" } }),
        fignvim.status.component.git_diff({ padding = { left = 1 }, surround = { separator = "none" } }),
        fignvim.status.component.fill(),
        fignvim.status.component.lsp({ lsp_client_names = false, surround = { separator = "none", color = "bg" } }),
        fignvim.status.component.macro_recording(),
        fignvim.status.component.fill(),
        fignvim.status.component.diagnostics({ surround = { separator = "right" } }),
        fignvim.status.component.lsp({ lsp_progress = false, surround = { separator = "right" } }),
        {
          -- define a simple component where the provider is just a folder icon
          fignvim.status.component.builder({
            { provider = fignvim.ui.get_icon("folderclosed") },
            padding = { right = 1 },
            hl = { fg = "bg" },
            surround = { separator = "right", color = "folder_icon_bg" },
          }),
          -- add a file information component and only show the current working directory name
          fignvim.status.component.file_info({
            -- we only want filename to be used and we can change the fname
            -- function to get the current working directory name
            filename = {
              fname = function() return vim.fn.getcwd() end,
              padding = { left = 1 },
            },
            -- disable all other elements of the file_info component
            file_icon = false,
            file_modified = false,
            file_read_only = false,
            -- use no separator for this part but define a background color
            surround = { separator = "none", color = "file_info_bg" },
          }),
        },
        {
          -- define a custom component with just a file icon
          fignvim.status.component.builder({
            { provider = fignvim.ui.get_icon("defaultfile") },
            -- add padding after icon
            padding = { right = 1 },
            -- set the icon foreground
            hl = { fg = "bg" },
            -- use the right separator and define the background color
            -- as well as the color to the left of the separator
            surround = { separator = "right", color = { main = "nav_icon_bg", left = "file_info_bg" } },
          }),
          -- add a navigation component and just display the percentage of progress in the file
          fignvim.status.component.nav({
            surround = { separator = "none", color = "file_info_bg" },
          }),
        },
      },

      --winbar
      {
        fallthrough = false,
        {
          condition = function()
            return fignvim.status.condition.buffer_matches({
              buftype = { "terminal", "prompt", "nofile", "help", "ckfix" },
              filetype = { "nvimtree", "neo-tree", "dashboard", "outline", "aerial" },
            })
          end,
          init = function() vim.opt_local.winbar = nil end,
        },
        {
          condition = fignvim.status.condition.is_active,
          fignvim.status.component.breadcrumbs({ hl = { fg = "winbar_fg", bg = "winbar_bg" } }),
        },
        fignvim.status.component.file_info({
          file_icon = { highlight = false },
          hl = { fg = "winbarnc_fg", bg = "winbarnc_bg" },
          surround = false,
        }),
      },
    }

    local heirline_setup = {}

    fignvim.fn.conditional_func(table.insert, vim.g.statusline_enabled, heirline_setup, heirline_opts[1])
    fignvim.fn.conditional_func(table.insert, vim.g.winbar_enabled, heirline_setup, heirline_opts[1])

    heirline.setup(heirline_setup)

    vim.api.nvim_create_augroup("heirline", { clear = true })
    vim.api.nvim_create_autocmd("colorscheme", {
      group = "heirline",
      desc = "refresh heirline colors",
      callback = function()
        heirline.reset_highlights()
        heirline.load_colors(setup_colors())
      end,
    })
  end,
}
return {
  window_picker_spec,
  maximizer_spec,
  bufferline_spec,
  heirline_spec,
}
