fignvim.plug = {}

function fignvim.plug.initialize_rocks_nvim()
  -- If rocks.nvim is not installed then install it!
  if not pcall(require, "rocks") then
    local rocks_location =
      vim.fs.joinpath(vim.fn.stdpath("cache") --[[@as string]], "rocks.nvim")

    if not vim.uv.fs_stat(rocks_location) then
      -- Pull down rocks.nvim
      local url = "https://github.com/nvim-neorocks/rocks.nvim"
      vim.fn.system({ "git", "clone", "--filter=blob:none", url, rocks_location })
      -- Make sure the clone was successfull
      assert(
        vim.v.shell_error == 0,
        "rocks.nvim installation failed. Try exiting and re-entering Neovim!"
      )
    end

    -- If the clone was successful then source the bootstrapping script
    vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))

    vim.fn.delete(rocks_location, "rf")
  end
end

return fignvim.plug
