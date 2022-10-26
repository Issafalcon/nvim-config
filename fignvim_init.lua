local mappings = fignvim.config.get_config("mappings")

for group, group_mappings in pairs(mappings.general_mappings) do
  fignvim.config.create_mapping_group(group_mappings, group)
end
