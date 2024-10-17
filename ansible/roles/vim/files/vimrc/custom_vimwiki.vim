autocmd BufNewFile ~/vimwiki/diary/* call vim_diary_newfile#SetupDiaryEntry()
let g:vimwiki_list = [{'syntax':'markdown', 'ext':'.md', 'auto_diary_index': 1}]
