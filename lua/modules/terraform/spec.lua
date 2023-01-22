local vim_tf_spec = {
  "hashivim/vim-terraform",
  event = "VeryLazy",
  dependencies = {
    "juliosueiras/vim-terraform-completion",
  },
}

return fignvim.module.enable_registered_plugins({
  ["vim-terraform"] = vim_tf_spec,
}, "terraform")
