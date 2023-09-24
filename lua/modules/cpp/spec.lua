local vim_cmake_spec = {
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
}

return fignvim.module.enable_registered_plugins({
  ["vim-cmake"] = vim_cmake_spec,
}, "cpp")
