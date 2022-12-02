local M = {}

---@class FigNvimMapping
---@field group string Group name for the Mapping (for nvim-mapper)
---@field desc string Description of the Mapping
---@field mode string | table Mode or Modes for the Mapping
---@field lhs string Trigger keys for the Mapping
---@field lhs string Trigger keys for the Mapping
---@field rhs string | function Command to run for the Mapping
---@field isVirtual? boolean Whether the keymap should only be virtual (i.e. Displayed in nvim-mapper) rather than being created - default = false
---@field opts? table Options for the Mapping (default = { silent = true })

-- stylua: ignore
---@type table<string, table<string, FigNvimMapping>>
M.general_mappings = {
  -- Navigate between windows in normal mode
  Window = {
    window_left         = { mode = "n", lhs = "<C-h>", rhs     = "<C-w>h", desc                  = "Move to next window to the left", },
    window_right        = { mode = "n", lhs = "<C-l>", rhs     = "<C-w>l", desc                  = "Move to next window to the right" },
    window_down         = { mode = "n", lhs = "<C-j>", rhs     = "<C-w>j", desc                  = "Move to next window down" },
    window_up           = { mode = "n", lhs = "<C-k>", rhs     = "<C-w>k", desc                  = "Move to next window up" },
    window_resize_up    = { mode = "n", lhs = "<C-Up>", rhs    = ":resize +2<CR>", desc          = "Resize window horizontally up", },
    window_resize_down  = { mode = "n", lhs = "<C-Down>", rhs  = ":resize -2<CR>", desc          = "Resize window horizontally down", },
    window_resize_left  = { mode = "n", lhs = "<C-Left>", rhs  = ":vertical resize +2<CR>", desc = "Resize window vertically to the left", },
    window_resize_right = { mode = "n", lhs = "<C-Right>", rhs = ":vertical resize -2<CR>", desc = "Resize window vertically to the right", },
  },
  Navigation = {
    buf_next                  = { mode = "n", lhs = "<S-l>", rhs      = ":bnext<CR>", desc                                                 = "Move to next buffer", },
    buf_prev                  = { mode = "n", lhs = "<S-h>", rhs      = ":bprevious<CR>", desc                                             = "Move to previous buffer", },
    buf_close                 = { mode = "n", lhs = "<C-x>", rhs      = ":bdelete<CR>", desc                                               = "Close current buffer", },
    toggle_line_nums          = { mode = "n", lhs = "<leader>l", rhs  = function () fignvim.ui.toggle_line_numbers() end, desc             = "Toggle line numbers", },
    toggle_relative_line_nums = { mode = "n", lhs = "<leader>rn", rhs = function () fignvim.ui.toggle_relative_line_numbers() end, desc = "Toggle relative line numbers", },
  },
  Lists = {
    toggle_qf      = { mode = "n", lhs = "<C-q>", rhs     = function () fignvim.ui.toggle_fix_list(true) end, desc  = "Toggle quickfix window", },
    toggle_loclist = { mode = "n", lhs = "<leader>q", rhs = function () fignvim.ui.toggle_fix_list(false) end, desc = "Toggle location list window", },
  },
  Editing = {
    escape_insert           = { mode = "i", lhs          = "jk", rhs    = "<ESC>", desc               = "Escape insert mode" },
    indent_left             = { mode = "v", lhs          = "<", rhs     = "<gv", desc                 = "Indent selection left" },
    indent_right            = { mode = "v", lhs          = ">", rhs     = ">gv", desc                 = "Indent selection right" },
    move_selection_up       = { mode = { "n", "v" }, lhs = "<A-j>", rhs = ":m .+1<CR>==", desc        = "Move selected lines up" },
    move_selection_down     = { mode = { "n", "v" }, lhs = "<A-k>", rhs = ":m .-2<CR>==", desc        = "Move selected lines down" },
    move_selection_up_alt   = { mode = "x", lhs          = "J", rhs     = ":move '>+1<CR>gv-gv", desc = "Move current line up" },
    move_selection_down_alt = { mode = "x", lhs          = "K", rhs     = ":move '<-2<CR>gv-gv", desc = "Move current line down" },
    move_selection_up_x     = { mode = "x", lhs          = "<A-j>", rhs = ":move '>+1<CR>gv-gv", desc = "Move current line up" },
    move_selection_down_x   = { mode = "x", lhs          = "<A-K>", rhs = ":move '<-2<CR>gv-gv", desc = "Move current line down" },
    move_line_up            = { mode = "i", lhs          = "<A-j>", rhs = "<Esc>:m .+1<CR>==gi", desc = "Move current line up" },
    move_line_down          = { mode = "i", lhs          = "<A-K>", rhs = "<Esc>:m .-2<CR>==gi", desc = "Move current line down" },
  },
  Terminal = {
    terminal_escape = { mode = "t", lhs = "<esc>", rhs = [[<C-\><C-n>]], desc = "Enter normal mode in terminal" },
  }
}

--stylua: ignore
---@type table<string, table<string, FigNvimMapping>>
M.plugin_mappings = {
  ["nvim-spectre"] = {
    open_panel           = { mode      = "n", lhs   = "<leader>S",  rhs = ":lua require('spectre').open()<CR>",                          desc = "Open Spectre Panel"    },
    current_word         = { mode      = "n", lhs   = "<leader>sw", rhs = ":lua require('spectre').open_visual({select_word=true})<CR>", desc = "Search for current word under cursor"           },
    current_selection    = { mode      = "v", lhs   = "<leader>s",  rhs = ":lua require('spectre').open_visual()<CR>",                   desc = "Search for current selection" },
    text_in_current_file = { mode      = "n", lhs   = "<leader>sp", rhs = ":lua require('spectre').open_file_search()<CR>",              desc = "Search for text in current file"   },
    toggle_line          = { isVirtual = true, mode = "n", lhs          = "dd", rhs                                                           = "<cmd>lua require('spectre').toggle_line()<CR>", desc                   = "Spectre: Toggle current item", opts                   = {} },
    enter_file           = { isVirtual = true, mode = "n", lhs          = "<cr>", rhs                                                         = "<cmd>lua require('spectre.actions').select_entry()<CR>", desc          = "Spectre: Go to current file", opts                    = {} },
    send_to_qf           = { isVirtual = true, mode = "n", lhs          = "<C-q>", rhs                                                         = "<cmd>lua require('spectre.actions').send_to_qf()<CR>", desc            = "Spectre: Send all items to quickfix", opts            = {} },
    replace_cmd          = { isVirtual = true, mode = "n", lhs          = "<leader>c", rhs                                                    = "<cmd>lua require('spectre.actions').replace_cmd()<CR>", desc           = "Spectre: Input a vim replace command", opts           = {} },
    run_replace          = { isVirtual = true, mode = "n", lhs          = "<leader>R", rhs                                                    = "<cmd>lua require('spectre.actions').run_replace()<CR>", desc           = "Spectre: Replace all", opts                           = {} },
    show_option_menu     = { isVirtual = true, mode = "n", lhs          = "<leader>o", rhs                                                    = "<cmd>lua require('spectre').show_options()<CR>", desc                  = "Spectre: Show available options", opts                = {} },
    change_view_mode     = { isVirtual = true, mode = "n", lhs          = "<leader>v", rhs                                                    = "<cmd>lua require('spectre').change_view()<CR>", desc                   = "Spectre: Change result view mode", opts               = {} },
    toggle_live_update   = { isVirtual = true, mode = "n", lhs          = "tu", rhs                                                           = "<cmd>lua require('spectre').toggle_live_update()<CR>", desc            = "Spectre: Toggle updates when vim writes a file", opts = {} },
    toggle_ignore_case   = { isVirtual = true, mode = "n", lhs          = "ti", rhs                                                           = "<cmd>lua require('spectre').change_options('ignore-case')()<CR>", desc = "Spectre: Toggle ignore case", opts                    = {} },
    toggle_ignore_hidden = { isVirtual = true, mode = "n", lhs          = "th", rhs                                                           = "<cmd>lua require('spectre').change_options('hiddne')()<CR>", desc      = "Spectre: Toggle show hidden", opts                    = {} },
  },
  ["telescope.nvim"] = {
    git_files          = { mode = "n", lhs = "<C-p>",       rhs  = ":lua require('telescope.builtin').git_files()<CR>",                                            desc = "Search files in git repo"              },
    all_files          = { mode = "n", lhs = "<leader>sf",  rhs  = ":lua require('telescope.builtin').find_files({hidden = true})<CR>",                            desc = "Search files in current directory"     },
    buffers            = { mode = "n", lhs = "<leader>sb",  rhs  = ":lua require('telescope.builtin').buffers()<CR>",                                              desc = "Search buffers"                        },
    help_tags          = { mode = "n", lhs = "<leader>sh",  rhs  = ":lua require('telescope.builtin').help_tags()<CR>",                                            desc = "Search help tags"                      },
    dev_config         = { mode = "n", lhs = "<leader>sc",  rhs  = fignvim.search.dev_config_files,                                                                desc = "Search config files"                   },
    git_commits        = { mode = "n", lhs = "<leader>sgc", rhs  = ":lua require('telescope.builtin').git_commits()<CR>",                                          desc = "Search git commits"                    },
    git_branch_commits = { mode = "n", lhs = "<leader>sbc", rhs  = ":lua require('telescope.builtin').git_bcommits()<CR>",                                         desc = "Search git commits on current branch"  },
    git_branches       = { mode = "n", lhs = "<leader>sgb", rhs  = ":lua require('telescope.builtin').git_branches()<CR>",                                         desc = "Search git branches"                   },
    git_status         = { mode = "n", lhs = "<leader>sgs", rhs  = ":lua require('telescope.builtin').git_status()<CR>",                                           desc = "Search git status"                     },
    colourscheme       = { mode = "n", lhs = "<leader>st",  rhs  = ":lua require('telescope.builtin').colorscheme()<CR>",                                          desc = "Search colourschemes"                  },
    marks              = { mode = "n", lhs = "<leader>sm",  rhs  = ":lua require('telescope.builtin').marks()<CR>",                                                desc = "Search marks"                          },
    registers          = { mode = "n", lhs = "<leader>sr",  rhs  = ":lua require('telescope.builtin').registers()<CR>",                                            desc = "Search registers"                      },
    registers_insert   = { mode = "i", lhs = "<A-2>",       rhs  = ":lua require('telescope.builtin').registers()<CR>",                                           desc  = "Search registers while in insert mode" },
    command_history    = { mode = "n", lhs = "<leader>svc",  rhs = ":lua require('telescope.builtin').command_history()<CR>",                                      desc = "Search command history"                },
    aerial_symbols     = { mode = "n", lhs = "<leader>sa",  rhs  = ":Telescope aerial<CR>",                                      desc                                   = "Search through Aerial Symbols"         },
  },
  ["Comment.nvim"] = {
    opleader_line        = { isVirtual = true, mode = "o", lhs = "gc", rhs  = "", desc = "Operator pending prefix for line commenting in Normal and Visual modes", opts  = {} },
    opleader_block       = { isVirtual = true, mode = "o", lhs = "gb", rhs  = "", desc = "Operator pending prefix for block commenting in Normal and Visual modes", opts = {} },
    comment_line_toggle  = { isVirtual = true, mode = "n", lhs = "gcc", rhs = "", desc = "Toggle line comment", opts                                                     = {} },
    comment_block_toggle = { isVirtual = true, mode = "n", lhs = "gbc", rhs = "", desc = "Toggle line comment", opts                                                     = {} },
    comment_above        = { isVirtual = true, mode = "n", lhs = "gcO", rhs = "", desc = "Add a comment on the line above", opts                                         = {} },
    comment_below        = { isVirtual = true, mode = "n", lhs = "gco", rhs = "", desc = "Add a comment on the line above", opts                                         = {} },
    comment_eol          = { isVirtual = true, mode = "n", lhs = "gcA", rhs = "", desc = "Add a comment at the end of a line", opts                                      = {} }
  },
  ["vim-easy-align"] = {
    easy_align = { mode = {"n", "x"}, lhs = "ga", rhs = "<Plug>(EasyAlign)", desc = "Easy align in visual mode, or for a motion" }
  },
  ["neo-tree.nvim"] = {
    open_browser = { mode = "n", lhs = "<leader>e", rhs = ":Neotree toggle<CR>", desc = "Open Neotree" }
  },
  ["toggleterm.nvim"] = {
    toggle_lazygit    = { mode = "n", lhs        = "<leader>lg", rhs = function () fignvim.term.toggle_term_cmd("lazygit") end, desc = "ToggleTerm with lazygit" },
    toggle_node       = { mode = "n", lhs        = "<leader>tn", rhs = function () fignvim.term.toggle_term_cmd("node") end, desc    = "ToggleTerm with Node" },
    toggle_python     = { mode = "n", lhs        = "<leader>tp", rhs = function () fignvim.term.toggle_term_cmd("python") end, desc  = "ToggleTerm with Python" },
    toggle_float      = { mode = "n", lhs        = "<leader>tf", rhs = "<cmd>ToggleTerm direction=float<cr>", desc                   = "ToggleTerm in floating window" },
    toggle_horizontal = { mode = "n", lhs        = "<leader>th", rhs = "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc      = "ToggleTerm in horizontal split" },
    toggle_vertical   = { mode = "n", lhs        = "<leader>tv", rhs = "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc        = "ToggleTerm in vertical split" },
    toggleterm        = { mode = {"n", "t"}, lhs = "<F7>", rhs       = "<cmd>ToggleTerm<cr>", desc                                   = "ToggleTerm" },
    toggleterm_alt    = { mode = {"n", "t"}, lhs = "<C-'>", rhs      = "<cmd>ToggleTerm<cr>", desc                                   = "ToggleTerm" }
  },
  ["aerial.nvim"] = {
    toggle_aerial    = { mode = "n", lhs        = "<leader>a", rhs = "<cmd>AerialToggle!<CR>", desc = "Toggle LSP symbol outline panel" },
  },
  ["nvim-cmp"] = {
    cmp_prev_item     = { isVirtual = true, mode = "i", lhs          = "<C-k>", rhs     = "", desc = "Cmp: Select the previous completion item", opts = {} },
    cmp_next_item     = { isVirtual = true, mode = "i", lhs          = "<C-j>", rhs     = "", desc = "Cmp: Select the next completion item", opts     = {} },
    cmp_prev_item_alt = { isVirtual = true, mode = "i", lhs          = "<Up>", rhs      = "", desc = "Cmp: Select the previous completion item", opts = {} },
    cmp_next_item_alt = { isVirtual = true, mode = "i", lhs          = "<Down>", rhs    = "", desc = "Cmp: Select the next completion item", opts     = {} },
    cmp_scroll_up     = { isVirtual = true, mode = { "c", "i" }, lhs = "<C-b>", rhs     = "", desc = "Cmp: Scroll up on the completion docs", opts    = {} },
    cmp_scroll_down   = { isVirtual = true, mode = { "c", "i" }, lhs = "<C-f>", rhs     = "", desc = "Cmp: Scroll down on the completion docs", opts  = {} },
    cmp_complete      = { isVirtual = true, mode = { "c", "i" }, lhs = "<C-space>", rhs = "", desc = "Cmp: Show completion options", opts             = {} },
    cmp_abort         = { isVirtual = true, mode = { "c", "i" }, lhs = "<C-e>", rhs     = "", desc = "Cmp: Abort current completion", opts            = {} },
    cmp_disable       = { isVirtual = true, mode = "n", lhs          = "<C-y>", rhs     = "", desc = "Cmp: Toggle completion on and off", opts        = {} },
    cmp_confirm       = { isVirtual = true, mode = "n", lhs          = "<CR>", rhs      = "", desc = "Cmp: Confirm selection", opts                   = {} },
  },
  ["LuaSnip"] = {
    snippet_choice         = { mode = {"i", "s"}, lhs = "<C-l>", rhs             = function() fignvim.luasnip.change_choice() end, desc = "Toggle the next choice in the LuaSnip snippet", opts                           = {} },
    snippet_expand_or_next = { mode = {"i", "s"}, lhs = "<C-k>", rhs             = function() fignvim.luasnip.jump_next() end, desc     = "Expand the snippet under the cursor or jump to next snippet placeholder", opts = {} },
    snippet_prev           = { mode = {"i", "s"}, lhs = "<C-j>", rhs             = function() fignvim.luasnip.jump_prev() end, desc = "Jump to the previous snippet placeholder", opts                                = {} },
    edit_snippets          = { mode = "n", lhs        = "<leader><leader>s", rhs = ":LuaSnipEdit<CR>", desc                             = "Edit the snippet files for the filetype of the current buffer", opts           = {} }
  },
  ["copilot.vim"] = {
    -- Used in nvim-cmp mappings as fix for copilot key-mapping fallback mechanism issue - https://github.com/hrsh7th/nvim-cmp/blob/b16e5bcf1d8fd466c289eab2472d064bcd7bab5d/doc/cmp.txt#L830-L852
    accept_suggestion = { isVirtual = true, mode = "i", lhs = "<C-x>", rhs = "", desc = "Accept the current copilot suggestion", opts = { expr = true, silent = true, script = true} },
    dummy_accept = { mode = "i", lhs = "<Plug>(vimrc:copilot-dummy-map)", rhs = 'copilot#Accept("")', desc = "Copilot dummy accept to workaround fallback issues with nvim-cmp", opts = { expr = true, silent = true } }
  },
  ["diffview.nvim"] = {
    dv_select_next_entry = { isVirtual = true, mode = "n", lhs = "<tab>", rhs     = "", desc = "Diffview: Open diff for the next file in view and file panel", opts     = {} },
    dv_select_prev_entry = { isVirtual = true, mode = "n", lhs = "<s-tab>", rhs   = "", desc = "Diffview: Open diff for the previous file in view and file panel", opts = {} },
    dv_focus_files       = { isVirtual = true, mode = "n", lhs = "<leader>e", rhs = "", desc = "Diffview: Bring focus to files panel", opts                             = {} },
    dv_toggle_files      = { isVirtual = true, mode = "n", lhs = "<leader>b", rhs = "", desc = "Diffview: Toggle the files panel", opts                                 = {} },
  },
  ["gitsigns.nvim"] = {
    gs_next_hunk       = { mode = "n", lhs          = "]c", rhs         = function () fignvim.gitsigns.next_hunk() end, desc         = "Gitsigns: Next hunk", opts                                        = { noremap = true, silent = true, buffer = true, expr = true} },
    gs_prev_hunk       = { mode = "n", lhs          = "[c", rhs         = function () fignvim.gitsigns.prev_hunk() end, desc         = "Gitsigns: Previous hunk", opts                                    = { silent = true, buffer = true, expr = true} },
    gs_stage_hunk      = { mode = { "v", "n" }, lhs = "<leader>hs", rhs = ":Gitsigns stage_hunk<CR>", desc                             = "Gitsigns: Stage hunk", opts                                       = { silent = true, buffer = true} },
    gs_reset_hunk      = { mode = { "v", "n" }, lhs = "<leader>hr", rhs = ":Gitsigns reset_hunk<CR>", desc                             = "Gitsigns: Reset hunk", opts                                       = { silent = true, buffer = true} },
    gs_stage_buffer    = { mode = "n", lhs          = "<leader>hS", rhs = "<cmd>Gitsigns stage_buffer<CR>", desc                       = "Gitsigns: Stage buffer", opts                                     = { silent = true, buffer = true} },
    gs_undo_stage_hunk = { mode = "n", lhs          = "<leader>hu", rhs = "<cmd>Gitsigns undo_stage_hunk<CR>", desc                    = "Gitsigns: Undo the last hunk or buffer staging command", opts     = { silent = true, buffer = true} },
    gs_reset_buffer    = { mode = "n", lhs          = "<leader>hR", rhs = "<cmd>Gitsigns reset_buffer<CR>", desc                       = "Gitsigns: Reset the buffer", opts                                 = { silent = true, buffer = true} },
    gs_preview_hunk    = { mode = "n", lhs          = "<leader>hp", rhs = "<cmd>Gitsigns preview_hunk<CR>", desc                       = "Gitsigns: Preview the hunk in floating window", opts              = { silent = true, buffer = true} },
    gs_blame_line      = { mode = "n", lhs          = "<leader>hb", rhs = "<cmd>lua require'gitsigns'.blame_line{full=true}<CR>", desc = "Gitsigns: Show git blame of full change in floating window", opts = { silent = true, buffer = true} },
    gs_toggle_blame    = { mode = "n", lhs          = "<leader>gB", rhs = "<cmd>Gitsigns toggle_current_line_blame<CR>", desc          = "Gitsigns: Toggle virtual text line blame", opts                   = { silent = true, buffer = true} },
    gs_diffthis        = { mode = "n", lhs          = "<leader>hd", rhs = "<cmd>Gitsigns diffthis<CR>", desc                           = "Gitsigns: Diff the current file against index", opts              = { silent = true, buffer = true} },
    gs_diffthis_main   = { mode = "n", lhs          = "<leader>hD", rhs = "<cmd>Gitsigns diffthis('main')<CR>", desc                   = "Gitsigns: Diff the current file against main", opts               = { silent = true, buffer = true} },
    gs_toggle_deleted  = { mode = "n", lhs          = "<leader>gd", rhs = "<cmd>Gitsigns toggle_deleted<CR>", desc                     = "Gitsigns: Toggle deleted lines in buffer", opts                   = { silent = true, buffer = true} },
    gs_select_hunk     = { mode = { "o", "x" }, lhs = "ih", rhs         = ":<C-U>Gitsigns select_hunk<CR>", desc                       = "Gitsigns: Select the current hunk as a text object", opts         = { silent = true, buffer = true} },
  },
  ["vimtex"] = {
    tex_custom_launch = { mode = "n", lhs = "\\lg", rhs = ":Start latexmk-custom-launch.sh %:p<CR>", desc = "Run a custom script to launch latex with bibliography", opts = { silent = true, noremap = true }}
  },
  ["neotest"] = {
    neotest_toggle_summary = { mode = "n", lhs = "<leader>us", rhs = function () require("neotest").summary.toggle() end, desc            = "Neotest: Open test summary window" },
    neotest_run_file       = { mode = "n", lhs = "<leader>uf", rhs = function () require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest: Run tests in file" },
    neotest_run_nearest    = { mode = "n", lhs = "<leader>un", rhs = function () require("neotest").run.run() end, desc                   = "Neotest: Run nearest test" },
    neotest_debug_nearest  = { mode = "n", lhs = "<leader>ud", rhs = function () require("neotest").run.run({strategy                     = "dap"}) end, desc = "Neotest: Debug nearest test" }
  },
  ["cheatsheet.nvim"] = {
    cheatsheet_toggle = { mode = "n", lhs = "<leader>?", rhs = ":Cheatsheet<CR>", desc = "Toggles Cheatsheet help window in Telescope"}
  },
  ["vim-maximizer"] = {
    maximize = { mode = "n", lhs = "<leader>m", rhs = ":MaximizerToggle!<CR>", desc = "Toggle maximizer (current window)" }
  },
  ["nvim-dap"]= {
    dap_launch_lua               = { mode = "n", lhs = "<F5>", rhs  = ':lua require"osv".launch({port=8086})<CR>', desc                                               = "DAP Continue" },
    dap_continue               = { mode = "n", lhs = "<F9>", rhs  = ':lua require"dap".continue()<CR>', desc                                               = "DAP Continue" },
    dap_breakpoint             = { mode = "n", lhs = "<leader>db", rhs  = ':lua require"dap".toggle_breakpoint()<CR>', desc                                      = "DAP Toggle Breakpoint" },
    dap_conditional_breakpoint = { mode = "n", lhs = "<leader>dB", rhs  = ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', desc   = "DAP Toggle Conditional Breakpoint" },
    dap_exception_breakpoints  = { mode = "n", lhs = "<leader>de", rhs  = ':lua require"dap".set_exception_breakpoints()<CR>', desc                              = "DAP Set breakpoints on exceptions" },
    dap_clear_breakpoints      = { mode = "n", lhs = "<leader>dbc", rhs = ':lua require"dap".clear_breakpoints()<CR>', desc                                      = "DAP Clear all breakpoints on exceptions" },
    dap_step_out               = { mode = "n", lhs = "<leader>dk", rhs  = ':lua require"dap".step_out()<CR>', desc                                               = "DAP Step Out" },
    dap_step_into              = { mode = "n", lhs = "<leader>dj", rhs  = ':lua require"dap".step_into()<CR>', desc                                              = "DAP Step Into" },
    dap_step_over              = { mode = "n", lhs = "<leader>dl", rhs  = ':lua require"dap".step_over()<CR>', desc                                              = "DAP Step Over" },
    dap_up                     = { mode = "n", lhs = "<leader>dp", rhs  = ':lua require"dap".up()<CR>', desc                                                     = "DAP Go up in current stacktrace without stepping" },
    dap_down                   = { mode = "n", lhs = "<leader>dn", rhs  = ':lua require"dap".down()<CR>', desc                                                   = "DAP Go down in current stacktrace without stepping" },
    dap_close                  = { mode = "n", lhs = "<leader>dc", rhs  = ':lua require"dap".disconnect();require"dap".close();require"dapui".close()<CR>', desc = "DAP Disconnect and close nvim-dap and dap-ui. Doesn't kill the debugee" },
    dap_terminate              = { mode = "n", lhs = "<leader>dC", rhs  = ':lua require"dap".terminate();require"dap".close()<CR>', desc                         = "DAP Terminates the debug session, also killing the debugee" },
    dap_inspect                = { mode = "n", lhs = "<F12>", rhs  = ':lua require"dap.ui.widgets".hover()<CR>', desc                                       = "DAP Hover info for variables" },
    dap_scopes                 = { mode = "n", lhs = "<leader>d?", rhs  = ':lua local widgets                                                                    = require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>', desc = "DAP Show scopes in sidebar" },
    dap_repl                   = { mode = "n", lhs = "<leader>dr", rhs  = ':lua require"dap".repl.open({}, "vsplit")<CR><C-w>l', desc                            = "DAP Opens repl in vsplit" }
  },
  ["neogen"] = {
    neogen_file = { mode = "n", lhs = "<leader>/F", rhs = function() require('neogen').generate({type="file"}) end, desc = "Generates filetype specific annotations for the nearest file" },
    neogen_function = { mode = "n", lhs = "<leader>/f", rhs = function() require('neogen').generate({type="func"}) end, desc = "Generates filetype specific annotations for the nearest function" },
    neogen_class = { mode = "n", lhs = "<leader>/c", rhs = function() require('neogen').generate({type="class"}) end, desc = "Generates filetype specific annotations for the nearest class" },
    neogen_type = { mode = "n", lhs = "<leader>/t", rhs = function() require('neogen').generate({type="type"}) end, desc = "Generates filetype specific annotations for the nearest type" },
  },
  ["rnvimr"] = {
    rnvimr_tabedit    = { isVirtual = true, mode = "n", lhs = "<C-i>", rhs = "", desc = "Rnvimr: Open file in new tab"},
    rnvimr_split      = { isVirtual = true, mode = "n", lhs = "<C-x>", rhs = "", desc = "Rnvimr: Open file in horizontal split"},
    rnvimr_vsplit     = { isVirtual = true, mode = "n", lhs = "<C-v>", rhs = "", desc = "Rnvimr: Open file in vertical split"},
    rnvimr_change_cwd = { isVirtual = true, mode = "n", lhs = "gw", rhs    = "", desc = "Rnvimr: Make directory the current working directory in Nvim"},
    rnvimr_yank_dir   = { isVirtual = true, mode = "n", lhs = "yw", rhs    = "", desc = "Rnvimr: Yank the current directory path"},
    rnvimr_open = { mode = "n", lhs = "-", rhs = ":RnvimrToggle<CR>", desc = "Rnvimr: Toggle Rnvimr" },
  },
  ["undotree"] = {
    undotree_toggle = { mode = "n", lhs = "<A-u>", rhs = ":UndotreeToggle<CR>", desc = "Undotree: Toggle undotree" },
  },
  ["nvim-neoclip.lua"] = {
    neoclip_search = { mode = "n", lhs = "<leader>sy", rhs = function() require('telescope').extensions.neoclip.default() end, desc = "Neoclip: Search clipboard history" },
    neoclip_search_macros = { mode = "n", lhs = "<leader>sq", rhs = function() require("telescope").extensions.macroscope.default() end, desc = "Neoclip: Search clipboard history" },
  },
  ["vim-cutlass"] = {
    cutlass_cut_char = { mode = { "n", "x" }, lhs = "m", rhs = "d", desc = "Cutlass: Cut char to clipboard" },
    cutlass_cut_line = { mode = "n", lhs = "mm", rhs = "dd", desc = "Cutlass: Cut line to clipboard" },
    cutlass_cut_from_cursor = { mode = "n", lhs = "M", rhs = "D", desc = "Cutlass: Cut from cursor to end of line, to clipboard" },
    cutlass_remap_marks = { mode = "n", lhs = "\\m", rhs = "m", desc = "Cutlass: Remap create mark key so it isn't shadowed" }
  },
  ["session-lens"] = {
    session_lens = { mode = "n", lhs = "<leader>sl", rhs = function() require("session-lens").search_session() end, desc = "Session Lens: Search for sessions using telescope" },
  },
  ["leap.nvim"] = {
    leap_forward = { mode = "n", lhs = "<C-n>", rhs = "<plug>(leap-forward-to)", desc = "Leap: Forward to" },
    leap_backward = { mode = "n", lhs = "<C-m>", rhs = "<plug>(leap-backward-to)", desc = "Leap: Backward to" },
    leap_cross_window = { mode = "n", lhs = "gs", rhs = "<plug>(leap-cross-window)", desc = "Leap: Across all windows" },
  },
  ["vim-subversive"] = {
    sub_motion                 = { mode = "n", lhs          = "s", rhs         = "<plug>(SubversiveSubstitute)", desc            = "Subversive: Substitute the motion specified with whatever is in default yank register" },
    sub_line                   = { mode = "n", lhs          = "ss", rhs        = "<plug>(SubversiveSubstituteLine)", desc        = "Subversive: Substitute the line with whatever is in default yank register" },
    sub_to_end_of_line         = { mode = "n", lhs          = "S", rhs         = "<plug>(SubversiveSubstituteToEndOfLine)", desc = "Subversive: Substitute everything until the end of the line with whatever is in the yank register" },
    sub_motion_in_range_motion = { mode = { "n", "x" }, lhs = "<leader>s", rhs = "<plug>(SubversiveSubstituteRange)", desc       = "Subversive: Substitute all instances of the text in the first motion that exist in the text within the second motion" },
    sub_word_in_range_motion   = { mode = "n", lhs          = "<leader>ss", rhs        = "<plug>(SubversiveSubstituteWordRange)", desc   = "Subversive: Substitute all instances of word under the cursor within the motion specified" },
    subvert_motion_in_range_motion = { mode = { "n", "x" }, lhs = "<leader><leader>v", rhs = "<plug>(SubversiveSubvertRange)", desc       = "Subversive: Subvert all instances of the text in the first motion that exist in the text within the second motion" },
    subvert_word_in_range_motion   = { mode = "n", lhs          = "<leader><leader>vv", rhs        = "<plug>(SubversiveSubvertWordRange)", desc   = "Subversive: Subvert all instances of word under the cursor within the motion specified" },
  }
}

-- stylua: ignore
---@type table<string, table<string, FigNvimMapping>>
M.lsp_mappings = {
  LSP = {
    prev_diagnostic               = { mode = "n", lhs          = "[g", rhs          = function() vim.diagnostic.goto_prev() end, desc                            = "Go to previous diagnostic" },
    next_diagnostic               = { mode = "n", lhs          = "]g", rhs          = function() vim.diagnostic.goto_next() end, desc                            = "Go to next diagnostic" },
    hover_diagnostic              = { mode = "n", lhs          = "<leader>ld", rhs  = function() vim.diagnostic.open_float() end, desc                           = "Hover diagnostics" },
    code_action                   = { mode = "n", lhs          = "<leader>ca", rhs  = function() vim.lsp.buf.code_action() end, desc                             = "Opens the default Code Action Window" },
    code_action_saga              = { mode = "n", lhs          = "<leader>ca", rhs  = ":Lspsaga code_action<CR>", desc                                           = "Opens LSP Saga Code Action Window" },
    goto_declaration              = { mode = "n", lhs          = "gD", rhs          = function() vim.lsp.buf.declaration() end, desc                             = "Go to declaration of current symbol" },
    goto_definition               = { mode = "n", lhs          = "gd", rhs          = function() vim.lsp.buf.definition() end, desc                              = "Go to definition of current symbol" },
    goto_implementation           = { mode = "n", lhs          = "gI", rhs          = function() vim.lsp.buf.implementation() end, desc                          = "Go to implementation of current symbol" },
    goto_implementation_telescope = { mode = "n", lhs          = "gI", rhs          = function() require('telescope.builtin').lsp_implementations() end, desc    = "Go to implementation of current symbol using Telescope" },
    goto_references               = { mode = "n", lhs          = "gr", rhs          = function() vim.lsp.buf.references() end, desc                              = "Go to references of current symbol" },
    goto_references_telescope     = { mode = "n", lhs          = "gr", rhs          = function () require('telescope.builtin').lsp_references() end, desc        = "Go to references of current symbol using Telescope" },
    document_symbols_telescope    = { mode = "n", lhs          = "gm", rhs          = function() require('telescope.builtin').lsp_document_symbols() end, desc   = "List document symbols in Telescope" },
    hover_doc                     = { mode = "n", lhs          = "K", rhs           = function() vim.lsp.buf.hover() end, desc                                   = "Hover documentation" },
    hover_doc_saga                = { mode = "n", lhs          = "K", rhs           = ":Lspsaga hover_doc<CR>", desc                                             = "Hover documentation using LSP Saga" },
    rename_symbol                 = { mode = "n", lhs          = "rn", rhs          = function() vim.lsp.buf.rename() end, desc                                  = "Rename current symbol" },
    signature_help                = { mode = { "i", "n" }, lhs = "<A-s>", rhs       = function() vim.lsp.buf.signature_help() end, desc                          = "Show signature help" },
    format_code                   = { mode = {"n", "v"}, lhs   = "<leader>f", rhs   = fignvim.lsp.formatting.format, desc                                        = "Format code in file, or the selected portion of code"},
    toggle_autoformat             = { mode = "n", lhs          = "<leader>taf", rhs  = fignvim.ui.toggle_autoformat, desc                                         = "Toggle autoformatting on save" },
    saga_scroll_up                = { mode = "n", lhs          = "<C-f>", rhs       = function () require('lspsaga.action').smart_scroll_with_saga(1) end, desc  = "Scroll up in an LSP Saga popup window"},
    saga_scroll_down              = { mode = "n", lhs          = "<C-b>", rhs       = function () require('lspsaga.action').smart_scroll_with_saga(-1) end, desc = "Scroll down in an LSP Saga popup window"},
    tsserver_organize             = { mode = "n", lhs          = "<leader>to", rhs  = ":TSLspOrganize<CR>", desc                                                 = "Organize imports using tsserver" },
    tsserver_rename_file          = { mode = "n", lhs          = "<leader>trn", rhs = ":TSLspRenameFile<CR>", desc                                               = "Rename file using tsserver" },
    tsserver_import_all           = { mode = "n", lhs          = "<leader>ti", rhs  = ":TSLspImportAll<CR>", desc                                                = "Import all missing imports using tsserver" },
  },
}

return M
