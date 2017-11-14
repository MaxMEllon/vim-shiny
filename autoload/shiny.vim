scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#shiny#of()
let s:Highlight = s:V.import('Coaster.Highlight')
let s:vim_shiny_hi_paste = get(g:, 'vim_shiny_hi_paste', 'Shiny')
let s:enable_fade = get(g:, 'vim_shiny_enable_fade_on_gui', 1)

let s:colors = {
      \  'light': ['#ccffd2', '#b2ffbc', '#9effaa', '#b2ffbc', '#ccffd2'],
      \  'dark': ['#056313', '#088c1c', '#08a31c', '#088c1c', '#056313'],
      \}

function! s:initialize() abort
  highlight default Shiny term=bold ctermbg=22 gui=bold guibg=#13354A
endfunction

call s:initialize()

function! shiny#p(...) abort range
  call s:flash_and_paste('p', a:lastline - a:firstline + 1)
endfunction

function! shiny#gp(...) abort range
  call s:flash_and_paste('gp', a:lastline - a:firstline + 1)
endfunction

function! shiny#P(...) abort range
  call s:flash_and_paste('P', a:lastline - a:firstline + 1)
endfunction

function! shiny#gP(...) abort range
  call s:flash_and_paste('gP', a:lastline - a:firstline + 1)
endfunction

function! s:generate_matcher_for_visual(start_loc, end_loc) abort
  return [
          \printf('\%%%dl\%%%dv\_.*\%%%dl', a:start_loc[0], a:start_loc[1], a:start_loc[0]),
          \printf('\%%%dl\_.*\%%%dl', a:start_loc[0] + 1, a:end_loc[0] - 1),
          \printf('\%%%dl%\_.*\%%%dl\%%%dv', a:end_loc[0], a:end_loc[0], a:end_loc[1]),
          \]
endfunction

function! s:generate_matcher_for_visual_block(start_loc, end_loc) abort
  let s = a:start_loc
  let e = a:end_loc
  let patterns = []
  let k = 0
  for i in range(e[0] - s[0] + 1)
    let line = s[0] + i
    let p = printf('\%%%dl\%%%dv\_.*\%%%dl\%%%dv', line, s[1], line, e[1] + 1)
    let patterns = add(patterns, p)
    let k += 1
  endfor
  return patterns
endfunction

function! s:generate_patterns(count) abort
  let s = getpos("'[")[1:2]
  let e = getpos("']")[1:2]
  let mode = getregtype(v:register)
  let length = len(split(getreg(v:register), "[\n|\r]"))

  if length == 1 && a:count == 1
    return s:generate_matcher_for_visual_block(s, e)
  endif

  if mode ==# 'V'
    return [printf('\%%%dl\_.*\%%%dl', s[0], e[0])]
  endif

  if mode ==# 'v'
    return s:generate_matcher_for_visual(s, e)
  endif

  return s:generate_matcher_for_visual_block(s, e)
endfunction

function! s:flash_and_paste(target, count) abort
  exec 'normal! "' . v:register . a:count . a:target
  let patterns = s:generate_patterns(a:count)
  call s:flash(patterns, s:vim_shiny_hi_paste)
endfunction

function! s:flash(patterns, group) abort
  let i = 0
  for p in a:patterns
    if getchar(1)
      break
    endif
    call s:Highlight.highlight('ShinyFlash' . i, a:group, p, 1)
    let i += 1
  endfor
  redraw
  call s:clear(i)
endfunction

function! s:_flash_fade(patterns, group) abort
  let bg = &background ==# 'dark' ? 'dark' : 'light'
  let c = s:colors[bg]
  let duration = 100 / len(c)
  for k in range(5)
    if getchar(1)
      break
    endif
    exe 'hi! ' . a:group .' guibg=' . c[k]
    let i = 0
    for p in a:patterns
      call s:Highlight.highlight('ShinyFlash' . i, a:group, p, 1)
      let i += 1
    endfor
    exec 'sleep ' . duration . 'm'
    redraw
  endfor
  call s:clear(i)
endfunction

function! s:flash(patterns, group) abort
  if (has('gui_running') || &termguicolors) && s:enable_fade
    call timer_start(0, { -> s:_flash_fade(a:patterns, a:group) })
  else
    call timer_start(0, { -> s:_flash(a:patterns, a:group) })
  endif
endfunction

function! s:clear(num) abort
  for i in range(a:num)
    call s:Highlight.clear('ShinyFlash' . i)
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:et:ts=2:sw=2:sts=2
