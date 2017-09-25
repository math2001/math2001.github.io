---
title: Variable scopes in vim
slug: variable-scopes-vim
tags: [ vim, scopes, variable, vimscript ]
categories: [ infos ]
date: "2017-08-25"
place: In the car on the way to the snow!
---

An interesting feature of vim script is variable scoping. Here's a copy-paste
from the documentation, just in case you never saw it before:

```
There are several name spaces for variables.  Which one is to be used is
specified by what is prepended:

                 (nothing) In a function: local to a function; otherwise: global
buffer-variable    b:      Local to the current buffer.
window-variable    w:      Local to the current window.
tabpage-variable   t:      Local to the current tab page.
global-variable    g:      Global.
local-variable     l:      Local to a function.
script-variable    s:      Local to a :source'ed Vim script.
function-argument  a:      Function argument (only inside a function).
vim-variable       v:      Global, predefined by Vim.
```

*From* `:help internal-variables`.

So, for example, in your `~/.vimrc`, unless you're in a function, you shouldn't
prefix plugin's options let's say with `g:`, you can just write the variable
name.

```vim
" no
let g:indent_guides_auto_colors = 0

" yes
let indent_guides_auto_colors = 0
```

