nmap <Leader>b <Plug>(go-build)
nmap <Leader>t <Plug>(go-test)
nmap <Leader>tf <Plug>(go-test-func)
nmap <Leader>tc <Plug>(go-test-compile)

" automatically enable syntax-based folding with 'zv'
nnoremap <silent> <expr> zv
\ (&foldmethod ==# 'syntax' ? ''
\   : ':setlocal foldmethod=syntax foldcolumn=3' . "\<CR>"
\ ) . 'zv'
