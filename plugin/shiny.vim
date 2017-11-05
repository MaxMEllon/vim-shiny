highlight FlashyPaste ctermbg=22
highligh  FlashyCursor ctermbg=15
highlight FlashyUndo  ctermbg=88

augroup vim-pikapika
  autocmd CursorMoved * call shiny#flash#update_last_visual_mode_type()
augroup END

nnoremap p  :<C-u>call shiny#flash#p()<CR>
nnoremap <Plug>(shiny-P)  :<C-u>call shiny#flash#P()<CR>
nnoremap <Plug>(shiny-gp) :<C-u>call shiny#flash#gp()<CR>
nnoremap <Plug>(shiny-gP) :<C-u>call shiny#flash#gP()<CR>
