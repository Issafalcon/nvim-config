return {
  {
    "cdelledonne/vim-cmake",
    event = "BufReadPost",
    init = function()
      local opt = {
        g = {
          cmake_root_markers = { "CMakeLists.txt" },
        },
      }

      fignvim.config.set_vim_opts(opt)
    end,
  },
}
