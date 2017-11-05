scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#shiny#of()
let s:Highlight = s:V.import('Coaster.Highlight')

let s:mode = ''

function! shiny#flash#p() abort
  call s:flash_by_target('p', 'FlashyPaste')
endfunction

function! shiny#flash#gp() abort
  call s:flash_by_target('gp', 'FlashyPaste')
endfunction

function! shiny#flash#P() abort
  call s:flash_by_target('P', 'FlashyPaste')
endfunction

function! shiny#flash#gP() abort
  call s:flash_by_target('gP', 'FlashyPaste')
endfunction

function! shiny#flash#update_last_visual_mode_type()
  if mode() =~# "^[vV\<C-v>]"
    let s:mode = mode()
  endif
endfunction

function! s:generate_matcher_for_visual(line, index, start_loc, end_loc)
  if a:index == 0
    return printf('\%%%dl\%%%dv\_.*\%%%dl', a:line, a:start_loc[1], a:line)
  endif

  if a:index == a:end_loc[0] - a:start_loc[0]
    return printf('\%%%dl%\_.*\%%%dl\%%%dv', a:line, a:line, a:end_loc[1])
  endif

  return printf('\%%%dl\_.*\%%%dl', a:line, a:line)
endfunction

function! s:flash_by_target(target, group) abort
  exec "normal! " . a:target
  let s = [getpos("'[")[1], getpos("'[")[2]]
  let e = [getpos("']")[1], getpos("']")[2]]
  let patterns = []
  let k = 0
  for i in range(e[0] - s[0] + 1)
    let line = s[0] + i
    if s:mode ==# 'v'
      let p = s:generate_matcher_for_visual(line, k, s, e)
    elseif s:mode ==# 'V'
      let p = printf('\%%%dl\_.*\%%%dl', line, line)
    else
      let p = printf('\%%%dl\%%%dv\_.*\%%%dl\%%%dv', line, s[1], line, e[1] + 1)
    endif
    let patterns = add(patterns, p)
    let k += 1
  endfor
  call s:flash(patterns, a:group)
endfunction

function! s:flash(patterns, group) abort
  let i = 0
  for p in a:patterns
    call s:Highlight.highlight('ShinyFlash' . i, a:group, p, 1)
    let i += 1
  endfor
  call s:Highlight.highlight('ShinyCursor', 'flashycursor', '\%#', 1)
  redraw
  let highlighted_lnum = len(a:patterns)
  call s:clear(highlighted_lnum)
endfunction

function! s:clear(num)
  function! s:_clear() closure
    for i in range(a:num)
      call s:Highlight.clear('ShinyFlash' . i)
    endfor
    call s:Highlight.clear('ShinyCursor')
  endfunction

  let timer = timer_start(800, { -> s:_clear() })
endfunction
