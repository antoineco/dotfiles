nmap <Leader>b <Plug>(go-build)
nmap <Leader>t <Plug>(go-test)
nmap <Leader>tf <Plug>(go-test-func)
nmap <Leader>tc <Plug>(go-test-compile)

autocmd BufWritePre <buffer> lua require'go'.org_imports()
