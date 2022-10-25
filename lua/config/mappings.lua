local M = {}

---@class FigNvimMapping
---@field id string Unique identifier for the Mapping (for nvim-mapper)
---@field group string Group name for the Mapping (for nvim-mapper)
---@field desc string Description of the Mapping
---@field mode string | table Mode or Modes for the Mapping
---@field lhs string Trigger keys for the Mapping
---@field rhs string | function Command to run for the Mapping
---@field isVirtual? boolean Whether the keymap should only be virtual (i.e. Displayed in nvim-mapper) rather than being created - default = false
---@field opts? table Options for the Mapping (default = { silent = true })

---@type table<string, table<string, FigNvimMapping>>
M.mappings = {
  -- Navigate between windows in normal mode
  Window = {
    window_left         = { mode = "n", lhs = "<C-h>", rhs     = "<C-w>h", desc                  = "Move to next window to the left" },
    window_right        = { mode = "n", lhs = "<C-l>", rhs     = "<C-w>l", desc                  = "Move to next window to the right" },
    window_down         = { mode = "n", lhs = "<C-j>", rhs     = "<C-w>j", desc                  = "Move to next window down" },
    window_up           = { mode = "n", lhs = "<C-k>", rhs     = "<C-w>k", desc                  = "Move to next window up" },
    window_resize_up    = { mode = "n", lhs = "<C-Up>", rhs    = ":resize +2<CR>", desc          = "Resize window horizontally up" },
    window_resize_down  = { mode = "n", lhs = "<C-Down>", rhs  = ":resize -2<CR>", desc          = "Resize window horizontally down" },
    window_resize_left  = { mode = "n", lhs = "<C-Left>", rhs  = ":vertical resize +2<CR>", desc = "Resize window vertically to the left" },
    window_resize_right = { mode = "n", lhs = "<C-Right>", rhs = ":vertical resize -2<CR>", desc = "Resize window vertically to the right" },
  },
  Navigation = {
    buf_next                  = { mode = "n", lhs = "<S-l>", rhs      = ":bnext<CR>", desc                                                 = "Move to next buffer" },
    buf_prev                  = { mode = "n", lhs = "<S-h>", rhs    = ":bprevious<CR>", desc                                             = "Move to previous buffer" },
    buf_close                 = { mode = "n", lhs = "<C-x>", rhs      = ":bdelete<CR>", desc                                               = "Close current buffer" },
    toggle_line_nums          = { mode = "n", lhs = "<leader>l", rhs  = ":lua require('core.api.ui).toggle_line_numbers", desc             = "Toggle line numbers" },
    toggle_relative_line_nums = { mode = "n", lhs = "<leader>rn", rhs = ":lua require('core.api.ui').toggle_relative_line_numbers()", desc = "Toggle relative line numbers" },
  },
  Lists = {
    toggle_qf = { mode = "n", lhs = "<C-q>", rhs = ":lua require('core.api.ui').toggle_fix_list(true)", desc = "Toggle quickfix window" },
    toggle_loclist = { mode = "n", lhs = "<leader>q", rhs = ":lua require('core.api.ui').toggle_fix_list(false)", desc = "Toggle location list window" },
  },
  Editing = {
    escape_insert = { mode = "i", lhs = "jk", rhs = "<ESC>", desc = "Escape insert mode" },
    indent_left = { mode = "v", lhs = "<", rhs = "<gv", desc = "Indent selection left" },
    indent_right = { mode = "v", lhs = ">", rhs = ">gv", desc = "Indent selection right" },
    move_text_up = { mode = "v", lhs = "<A-j>", rhs = ":m .+1<CR>==", desc = "Move selected lines up" },
    move_text_down = { mode = "v", lhs = "<A-k>", rhs = ":m .-2<CR>==", desc = "Move selected lines down" },
    move_text_up_alt = { mode = "x", lhs = "J", rhs = ":move '>+1<CR>gv-gv", desc = "Move current line up" },
    move_text_down_alt = { mode = "x", lhs = "K", rhs = ":move '<-2<CR>gv-gv", desc = "Move current line down" },
  },
  -- Searching with telescope and nvim-spectre
  search = {
    open_panel = "<leader>S",
    string = "<leader>ss",
    current_word = "<leader>sw",
    current_selection = "<leader>s",
    text_in_current_file = "<leader>sp",
    git_files = "<C-p>",
    git_commits = "<leader>sgc",
    git_branch_commits = "<leader>sgf",
    git_branches = "<leader>sgb",
    git_status = "<leader>sgs",
    all_files = "<leader>sf",
    buffers = "<leader>sb",
    help_tags = "<leader>sh",
    nvim_config = "<leader>sc",
    colourscheme = "<leader>st",
    marks = "<leader>sm",
    registers = "<leader>sr",
    registers_insert = "<A-2>",
    sessions = "<leader>sl",
    vim_command_history = "<leader>svc",
  },
  lsp = {},
  notes = {
    display_equation = "<leader>pe",
  },
  completion = {
    snippet_expand_or_next = "<c-k>",
    snippet_previous = "<c-j>",
    snippet_choice = "<c-l>",
    edit_snippet = "<leader><leader>s",
  },
  diffview = {
    select_next_entry = "<tab>",
    select_prev_entry = "<s-tab>",
    focus_files = "<leader>e",
    toggle_files = "<leader>b",
    file_panel = {
      next_entry = "j",
      next_entry_alt = "<down>",
      prev_entry = "k",
      prev_entry_alt = "<up>",
      select_entry = "<cr>",
      select_entry_alt = "<2-LeftMouse>",
      select_entry_alt2 = "o",
      toggle_stage_entry = "-",
      stage_all = "S",
      unstage_all = "U",
      restore_entry = "X",
      refresh_files = "R",
    },
  },
  commenting = {
    line_comment = "gc",
    block_comment = "gb",
    generate_annotation = "<leader>/",
  },
}

---@type table<string, table<string, FigNvimMapping>>
M.lsp_mappings = {
  LSP = {

  }
}

return M
