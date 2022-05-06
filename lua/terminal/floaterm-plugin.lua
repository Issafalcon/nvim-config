local ranger_open = ":FloatermNew --height=0.8 --width=0.8 --wintype=float --name=Ranger --autoclose=2 ranger<CR>"
vim.api.nvim_set_keymap("n", "<leader>-", ranger_open, {noremap = true, silent = true})
