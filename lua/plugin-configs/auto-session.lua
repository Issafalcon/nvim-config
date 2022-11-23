local auto_session = fignvim.plug.load_module_file("auto-session")
if not auto_session then
  return
end

auto_session.setup({
  auto_save_enabled = false,
  auto_session_use_git_branch = false,
  cwd_change_handling = false,
})
