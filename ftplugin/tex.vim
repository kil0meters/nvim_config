setlocal sw=2 ts=2 sts=2
setlocal fo+=t
setlocal spell
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal concealcursor=n
setlocal conceallevel=2

nmap <enter> <cmd>TexlabForward<CR>
