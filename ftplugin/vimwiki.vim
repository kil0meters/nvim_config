" imap <buffer> <expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? '<C-n><C-y><Plug>(vsnip-expand)' : '<C-y><Plug>(vsnip-expand)') : '<C-]><Esc>:VimwikiReturn 1 5<CR>'
" imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : pumvisible() ? "\<C-p>" : '<S-Tab>'
" smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : pumvisible() ? "\<C-p>" : '<S-Tab>'
setlocal fo+=t
setlocal spell
