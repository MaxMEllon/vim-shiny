scriptencoding utf-8
if exists('g:vim_shiny_loaded')
  finish
endif

let g:vim_shiny_loaded = 1

highlight ShinyPaste  ctermbg=22
highlight ShinyCursor ctermbg=15
highlight ShinyUndo   ctermbg=88

augroup WindShine
  autocmd WinEnter * call shiny#window#flash()
augroup END

nnoremap <silent> <Plug>(shiny-p)  :<C-u>call shiny#p()<CR>
nnoremap <silent> <Plug>(shiny-P)  :<C-u>call shiny#P()<CR>
nnoremap <silent> <Plug>(shiny-gp) :<C-u>call shiny#gp()<CR>
nnoremap <silent> <Plug>(shiny-gP) :<C-u>call shiny#gP()<CR>
