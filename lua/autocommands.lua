vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo,spectre_panel nnoremap <silent> <buffer> q :close<CR> 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

	augroup _highlight_color_overrides
		autocmd!
		"So that listchars show up
		autocmd ColorScheme * highlight Whitespace ctermfg=11 guifg=#4b5263
	augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _latex
    autocmd!
    autocmd FileType tex setlocal spell
  augroup end

  augroup _csharp
    autocmd!
    autocmd FileType cs setlocal
			\ shiftwidth=4
			\ tabstop=4
			\ softtabstop=4
			\ noexpandtab
      \ foldlevelstart=2
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end
]]
