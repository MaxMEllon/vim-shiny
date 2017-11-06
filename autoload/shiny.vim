scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#shiny#of()
let s:Highlight = s:V.import('Coaster.Highlight')

let s:vim_shiny_hi_paste = get(g:, 'vim_shiny_hi_paste', 'Shiny')

function! s:initialize() abort
  highlight default Shiny term=bold ctermbg=22 gui=bold guibg=#13354A
endfunction

call s:initialize()

function! shiny#p(...) abort
  call s:flash_and_paste('p')
endfunction

function! shiny#gp() abort
  call s:flash_and_paste('gp')
endfunction

function! shiny#P() abort
  call s:flash_and_paste('P')
endfunction

function! shiny#gP() abort
  call s:flash_and_paste('gP')
endfunction

function! s:generate_matcher_for_visual(line, index, start_loc, end_loc) abort
  if a:index == 0
    return printf('\%%%dl\%%%dv\_.*\%%%dl', a:line, a:start_loc[1], a:line)
  endif

  if a:index == a:end_loc[0] - a:start_loc[0]
    return printf('\%%%dl%\_.*\%%%dl\%%%dv', a:line, a:line, a:end_loc[1])
  endif

  return printf('\%%%dl\_.*\%%%dl', a:line, a:line)
endfunction

function! s:generate_patterns() abort
  let s = getpos("'[")[1:2]
  let e = getpos("']")[1:2]
  let mode = getregtype()

  if mode ==# 'V'
    return [printf('\%%%dl\_.*\%%%dl', s[0], e[0])]
  endif

  let patterns = []
  let k = 0
  for i in range(e[0] - s[0] + 1)
    let line = s[0] + i
    if mode ==# 'v'
      let p = s:generate_matcher_for_visual(line, k, s, e)
    else
      let p = printf('\%%%dl\%%%dv\_.*\%%%dl\%%%dv', line, s[1], line, e[1] + 1)
    endif
    let patterns = add(patterns, p)
    let k += 1
  endfor
  return patterns
endfunction

function! s:flash_and_paste(target) abort
  exec "normal! " . a:target
  let patterns = s:generate_patterns()
  call s:flash(patterns, s:vim_shiny_hi_paste)
endfunction

function! s:flash(patterns, group) abort
  let i = 0
  for p in a:patterns
    call s:Highlight.highlight('ShinyFlash' . i, a:group, p, 1)
    let i += 1
  endfor
  redraw
  call s:clear(i)
endfunction

function! s:clear(num) abort
  function! s:_clear() closure
    for i in range(a:num)
      call s:Highlight.clear('ShinyFlash' . i)
    endfor
  endfunction

  let timer = timer_start(800, { -> s:_clear() })
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:et:ts=2:sw=2:sts=2
