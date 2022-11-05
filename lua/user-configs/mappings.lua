local M = {}

---@class FigNvimMapping
---@field group string Group name for the Mapping (for nvim-mapper)
---@field desc string Description of the Mapping
---@field mode string | table Mode or Modes for the Mapping
---@field lhs string Trigger keys for the Mapping
---@field rhs string | function Command to run for the Mapping
---@field isVirtual? boolean Whether the keymap should only be virtual (i.e. Displayed in nvim-mapper) rather than being created - default = false
---@field opts? table Options for the Mapping (default = { silent = true })

-- stylua: ignore
---@type table<string, table<string, FigNvimMapping>>
M.general_mappings = {
  -- Navigate between windows in normal mode
  Window = {
    window_left = { mode = "n", lhs = "<C-h>", rhs = "<C-w>h", desc = "Move to next window to the left", },
    window_right = { mode = "n", lhs = "<C-l>", rhs = "<C-w>l", desc = "Move to next window to the right" },
    window_down = { mode = "n", lhs = "<C-j>", rhs = "<C-w>j", desc = "Move to next window down" },
    window_up = { mode = "n", lhs = "<C-k>", rhs = "<C-w>k", desc = "Move to next window up" },
    window_resize_up = { mode = "n", lhs = "<C-Up>", rhs = ":resize +2<CR>", desc = "Resize window horizontally up", },
    window_resize_down = { mode = "n", lhs = "<C-Down>", rhs = ":resize -2<CR>", desc = "Resize window horizontally down", },
    window_resize_left = { mode = "n", lhs = "<C-Left>", rhs = ":vertical resize +2<CR>", desc = "Resize window vertically to the left", },
    window_resize_right = { mode = "n", lhs = "<C-Right>", rhs = ":vertical resize -2<CR>", desc = "Resize window vertically to the right", },
  },
  Navigation = {
    buf_next = { mode = "n", lhs = "<S-l>", rhs = ":bnext<CR>", desc = "Move to next buffer", },
    buf_prev = { mode = "n", lhs = "<S-h>", rhs = ":bprevious<CR>", desc = "Move to previous buffer", },
    buf_close = { mode = "n", lhs = "<C-x>", rhs = ":bdelete<CR>", desc = "Close current buffer", },
    toggle_line_nums = { mode = "n", lhs = "<leader>l", rhs = ":lua require('core.api.ui).toggle_line_numbers", desc = "Toggle line numbers", },
    toggle_relative_line_nums = { mode = "n", lhs = "<leader>rn", rhs = ":lua require('core.api.ui').toggle_relative_line_numbers()", desc = "Toggle relative line numbers", },
  },
  Lists = {
    toggle_qf = { mode = "n", lhs = "<C-q>", rhs = ":lua require('core.api.ui').toggle_fix_list(true)", desc = "Toggle quickfix window", },
    toggle_loclist = { mode = "n", lhs = "<leader>q", rhs = ":lua require('core.api.ui').toggle_fix_list(false)", desc = "Toggle location list window", },
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
    delete_char             = { mode = "n", lhs          = "x", rhs     = '"_x', desc                 = "Delete character override, preventing it from occupying yank register" },
  },
  Terminal = {
    terminal_escape = { mode = "t", lhs = "<esc>", rhs = [[<C-\\><C-n>]], desc = "Enter normal mode in terminal" },
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
    send_to_qf           = { isVirtual = true, mode = "n", lhs          = "<cr>", rhs                                                         = "<cmd>lua require('spectre.actions').send_to_qf()<CR>", desc            = "Spectre: Send all items to quickfix", opts            = {} },
    replace_cmd          = { isVirtual = true, mode = "n", lhs          = "<leader>c", rhs                                                    = "<cmd>lua require('spectre.actions').replace_cmd()<CR>", desc           = "Spectre: Input a vim replace command", opts           = {} },
    run_replace          = { isVirtual = true, mode = "n", lhs          = "<leader>R", rhs                                                    = "<cmd>lua require('spectre.actions').run_replace()<CR>", desc           = "Spectre: Replace all", opts                           = {} },
    show_option_menu     = { isVirtual = true, mode = "n", lhs          = "<leader>o", rhs                                                    = "<cmd>lua require('spectre').show_options()<CR>", desc                  = "Spectre: Show available options", opts                = {} },
    change_view_mode     = { isVirtual = true, mode = "n", lhs          = "<leader>v", rhs                                                    = "<cmd>lua require('spectre').change_view()<CR>", desc                   = "Spectre: Change result view mode", opts               = {} },
    toggle_live_update   = { isVirtual = true, mode = "n", lhs          = "tu", rhs                                                           = "<cmd>lua require('spectre').toggle_live_update()<CR>", desc            = "Spectre: Toggle updates when vim writes a file", opts = {} },
    toggle_ignore_case   = { isVirtual = true, mode = "n", lhs          = "ti", rhs                                                           = "<cmd>lua require('spectre').change_options('ignore-case')()<CR>", desc = "Spectre: Toggle ignore case", opts                    = {} },
    toggle_ignore_hidden = { isVirtual = true, mode = "n", lhs          = "th", rhs                                                           = "<cmd>lua require('spectre').change_options('hiddne')()<CR>", desc      = "Spectre: Toggle show hidden", opts                    = {} },
  },
  ["telescope.nvim"] = {
    grep_string        = { mode = "n", lhs = "<leader>ss",  rhs  = ":lua require('telescope.builtin').grep_string({ search = vim.fn.input(\"Grep For > \")})<CR>", desc = "Grep for strings in all files"      },
    git_files          = { mode = "n", lhs = "<C-p>",       rhs  = ":lua require('telescope.builtin').git_files()<CR>",                                            desc = "Search files in git repo"             },
    all_files          = { mode = "n", lhs = "<leader>sf",  rhs  = ":lua require('telescope.builtin').find_files({hidden = true})<CR>",                            desc = "Search files in current directory"    },
    buffers            = { mode = "n", lhs = "<leader>sb",  rhs  = ":lua require('telescope.builtin').buffers()<CR>",                                              desc = "Search buffers"                       },
    help_tags          = { mode = "n", lhs = "<leader>sh",  rhs  = ":lua require('telescope.builtin').help_tags()<CR>",                                            desc = "Search help tags"                     },
    dev_config         = { mode = "n", lhs = "<leader>sc",  rhs  = fignvim.search.dev_config_files,                                                                desc = "Search config files"                  },
    git_commits        = { mode = "n", lhs = "<leader>sgc", rhs  = ":lua require('telescope.builtin').git_commits()<CR>",                                          desc = "Search git commits"                   },
    git_branch_commits = { mode = "n", lhs = "<leader>sbc", rhs  = ":lua require('telescope.builtin').git_bcommits()<CR>",                                         desc = "Search git commits on current branch" },
    git_branches       = { mode = "n", lhs = "<leader>sgb", rhs  = ":lua require('telescope.builtin').git_branches()<CR>",                                         desc = "Search git branches"                  },
    git_status         = { mode = "n", lhs = "<leader>sgs", rhs  = ":lua require('telescope.builtin').git_status()<CR>",                                           desc = "Search git status"                    },
    colourscheme       = { mode = "n", lhs = "<leader>st",  rhs  = ":lua require('telescope.builtin').colorscheme()<CR>",                                          desc = "Search colourschemes"                 },
    marks              = { mode = "n", lhs = "<leader>sm",  rhs  = ":lua require('telescope.builtin').marks()<CR>",                                                desc = "Search marks"                         },
    registers          = { mode = "n", lhs = "<leader>sr",  rhs  = ":lua require('telescope.builtin').registers()<CR>",                                            desc = "Search registers"                     },
    registers_insert   = { mode = "i", lhs = "<A-2>",       rhs  = ":lua require('telescope.builtin').registers()<CR>",                                           desc  = "Search registers while in insert mode"                     },
    command_history    = { mode = "n", lhs = "<leader>svc",  rhs = ":lua require('telescope.builtin').command_history()<CR>",                                      desc = "Search command history"               },
    aerial_symbols     = { mode = "n", lhs = "<leader>sa",  rhs  = ":Telescope aerial<CR>",                                      desc                                   = "Search through Aerial Symbols"               },
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
    cmp_scroll_up     = { isVirtual = true, mode ={ "c", "i" }, lhs          = "<C-b>", rhs     = "", desc = "Cmp: Scroll up on the completion docs", opts    = {} },
    cmp_scroll_down   = { isVirtual = true, mode ={ "c", "i" }, lhs          = "<C-f>", rhs     = "", desc = "Cmp: Scroll down on the completion docs", opts  = {} },
    cmp_complete      = { isVirtual = true, mode = { "c", "i" }, lhs = "<C-space>", rhs = "", desc = "Cmp: Show completion options", opts             = {} },
    cmp_abort         = { isVirtual = true, mode = { "c", "i" }, lhs = "<C-e>", rhs     = "", desc = "Cmp: Abort current completion", opts            = {} },
    cmp_disable         = { isVirtual = true, mode = "n", lhs = "<C-y>", rhs     = "", desc = "Cmp: Toggle completion on and off", opts            = {} },
    cmp_confirm         = { isVirtual = true, mode = "n", lhs = "<CR>", rhs     = "", desc = "Cmp: Confirm selection", opts            = {} },
  },
  ["LuaSnip"] = {
    snippet_choice         = { mode = {"i", "s"}, lhs = "<C-l>", rhs             = function() fignvim.luasnip.change_choice() end, desc = "Toggle the next choice in the LuaSnip snippet", opts                           = {} },
    snippet_expand_or_next = { mode = {"i", "s"}, lhs = "<C-k>", rhs             = function() fignvim.luasnip.jump_next() end, desc     = "Expand the snippet under the cursor or jump to next snippet placeholder", opts = {} },
    snippet_prev           = { mode = {"i", "s"}, lhs = "<C-j>", rhs             = function() fignvim.luasnip.jump_prev() end, desc = "Jump to the previous snippet placeholder", opts                                = {} },
    edit_snippets          = { mode = "n", lhs        = "<leader><leader>s", rhs = ":LuaSnipEdit<CR>", desc                             = "Edit the snippet files for the filetype of the current buffer", opts           = {} }
  },
  ["copilot.vim"] = {
    accept_suggestion = { mode = "i", lhs = "<C-x>", rhs = "copilot#Accept('<CR>')", desc = "Accept the current copilot suggestion", opts = { expr = true, silent = true, script = true} }
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
