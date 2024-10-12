autocmd BufNewFile ~/vimwiki/diary/* call SetupDiaryEntry()
let g:vimwiki_list = [{'syntax':'markdown', 'ext':'.md', 'auto_diary_index': 1}]
