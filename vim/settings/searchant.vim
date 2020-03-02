let g:searchant_map_stop = 0

highlight SearchCurrent ctermbg=red ctermfg=0 guibg=#ab4642 guifg=#000000

" clear highlighted search results
nmap <silent> <C-L> <Plug>SearchantStop:diffupdate<Bar>redraw!<CR>
