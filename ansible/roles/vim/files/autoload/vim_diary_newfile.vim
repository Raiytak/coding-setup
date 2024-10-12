function! PreviousDayDiaryExists()
    " Get the previous day's date in YYYY-MM-DD format
    let prev_date = strftime("%Y-%m-%d", localtime() - 86400)

    " Define the file path for the previous day's diary entry
    let prev_file = expand("~/vimwiki/diary/" . prev_date . ".md")

    " Check if the file for the previous day exists
    if filereadable(prev_file)
        echo "Diary entry for " . prev_date . " exists."
        return 1
    else
        echo "No diary entry for " . prev_date
        return 0
    endif
endfunction

function! GetPreviousDayDiary()
    " Get the name of the previous day's diary file
    let l:prev_date = strftime("%Y-%m-%d", localtime() - 86400)
    let l:prev_file = expand("~/vimwiki/diary/" . l:prev_date . ".md")  " Previous diary file path

    " Check if the previous day's diary file exists
    if filereadable(l:prev_file)
        " Read the contents of the previous day's diary entry
        return readfile(l:prev_file)
    else
        " Notify if the previous diary file doesn't exist
        echo "Previous diary file not found: " . l:prev_file
        return []
    endif
endfunction

function! InsertDiaryTemplate()
    " Load the template from the file
    let l:template_file = expand('~/.vim/template/vimwiki_diary.txt')
    let l:template = readfile(l:template_file)

    " Insert the template into the new diary entry
    call append(0, l:template)
    " Write the changes to the file
endfunction

function! InsertPreviousDayUnfinishedTasks()
    let l:lines = GetPreviousDayDiary()
    let l:unfinished_tasks = []
    let l:next_day_section = 0

    for l:line in l:lines
        if l:line =~ '^# Next day'
            let l:next_day_section = 1
            continue
        elseif l:line =~ '^#'
            let l:next_day_section = 0
        endif

        " If we are in the 'Next day' section, check for undone tasks
        if l:next_day_section
            if !(l:line =~ '\[X\]' || empty(trim(l:line)))  " Copy non-completed tasks
                call add(l:unfinished_tasks, l:line)
                continue
            endif
        endif
    endfor

    if !empty(l:unfinished_tasks)
        " Reverse the order of unfinished_tasks to maintain the correct sequence
        call reverse(l:unfinished_tasks)
        " Find the line number of the TODOs section
        let l:todo_line = search('# TODOs', 'w')
        " Insert unfinished_tasks under the TODOs section
        for l:task in l:unfinished_tasks
            call append(line('.'), l:task)
        endfor
    endif
    write
endfunction

function! DeleteUnfinishedTasksAndMarkAsCopied()
    let l:lines = GetPreviousDayDiary()
    let l:prev_date = strftime("%Y-%m-%d", localtime() - 86400)
    let l:prev_file = expand("~/vimwiki/diary/" . l:prev_date . ".md")  " Previous diary file path
    let l:new_lines = []
    let l:next_day_section = 0
    let l:modification_done = 0

    for l:line in l:lines
        " Determine if we are in the 'Next day' section
        if l:line =~ '^# Next day'
            let l:next_day_section = 1
            call add(l:new_lines, l:line)
            continue
        elseif l:line =~ '^#'
            let l:next_day_section = 0
        endif

        " If we are in the 'Next day' section, check for undone tasks
        if l:next_day_section
            if (l:line =~ '\[ \]')  " Delete non-completed tasks
                call delete(line('.') - 1)  " Deletes the current line
                let l:modification_done = 1
                continue
            endif
        endif

        " Add other lines that are not tasks to new_lines
        if !(l:line =~ '^- \[.\] ') || !(l:next_day_section)
            call add(l:new_lines, l:line)
        endif
    endfor

    if l:modification_done
        " Add the line indicating tasks were copied
        call add(l:new_lines, '* [X] Undone tasks copied to the next day 🛸')
        " Write the updated content back to the previous day's file
        call writefile(l:new_lines, l:prev_file)
    endif
endfunction

" Automatically call the function when creating a new diary entry file
function! SetupDiaryEntry()
    if PreviousDayDiaryExists()
        call InsertDiaryTemplate()
        call InsertPreviousDayUnfinishedTasks()
        call DeleteUnfinishedTasksAndMarkAsCopied()
    endif
endfunction
