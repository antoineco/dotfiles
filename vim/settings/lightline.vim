let g:lightline = {
      \ 'active': {
      \   'left'  : [ [ 'mode', 'paste' ], [ 'readonly', 'fugitive', 'filename', 'modified' ] ],
      \   'right' : [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ], [ 'go' ] ]
      \ },
      \ 'component_function': {
      \   'mode'         : 'LightlineMode',
      \   'fugitive'     : 'LightlineFugitive',
      \   'go'           : 'LightlineGo',
      \   'filename'     : 'LightlineFilename',
      \   'fileformat'   : 'LightlineFileformat',
      \   'fileencoding' : 'LightlineFileencoding',
      \   'filetype'     : 'LightlineFiletype',
      \   'percent'      : 'LightlinePercent',
      \   'lineinfo'     : 'LightlineLineinfo'
      \ }
      \ }

" set component 'mode'
function! LightlineMode()
  return &ft ==# 'nerdtree' ? 'NERDTree' : lightline#mode()
endfunction

" set component 'fugitive'
function! LightlineFugitive()
  if exists('*FugitiveHead') && &ft !=# 'nerdtree' && winwidth(0) > 75
    return FugitiveHead()
  endif
  return ''
endfunction

" set component 'go'
function! LightlineGo()
  if exists('*go#statusline#Show') && &ft !=# 'nerdtree' && winwidth(0) > 75
    return go#statusline#Show()
  endif
  return ''
endfunction

" set component 'filename'
function! LightlineFilename()
  let fname = expand('%:t')
  return &ft ==# 'nerdtree' ? '' :
       \ (fname !=# '' ? fname : '[No Name]')
endfunction

" set component 'fileformat'
function! LightlineFileformat()
  return winwidth(0) > 67 ? &ff : ''
endfunction

" set component 'fileencoding'
function! LightlineFileencoding()
  return winwidth(0) > 60 ? (&fenc!=#''?&fenc:&enc) : ''
endfunction

" set component 'filetype'
function! LightlineFiletype()
  return winwidth(0) > 50 ? (&ft!=#''?&ft:"no ft") : ''
endfunction

" set component 'percent'
function! LightlinePercent()
  return &ft ==# 'nerdtree' ? '' :
       \ printf("%3d%%", 100*line('.')/line('$'))
endfunction

" set component 'lineinfo'
function! LightlineLineinfo()
  return &ft ==# 'nerdtree' ? '' :
       \ printf("%3d:%-2d", line('.'), col('.'))
endfunction
