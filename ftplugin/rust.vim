" autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"ChainingHint"} }
setlocal foldmethod=syntax
