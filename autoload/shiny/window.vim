scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:colorcolumn = &colorcolumn

function! s:save_hi(group) abort
  silent redir => hi
    exec 'hi ' . a:group
  redir END
  let hi = substitute(hi, "[\n|\r]*", '', 'g')
  return  substitute(hi, 'xxx', '', 'g')
endfunction

let s:hi_ColorColumn = s:save_hi('ColorColumn')

function! s:restore_hi(hi) abort
  exec 'hi! ' . a:hi
endfunction

function! s:clear() abort
  function! s:_clear() closure
    let &colorcolumn = s:colorcolumn
    call s:restore_hi(s:hi_ColorColumn)
  endfunction

  let timer = timer_start(300, { -> s:_clear() })
endfunction

function! shiny#window#flash() abort
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let range = ''
    if i == winnr()
      let l:width = 256
      let l:range = join(range(1, l:width), ',')
      highlight! ColorColumn ctermbg=235
      call setwinvar(i, '&colorcolumn', range)
      call s:clear()
    endif
  endfor
endfunction
