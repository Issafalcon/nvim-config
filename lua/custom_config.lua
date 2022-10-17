local M = {}

M.mappings = {
  -- Navigate between windows in normal mode
  change_window = {
    up = "<C-k>",
    down = "<C-j>",
    left = "<C-h>",
    right = "<C-l>",
  },
  -- Resize window in normal mode
  resize_window = {
    up = "<C-Up>",
    down = "<C-Down>",
    left = "<C-Left>",
    right = "<C-Right>",
  },
  -- Toggle quickfix and loclist in normal mode
  toggle_lists = {
    quickfix = "<C-q>",
    loclist = "<leader>q",
  },
  navigation = {
    buf_next = "<S-l>",
    buf_prev = "<S-h>",
    buf_close = "<C-x>",
    toggle_line_nums = "<leader>n",
    toggle_relative_line_nums = "<leader>rn",
  },
  editing = {
    escape_insert = "jk",
    indent_left = "<",
    indent_right = ">",
    move_text_up = "<A-j>",
    move_text_down = "<A-k>",
    move_text_up_alt = "J",
    move_text_down_alt = "K",
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
    line_comment = 'gc',
    block_comment = 'gb'
  }
}

return M
