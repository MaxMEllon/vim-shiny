scriptencoding utf-8
if exists('g:vim_shiny_loaded')
  finish
endif

let g:vim_shiny_loaded = 1

let s:vim_shiny_window_change = get(g:, 'vim_shiny_window_change', 0)

if s:vim_shiny_window_change
  augroup plugin-vim-shiny
    autocmd WinEnter * call shiny#window#flash()
  augroup END
endif

nnoremap <silent> <Plug>(shiny-p)  :call shiny#p()<CR>
nnoremap <silent> <Plug>(shiny-P)  :call shiny#P()<CR>
nnoremap <silent> <Plug>(shiny-gp) :call shiny#gp()<CR>
nnoremap <silent> <Plug>(shiny-gP) :call shiny#gP()<CR>
