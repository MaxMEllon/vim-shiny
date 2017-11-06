scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:colorcolumn = &colorcolumn
redir => s:hi
  hi ColorColumn
redir END

let s:hi = substitute(s:hi, "[\n|\r]*", '', 'g')
let s:hi_colorcolumn = substitute(s:hi, 'xxx', '', 'g')

function! s:clear() abort
  function! s:_clear() closure
    let &colorcolumn = s:colorcolumn
    exec 'hi! ' . s:hi_colorcolumn
  endfunction

  let timer = timer_start(300, { -> s:_clear() })
endfunction

function! shiny#window#flash() abort
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let range = ''
    if i == winnr()
      let l:width = 256
      let l:range = join(range(1, l:width), ',')
      highlight! colorcolumn ctermbg=236
      call setwinvar(i, '&colorcolumn', range)
      call s:clear()
    endif
  endfor
endfunction
