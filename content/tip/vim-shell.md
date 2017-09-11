---
title: Change shell used to run external command in VIM
slug: change-shell-run-external-command-vim
tags: [ vim, shell, bash, windows, sh ]
categories: [ cool feature ]
date: 2017-08-27
place: In a car, with the 4 WD on
---

On windows, the cmd sucks. But if you have sh installed from git-for-windows
for example, you can tell vim to run external commands `:!`.

Add this to your `.vimrc`

```vim
set shell=sh
set shellcmdflag=-c
```

Now, vim won't run external commands like this

    cmd /c "your command"

But like this:

    sh -c "your command"

So, you can now run Unix commands from VIM.

To learn more: `:help 'shell'`
