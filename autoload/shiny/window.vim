scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:colorcolumn = &colorcolumn
let s:vim_shiny_hi_window_change = get(g:, 'vim_shiny_hi_window_change', 'WindowChange')

function! s:initialize() abort
  highlight default WindowChange ctermbg=236 guibg=#333333
endfunction

call s:initialize()

function! s:restore_hi(hi) abort
  exec 'hi! ' . a:hi
endfunction

function! s:clear() abort
  function! s:_clear() closure
    let &colorcolumn = s:colorcolumn
    highlight! link ColorColumn NONE
  endfunction

  let timer = timer_start(300, { -> s:_clear() })
endfunction

function! shiny#window#flash() abort
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let range = ''
    if i == winnr()
      let l:width = 256
      let l:range = join(range(1, l:width), ',')
      exec 'highlight! link ColorColumn ' . s:vim_shiny_hi_window_change
      call setwinvar(i, '&colorcolumn', range)
      call s:clear()
    endif
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:et:ts=2:sw=2:sts=2
