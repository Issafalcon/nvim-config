local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

local telescope = require("telescope")

telescope.load_extension("fzy_native")

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
keymap(
  "n",
  "<Leader>ss",
  ":lua require('telescope.builtin').grep_string({ search = vim.fn.input(\"Grep For > \")})<CR>",
  opts
)
keymap("n", "<leader>sl", ":lua require('searching.telescope-helpers').CustomLiveGrep()<CR>", opts)
keymap("n", "<C-p>", ":lua require('telescope.builtin').git_files()<CR>", opts)
keymap("n", "<Leader>sf", ":lua require('telescope.builtin').find_files({hidden = true})<CR>", opts)

-- Function replaced with nvim-spectre
-- keymap("n", "<Leader>sw", ':lua require(\'telescope.builtin\').grep_string { search = vim.fn.expand("<cword>") }<CR>', opts)
keymap("n", "<Leader>sb", ":lua require('telescope.builtin').buffers()<CR>", opts)
keymap("n", "<Leader>sh", ":lua require('telescope.builtin').help_tags()<CR>", opts)
keymap("n", "<Leader>sc", ":lua search_dev_config()<CR>", opts)
keymap("n", "<Leader>sgc", ":lua require('telescope.builtin').git_commits()<CR>", opts)
keymap("n", "<Leader>sgf", ":lua require('telescope.builtin').git_bcommits()<CR>", opts)
keymap("n", "<Leader>sgb", ":lua require('telescope.builtin').git_branches()<CR>", opts)
keymap("n", "<Leader>sgs", ":lua require('telescope.builtin').git_status()<CR>", opts)
keymap("n", "<Leader>st", ":lua require('telescope.builtin').colorscheme()<CR>", opts)
keymap("n", "<Leader>sm", ":lua require('telescope.builtin').marks()<CR>", opts)
keymap("n", "<Leader>sr", ":lua require('telescope.builtin').registers()<CR>", opts)
keymap("n", "<A-2>", ":lua require('telescope.builtin').registers()<CR>", opts)
keymap("n", "<Leader>svc", ":lua require('telescope.builtin').command_history()<CR>", opts)
keymap("i", "<A-2>", ":lua require('telescope.builtin').registers()<CR>", opts)

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
    layout_config = {
      vertical = {
        height = {
          padding = 2,
        },
      },
    },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

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
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})
