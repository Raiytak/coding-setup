augroup VimWikiDiaryBufNewFile
    autocmd!
    let g:vimwiki_list = [{'syntax':'markdown', 'ext':'.md', 'auto_diary_index': 1}]
    autocmd BufNewFile ~/vimwiki/diary/* execute 'normal! i# ' . strftime("%Y-%m-%d") . "\<CR>\<Esc>"
    autocmd BufNewFile ~/vimwiki/diary/* call vim_diary_newfile#SetupDiaryEntry()
augroup END
