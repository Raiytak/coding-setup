function! InsertDate()
    execute 'normal! i# ' . strftime("%Y-%m-%d")
endfunction
nnoremap <leader>d :call InsertDate()<CR>
