local neogen_config = require("documentation.plugin-config.neogen")

return {
  {
    "danymat/neogen",
    keys = fignvim.mappings.make_lazy_keymaps(require("keymaps").Annotations, true),
    opts = neogen_config.lazy_opts,
  },
}
