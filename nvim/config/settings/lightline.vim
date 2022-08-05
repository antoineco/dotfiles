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
      \ },
      \ 'separator': { 'left': "\uE0BC", 'right': "\uE0BE" },
      \ 'subseparator': { 'left': "\uE0BD", 'right': "\uE0BF" }
      \ }

" set component 'mode'
function! LightlineMode()
  return &ft ==? 'nvimtree' ? fnamemodify(getcwd(), ':~') :
         \ lightline#mode()
endfunction

" set component 'fugitive'
function! LightlineFugitive()
  if exists('*FugitiveHead') && &ft !=? 'nvimtree' && &columns > 75
    return FugitiveHead()
  endif
  return ''
endfunction

" set component 'go'
function! LightlineGo()
  if exists('*go#statusline#Show') && &ft !=? 'nvimtree' && &columns > 75
    return go#statusline#Show()
  endif
  return ''
endfunction

" set component 'filename'
function! LightlineFilename()
  let fname = expand('%:t')
  return &ft ==? 'nvimtree' ? '' :
       \ (fname !=# '' ? fname : '[No Name]')
endfunction

" set component 'fileformat'
function! LightlineFileformat()
  return &columns > 67 ? &ff : ''
endfunction

" set component 'fileencoding'
function! LightlineFileencoding()
  return &columns > 60 ? (&fenc!=#''?&fenc:&enc) : ''
endfunction

" set component 'filetype'
function! LightlineFiletype()
  return &columns > 50 ? (&ft!=#''?&ft:"no ft") : ''
endfunction

" set component 'percent'
function! LightlinePercent()
  return &ft ==? 'nvimtree' ? '' :
       \ printf("%3d%%", 100*line('.')/line('$'))
endfunction

" set component 'lineinfo'
function! LightlineLineinfo()
  return &ft ==? 'nvimtree' ? '' :
       \ printf("%3d:%-2d", line('.'), col('.'))
endfunction

" ==== Colorscheme (auto-)reload ====

augroup lightline_reload_colorscheme
  " reload lightline on colorscheme change
  autocmd!
  autocmd ColorScheme *
        \ call s:LightlineSetColorscheme() |
        \ call s:LightlineReload()
augroup END

function! s:LightlineSetColorscheme() abort
  if exists('g:colors_name')
    let g:lightline.colorscheme = g:colors_name
  endif
endfunction

function! s:LightlineReload()
  if !exists('g:loaded_lightline')
    return
  endif

  call lightline#init()        " reload g:lightline settings
  call lightline#colorscheme() " generate colors based on g:lightline.colorscheme
  call lightline#update()      " update status line in all windows
endfunction
