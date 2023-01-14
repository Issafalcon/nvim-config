local vim_tf_spec = {
  "hashivim/vim-terraform",
  event = "VeryLazy",
  dependencies = {
    "juliosueiras/vim-terraform-completion",
  },
}

return {
  vim_tf_spec,
}
