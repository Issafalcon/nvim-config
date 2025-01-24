local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })
local path = install_dir .. "/packages/debugpy/venv/bin/python"

require("dap-python").setup(path)
