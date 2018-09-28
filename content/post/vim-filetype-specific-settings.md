---
title: Vim file type specific settings
slug: vim-filetype-specific-settings
date: 2018-09-28T15:25:33+10:00
categories: [tip]
tags: [vim, filetype]
---

If you want to run some vim script for a specific file type, don't make an
auto command. They get messy really quickly.

Just edit `~/.vim/ftplugin/<filetype>.vim`.

> `ftplugin` stands for file type plugin

To get the file type of the current file, just do:

```
:set filetype?
```

It'll be automatically sourced when you open a file of that specific type.

### Edit matching file

Most of the time, you'll find yourself wanting to edit the ftplugin file of the
current filetype. So, here's a quick command to do this:

```vim
command! -nargs=? Ftedit execute "tabe ~/.vim/ftplugin/" . ("<args>" == "" ? &filetype : "<args>") . ".vim"
```

If you just type `:Ftedit`, it'll open the ftplugin of the *current* file.
But it you give it an argument, it'll open the one with the given name.

```
:set filetype?
python
:Ftedit
" opens ~/.vim/ftplugin/python.vim
:Ftedit vim
" opens ~/.vim/ftplugin/vim.vim
```

Enjoy :smile:
