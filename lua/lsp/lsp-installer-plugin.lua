local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}

	 if server.name == "jsonls" then
	 	local jsonls_opts = require("lsp.settings.jsonls")
	 	opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	 end

	 if server.name == "tsserver" then
	 	local tsserver_opts = require("lsp.settings.tsserver")
	 	opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
	 end

	 if server.name == "sumneko_lua" then
	 	local sumneko_opts = require("lsp.settings.sumneko_lua")
	 	opts = vim.tbl_deep_extend("force", sumneko_opts, opts)

    -- For developing Lua plugins for Neovim Only
    -- Comment out below lines so lua_dev is not used when working on other Lua projects
    server:setup({})

    local lua_dev = require('lua-dev').setup({
      library = { vimruntime = true, types = true, plugins = true },
      lspconfig = vim.tbl_deep_extend("force", opts, server:get_default_options())
    })

    require("lspconfig").sumneko_lua.setup(lua_dev)
    return
	 end

	 if server.name == "texlab" then
	 	local texlab_opts = require("lsp.settings.texlab")
	 	opts = vim.tbl_deep_extend("force", texlab_opts, opts)
	 end

	 if server.name == "terraformls" then
	 	local terraformls_opts = require("lsp.settings.terraformls")
	 	opts = vim.tbl_deep_extend("force", terraformls_opts, opts)
	 end

	 if server.name == "stylelint_lsp" then
	 	local stylelint_lsp_opts = require("lsp.settings.stylelint_lsp")
	 	opts = vim.tbl_deep_extend("force", stylelint_lsp_opts, opts)
	 end

	 if server.name == "efm" then
	 	local efm_opts = require("lsp.settings.efm")
	 	opts = vim.tbl_deep_extend("force", efm_opts, opts)
	 end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)

