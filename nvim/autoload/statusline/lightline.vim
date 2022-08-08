" set component 'mode'
function! statusline#lightline#Mode()
  if &ft ==? 'nvimtree'
    return fnamemodify(getcwd(), ':~')
  elseif &ft ==? 'fugitive' && exists('*FugitiveHead')
    return FugitiveHead()
  endif
  return lightline#mode()
endfunction

" set component 'fugitive'
function! statusline#lightline#Fugitive()
  return (!exists('*FugitiveHead') || &ft ==? 'nvimtree' || &columns <= 75) ? '' :
       \ FugitiveHead()
endfunction

" set component 'go'
function! statusline#lightline#Go()
  return (!exists('*go#statusline#Show') ||
       \ &ft ==? 'nvimtree' || &ft ==? 'fugitive' || &columns <= 75) ? '' :
       \ go#statusline#Show()
endfunction

" set component 'filename'
function! statusline#lightline#Filename()
  if &ft ==? 'nvimtree' || &ft ==? 'fugitive' | return '' | endif
  let f_name = expand('%:t')
  return f_name !=# '' ? f_name : '[No Name]'
endfunction

" set component 'fileformat'
function! statusline#lightline#Fileformat()
  return (&ft ==? 'nvimtree' || &ft ==? 'fugitive' || &columns <= 67) ? '' :
       \ &ff
endfunction

" set component 'fileencoding'
function! statusline#lightline#Fileencoding()
  return (&ft ==? 'nvimtree' || &ft ==? 'fugitive' || &columns <= 60) ? '' :
       \ &fenc !=# '' ? &fenc : &enc
endfunction

" set component 'filetype'
function! statusline#lightline#Filetype()
  return (&ft ==? 'nvimtree' || &ft ==? 'fugitive' || &columns <= 50) ? '' :
       \ &ft !=# '' ? &ft : "no ft"
endfunction

" set component 'percent'
function! statusline#lightline#Percent()
  return (&ft ==? 'nvimtree' || &ft ==? 'fugitive') ? '' :
       \ printf("%3d%%", 100*line('.')/line('$'))
endfunction

" set component 'lineinfo'
function! statusline#lightline#Lineinfo()
  return &ft ==? 'nvimtree' ? '' :
       \ printf("%3d:%-2d", line('.'), col('.'))
endfunction
