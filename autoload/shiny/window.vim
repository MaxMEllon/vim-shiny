scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:colorcolumn = &colorcolumn
let s:vim_shiny_hi_window_change = get(g:, 'vim_shiny_hi_window_change', 'WindowChange')

function! s:initialize() abort
  highlight default WindowChange ctermbg=236 guibg=#333333
endfunction

let s:colors = {
      \  'light': {
      \    'cterm': [250, 251, 252, 253, 255]
      \  },
      \  'dark': {
      \    'cterm': [243, 239, 238, 237, 236]
      \  },
      \}

call s:initialize()

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
    if i == winnr()
      let l:width = 256
      let l:range = join(range(1, l:width), ',')
      let bg = &background == 'dark' ? 'dark' : 'light'
      call setwinvar(i, '&colorcolumn', range)
      function! s:_flash() closure
        for i in s:colors[bg].cterm
          exec 'highlight! ColorColumn ctermbg=' . i
          redraw
          sleep 10m
        endfor
        call s:clear()
      endfunction
      call timer_start(10, { -> s:_flash() })
    endif
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:et:ts=2:sw=2:sts=2
