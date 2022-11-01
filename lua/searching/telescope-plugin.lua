local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local opts = { noremap = true, silent = true }
local maps = require("custom_config").mappings
local mapper = require("utils.mapper")

telescope.load_extension("fzy_native")
telescope.load_extension("mapper")

local actions = require("telescope.actions")

-- Custom function to search vim config files
function _G.search_dev_config()
  require("telescope.builtin").find_files({
    prompt_title = "< Config Files >",
    search_dirs = { "$DOTFILES/nvim/.config/nvim" },
    hidden = true,
  })
end

-- Telescope mappings
mapper.map(
  "n",
  "<Leader>ss",
  ":lua require('telescope.builtin').grep_string({ search = vim.fn.input(\"Grep For > \")})<CR>",
  opts,
  "Search",
  "search_string",
  "Search (grep) for string"
)
mapper.map(
  "n",
  maps.search.git_files,
  ":lua require('telescope.builtin').git_files()<CR>",
  opts,
  "Search",
  "search_git_files",
  "Search for files registered in git"
)
mapper.map(
  "n",
  maps.search.all_files,
  ":lua require('telescope.builtin').find_files({hidden = true})<CR>",
  opts,
  "Search",
  "search_all_files",
  "Search in all files"
)

mapper.map(
  "n",
  maps.search.buffers,
  ":lua require('telescope.builtin').buffers()<CR>",
  opts,
  "Search",
  "search_buffers",
  "Search for buffers"
)
mapper.map(
  "n",
  maps.search.help_tags,
  ":lua require('telescope.builtin').help_tags()<CR>",
  opts,
  "Search",
  "search_help_tags",
  "Search for help tags"
)
mapper.map(
  "n",
  maps.search.nvim_config,
  ":lua search_dev_config()<CR>",
  opts,
  "Search",
  "search_dev_config",
  "Search for neovim config files"
)
mapper.map(
  "n",
  maps.search.git_commits,
  ":lua require('telescope.builtin').git_commits()<CR>",
  opts,
  "Search",
  "search_git_commits",
  "Search for git commits"
)
mapper.map(
  "n",
  maps.search.git_branch_commits,
  ":lua require('telescope.builtin').git_bcommits()<CR>",
  opts,
  "Search",
  "search_git_branch_commits",
  "Search for git branch commits"
)
mapper.map(
  "n",
  maps.search.git_branches,
  ":lua require('telescope.builtin').git_branches()<CR>",
  opts,
  "Search",
  "search_git_branches",
  "Search for git branches"
)
mapper.map(
  "n",
  maps.search.git_status,
  ":lua require('telescope.builtin').git_status()<CR>",
  opts,
  "Search",
  "search_git_status",
  "Search for git status"
)
mapper.map(
  "n",
  maps.search.colourscheme,
  ":lua require('telescope.builtin').colorscheme()<CR>",
  opts,
  "Search",
  "search_colourscheme",
  "Search for colourschemes"
)
mapper.map(
  "n",
  maps.search.marks,
  ":lua require('telescope.builtin').marks()<CR>",
  opts,
  "Search",
  "search_marks",
  "Search for marks"
)
mapper.map(
  "n",
  maps.search.registers,
  ":lua require('telescope.builtin').registers()<CR>",
  opts,
  "Search",
  "search_registers",
  "Search for registers"
)
mapper.map(
  "n",
  maps.search.vim_command_history,
  ":lua require('telescope.builtin').command_history()<CR>",
  opts,
  "Search",
  "search_vim_command_history",
  "Search for vim command history"
)
mapper.map(
  "i",
  maps.search.registers_insert,
  ":lua require('telescope.builtin').registers()<CR>",
  opts,
  "Search",
  "search_registers_insert",
  "Search for registers when in insert mode"
)

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--glob=!accounts/",
    },
    prompt_prefix = " ",
    selection_caret = " ",
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    file_ignore_patterns = { "node_modules" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    path_display = { "smart" },
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-space>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    grep_string = {
      vimgrep_arguments = {
        "rg",
        "--hidden",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
    },
    live_grep = {
      vimgrep_arguments = {
        "rg",
        "--hidden",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
    },
  },
  extensions = {
    aerial = {
      show_nestig = {},
    },
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})
