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
  if !exists('*FugitiveStatusline') || &ft ==? 'nvimtree' || &columns <= 75
    return ''
  endif
  let git_status = FugitiveStatusline()
  return git_status ==# '' ? '' : "\ue0a0 ".git_status
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
  return &ft ==? 'nvimtree' || &ft ==? 'fugitive' || &columns <= 67 ? '' :
       \ get({'unix':"\uf17c",'dos':"\uf17a",'mac':"\uf179"}, &ff, '')
endfunction

" set component 'fileencoding'
function! statusline#lightline#Fileencoding()
  return (&ft ==? 'nvimtree' || &ft ==? 'fugitive' || &columns <= 60) ? '' :
       \ &fenc !=# '' ? &fenc : &enc
endfunction

let s:icon_cache = {}

" determine icon glyph for file
function s:GetIcon(f_name, f_ext)
  let icon_cache_key = a:f_name . '::' . a:f_ext
  let icon = get(s:icon_cache, icon_cache_key, '')
  if icon ==# ''
    let icon = luaeval('require"nvim-web-devicons".get_icon(_A[1], _A[2])',
                     \ [a:f_name, a:f_ext])
    let s:icon_cache[icon_cache_key] = icon
  endif
  return icon
endfunction

" set component 'filetype'
function! statusline#lightline#Filetype()
  if &ft ==? 'nvimtree' || &ft ==? 'fugitive' || &columns <= 50
    return ''
  elseif &ft ==# ''
    return 'no ft'
  endif
  let f_ext = expand('%:e') | let f_ext = f_ext ==# '' ? &ft : f_ext
  let icon = s:GetIcon(expand('%:t'), f_ext)
  return icon ==# '' ? &ft : icon.' '.&ft
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
