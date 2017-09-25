---
title: DynamicOpen function
slug: dynamicopen-function-vim
tags: [ vim, vimscript ]
categories: [ cool feature ]
date: 2017-08-27
place: In the car
---

I really open my `.vimrc` often. Too often to have to type `:e ~/.vimrc` or
`:tabe ~/.vimrc `every time.

Here's a little function that will open a file in a new tab if there isn't enough
room for a new split, and, you guessed it, in a new *vertical* split if there
is.

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
