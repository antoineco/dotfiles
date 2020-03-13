" automatically enable syntax-based folding with 'zv'
nnoremap <silent> <expr> zv
\ (&foldmethod ==# 'syntax' ? ''
\   : ':setlocal foldmethod=syntax foldcolumn=3' . "\<CR>"
\ ) . 'zv'
