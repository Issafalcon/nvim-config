return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        injected_languages = false,
        highlight = { "Function", "Label" },
        priority = 500,
      },
    },
  },
}
