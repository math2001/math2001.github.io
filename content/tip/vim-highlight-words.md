---
title: Highlight every occurrences of the word under the cursor in VIM
slug: highlight-every-occurrences-word-under-cursor-vim
tags: [ [ vim, vimscript ] ]
categories: [ cool feature ]
date: 2017-08-22
---

[ A feature of Sublime Text I really enjoyed was highlighting every occurrence of ]
the selected word.

So, here's the VIM way. It's not implemented by default, but a bit of vimscript
never hurt anyone, right?

So, it's going to be a bit different than Sublime Text's version, because I
thinks it's even better, but it's up to you to tweak this if you want to ;)

It's going to be a function that does this:

- if the cursor is on a word that has been highlighted
    - clear the highlights
- otherwise, simply highlight the matches

So, here's our function:

```vim
function! ToggleHighlightWordUnderCursor()
    " get the current matches
    let matches = getmatches()
    " get the word under the cursor
    let cword = expand('<cword>')
    " if there is some matches AND the cursor is on one of them
    if !empty(matches) && printf('\<%s\>', cword) ==# matches[0]['pattern']
        match none
        echo "Matches cleared"
    else
        " highlight the matches with the 'scope' IncSearch (the one used when you
        " do a regular search)
        silent! exe printf('match IncSearch /\<%s\>/', cword)
        " Extra: echo how many matches there is
        redir => nbmatches
            silent! exe "%s/".cword."//gn"
        redir END
        let nbmatches = str2nr(Strip(split(nbmatches, ' ')[0]))
        echo printf('Found %s match%s', nbmatches, nbmatches > 1 ? 'es' : '')
        " move cursor back to its previous position, since it has been moved to
        " the beginning of the line by :match 
        execute "normal! \<C-o>"
    endif
endfunction
```

And now, just bind it to a shortcut:

```vim
nnoremap <silent> <leader>w :call ToggleHighlightWordUnderCursor()<CR>
" for convenience
nnoremap <silent> <leader>W :match none<CR>
```

So now, just press <kbd>&lt;leader&gt;w</kbd>.

Pressing <kbd>&lt;leader&gt;W</kbd> will clear the highlights, wherever you are.
