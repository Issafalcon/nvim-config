fignvim.search = {}

--- Search for a file in Neovim Config files
function fignvim.search.dev_config_files()
  local telescope_builtin = require("telescope.builtin")
  if telescope_builtin then
    telescope_builtin.find_files({
      prompt_title = "< Config Files >",
      search_dirs = { "$DOTFILES/nvim/.config/nvim" },
      hidden = true,
    })
  end
end

return fignvim.search
