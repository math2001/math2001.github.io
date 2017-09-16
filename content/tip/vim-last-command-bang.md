---
title: Rerun last command with bang
slug: rerun-last-command-bang-vim
tags: [ vim, vimscript, bang ]
categories: [ cool feature ]
date: 2017-08-27
place: In the car, on a snowy road
---

Put this little vim script in your `.vimrc` to rerun the previous command with
the bang (`!`) by just typing `:Please`.

```vim
function! BangLastCommand()
    " The last command that was run is stored in the register `:` (:registers)
    let lastcommand = split(@:, ' ')
    let command = lastcommand[0] . '! ' . join(lastcommand[1:], ' ')
    execute command 
endfunction

command! Please call BangLastCommand()
```

So, now, if you do:

    :e ~/.vimrc

And you get an error because the current file has to be save, something like:

    E37: No write since last change (add ! to override)

You can just do this:

    :Please

And it'll run

    :e! ~/.vimrc

Pretty cool, hey? You can change the name `Please` to whatever you want, but it
has to start with a capitale letter. Here are a few suggestion:

- `:Sudo`: `command! Sudo call s:RerunBangLastCommand()`
- `:Please!`: `command! -bang Sudo call s:RerunBangLastCommand()`

Have fun!
