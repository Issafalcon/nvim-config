local netrw_nvim_keys = {
  {
    "n",
    "<leader>e",
    function()
      -- get all netrw buffer numbers and close them
      local netrw_buffers = vim.tbl_filter(function(buf) return vim.bo[buf].filetype == "netrw" end, vim.api.nvim_list_bufs())
      if #netrw_buffers > 0 then
        for _, buf in ipairs(netrw_buffers) do
          vim.cmd("bdelete " .. buf)
        end
      else
        vim.cmd("Lexplore %:p:h")
      end
    end,
    { desc = "Open Netrw in dir of current file" },
  },
  -- No need to check if existing netrw buffers open as this command will toggle by default
  { "n", "<leader>E", ":Lexplore<CR>", { desc = "Open Netrw in current working dir" } },
}

return {
  {
  "prichrd/netrw.nvim",
  keys = fignvim.mappings.make_lazy_keymaps(netrw_nvim_keys, true),
  init = function()
    fignvim.config.set_vim_opts({
      g = {
        netrw_keepdir = 0,
        netrw_winsize = 20,
        netrw_banner = 0,
        netrw_localcopydircmd = "cp -r",
      },
    })
  end,
  opts = {
    mappings = {
      ["<leader>e"] = ":bdelete<CR>",
      ["p"] = function(payload) print(vim.inspect(payload)) end,

      -- Better file marking
      ["<TAB>"] = ":normal mf<CR>", -- Mark file / dir
      ["<S-TAB>"] = ":normal mF<CR>", -- Unmark all files in current buffer
      ["<Leader><TAB>"] = ":normal mu<CR>", -- Remove marks on all files

      -- Navigation
      ["<C-l>"] = "<C-w>l",

      -- File management
      ["n"] = function(payload)
        local file_dir = payload.dir
        local file_name =
          vim.fn.input({ prompt = "Enter new file name (end with '/' for directories): ", default = "", completion = "file" })

        -- Check if user is creating directory or file
        if file_name:sub(-1) == "/" then
          vim.fn.mkdir(file_dir .. "/" .. file_name, "p")
        else
          vim.fn.writefile({}, file_dir .. "/" .. file_name)
        end

        -- Refresh netrw list
        vim.cmd("edit .")
      end,
      ["D"] = function(payload)
        if payload.type == 0 then
          -- We are deleting a dir. Do it recursively with warning
          local dir = payload.dir .. "/" .. payload.node
          local delete_dir = vim.fn.input({ prompt = "Delete directory " .. payload.node .. " recursively? (y/n): ", default = "n" })
          if delete_dir == "y" then vim.fn.delete(dir, "rf") end
        else
          -- We are deleting a file. Do it with warning
          local file = payload.dir .. "/" .. payload.node
          local delete_file = vim.fn.input({ prompt = "Delete file " .. payload.node .. "? (y/n): ", default = "n" })
          if delete_file == "y" then vim.fn.delete(file) end
        end

        vim.cmd("edit .")
      end,
    },
  },
  config = function(_, opts) require("netrw").setup(opts) end,
}
}