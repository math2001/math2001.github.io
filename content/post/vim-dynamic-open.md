---
title: DynamicOpen function
slug: dynamicopen-function-vim
tags: [tip, vim, vimscript]
date: 2017-08-27
place: In the car
---

I really open my `.vimrc` often. Too often to have to type `:e ~/.vimrc` or
`:tabe ~/.vimrc ` every time. Here's little function that will open a file in a
new tab if there isn't enough room for a new split, and, you guessed it, in a
new *vertical* split if there is.<!--more-->

```vim
function! DynamicOpen(file)
    if winwidth(win_getid()) > 160
        execute "vsplit ".a:file
    else
        execute "tabe ".a:file
    endif
endfunction

nnoremap <leader>ev :call DynamicOpen($MYVIMRC)<CR>
```

It just checks with width of the current window.

More infos: `:help window-functions`
