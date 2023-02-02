fun! StripTrailingWhitespace()
  " Don't strip on these filetypes
  if &ft =~ 'markdown\|vimwiki'
    return
  endif
  %s/\s\+$//e
endfun

" Clear trailing spaces on save
autocmd BufWritePre * call StripTrailingWhitespace()

" Disable line numbers in terminals
autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no

autocmd BufWritePre * silent lua vim.lsp.buf.format()

" Set loclist on ~file change
" autocmd BufWrite,BufEnter,InsertLeave * lua vim.lsp.diagnostic.set_loclist{open_loclist = false}
