function! ToggleQuickfixList()
  if getqflist({'winid' : 0}).winid
    cclose
  else
    copen
  endif
endfunction

function! ToggleLocationList()
  if getloclist(0, {'winid' : 0}).winid
    lclose
  else
    lopen
  endif
endfunction

command! -nargs=0 -bar ToggleQuickfixList call ToggleQuickfixList()
command! -nargs=0 -bar ToggleLocationList call ToggleLocationList()
