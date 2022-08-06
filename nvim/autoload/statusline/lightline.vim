" set component 'mode'
function! statusline#lightline#Mode()
  return &ft ==? 'nvimtree' ? fnamemodify(getcwd(), ':~') :
         \ lightline#mode()
endfunction

" set component 'fugitive'
function! statusline#lightline#Fugitive()
  if exists('*FugitiveHead') && &ft !=? 'nvimtree' && &columns > 75
    return FugitiveHead()
  endif
  return ''
endfunction

" set component 'go'
function! statusline#lightline#Go()
  if exists('*go#statusline#Show') && &ft !=? 'nvimtree' && &columns > 75
    return go#statusline#Show()
  endif
  return ''
endfunction

" set component 'filename'
function! statusline#lightline#Filename()
  let fname = expand('%:t')
  return &ft ==? 'nvimtree' ? '' :
       \ (fname !=# '' ? fname : '[No Name]')
endfunction

" set component 'fileformat'
function! statusline#lightline#Fileformat()
  return &columns > 67 ? &ff : ''
endfunction

" set component 'fileencoding'
function! statusline#lightline#Fileencoding()
  return &columns > 60 ? (&fenc!=#''?&fenc:&enc) : ''
endfunction

" set component 'filetype'
function! statusline#lightline#Filetype()
  return &columns > 50 ? (&ft!=#''?&ft:"no ft") : ''
endfunction

" set component 'percent'
function! statusline#lightline#Percent()
  return &ft ==? 'nvimtree' ? '' :
       \ printf("%3d%%", 100*line('.')/line('$'))
endfunction

" set component 'lineinfo'
function! statusline#lightline#Lineinfo()
  return &ft ==? 'nvimtree' ? '' :
       \ printf("%3d:%-2d", line('.'), col('.'))
endfunction
