local aerial_keys = {
  { "n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle LSP symbol outline panel" } },
}

return {
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialOpen", "AerialToggle" },
    keys = fignvim.mappings.make_lazy_keymaps(aerial_keys, true),
    opts = {
      attach_mode = "window",
      backends = { "lsp", "treesitter", "markdown" },
      close_automatic_events = {},
      highlight_on_hover = true,
      layout = {
        min_width = 28,
      },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
    config = function(_, opts)
      local _, aerial = pcall(require, "aerial")
      local telescope_ok, telescope = pcall(require, "telescope")
      aerial.setup(opts)
      fignvim.fn.conditional_func(telescope.load_extension, telescope_ok, "aerial")
    end,
  },
}
