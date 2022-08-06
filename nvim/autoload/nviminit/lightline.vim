function! nviminit#lightline#SetColorscheme() abort
  if exists('g:colors_name')
    let g:lightline.colorscheme = g:colors_name
  endif
endfunction

function! nviminit#lightline#Reload()
  if !exists('g:loaded_lightline')
    return
  endif

  call lightline#init()         " reload g:lightline settings
  call lightline#colorscheme()  " generate colors based on g:lightline.colorscheme
  call lightline#update()       " update status line in all windows
endfunction
