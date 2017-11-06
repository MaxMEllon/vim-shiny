scriptencoding utf-8
if exists('g:vim_shiny_loaded')
  finish
endif

let g:vim_shiny_loaded = 1

highlight FlashyPaste ctermbg=22
highligh  FlashyCursor ctermbg=15
highlight FlashyUndo  ctermbg=88

augroup vim-pikapika
  autocmd CursorMoved * call shiny#update_last_visual_mode_type()
augroup END

nnoremap <silent> <Plug>(shiny-p)  :<C-u>call shiny#p()<CR>
nnoremap <silent> <Plug>(shiny-P)  :<C-u>call shiny#P()<CR>
nnoremap <silent> <Plug>(shiny-gp) :<C-u>call shiny#gp()<CR>
nnoremap <silent> <Plug>(shiny-gP) :<C-u>call shiny#gP()<CR>

call repeat#set("\<Plug>(shiny-p)", 3)

