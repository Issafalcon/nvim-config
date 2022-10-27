local opts = {
	handlers = {
		["textDocument/definition"] = require('omnisharp_extended').handler
	}
}

return opts
