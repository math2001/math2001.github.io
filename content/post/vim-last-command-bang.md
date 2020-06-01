---
title: Rerun last command with bang
slug: rerun-last-command-bang-vim
tags: [tip, vim, vimscript, bang]
date: 2017-08-27
place: In the car, on a snowy road
draft: true
---

Put this code in your vimrc to re run the previous command but with the bang
(`!`) by just typing `:Please`. <!--more-->

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
