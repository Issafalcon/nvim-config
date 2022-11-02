-- stylua: ignore start
local spectre = fignvim.plug.load_module_file("spectre")
if not spectre then
  return
end

local mappings = fignvim.config.get_plugin_mappings("nvim-spectre", true)
local spectre_mapping_opts = {}

for key, mapping in pairs(mappings) do
  if mapping.isVirtual then
    spectre_mapping_opts[key] = {
      map = mapping.lhs,
      cmd = mapping.rhs,
      desc = mapping.desc
    }
  end
end

spectre.setup({
  color_devicons = true,
  open_cmd = 'vnew',
  live_update = true, -- auto excute search again when you write any file in vim
  line_sep_start = '┌-----------------------------------------',
  result_padding = '¦  ',
  line_sep       = '└-----------------------------------------',
  mapping= spectre_mapping_opts
})
