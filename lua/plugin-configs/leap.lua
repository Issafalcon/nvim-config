local leap = fignvim.plug.load_module_file("leap")

if not leap then
  return
end

leap.add_default_mappings()
