scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:colorcolumn = &colorcolumn

let s:colors = {
      \  'light': {
      \    'cterm': [248, 251, 252, 253, 255],
      \    'gui': ['#a8a8a8', '#c6c6c6', '#eeeeee', '#c6c6c6', '#a8a8a8'],
      \  },
      \  'dark': {
      \    'cterm': [244, 242, 238, 237, 236],
      \    'gui': ['#a8a8a8', '#6c6c6c', '#444444', '#3a3a3a', '#303030'],
      \  },
      \}

function! s:save_hi(hi) abort
  silent redir => hi
    exec 'hi ' . a:hi
  redir END
  let hi = substitute(hi, "[\n|\r]*", '', 'g')
  return substitute(hi, 'xxx', '', 'g')
endfunction

let s:hi_ColorColumn = s:save_hi('ColorColumn')

function! s:restore_hi(hi) abort
  silent exec 'hi! ' . a:hi
endfunction

function! s:clear() abort
  let &colorcolumn = s:colorcolumn
  call s:restore_hi(s:hi_ColorColumn)
endfunction

function! shiny#window#flash() abort
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let range = ''
    if i != winnr()
      continue
    endif

    let l:width = 256
    let l:range = join(range(1, l:width), ',')
    let bg = &background == 'dark' ? 'dark' : 'light'
    call setwinvar(i, '&colorcolumn', range)
    function! s:_flash() closure
      for i in range(5)
        exec 'highlight! ColorColumn ctermbg=' .  s:colors[bg]['cterm'][i] . ' guibg=' . s:colors[bg]['gui'][i]
        redraw
        sleep 50m
      endfor
      call s:clear()
    endfunction
    call timer_start(0, { -> s:_flash() })
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:et:ts=2:sw=2:sts=2
