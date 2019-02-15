---
title: The confirm option
slug: confirm-option-vim
tags: [tip, vim, option]
date: 2017-09-03
---

This is probably one of my favorite option in VIM. Just add this to your `.vimrc`:

    set confirm

<!--more-->

This will affect different command in VIM: instead of just failing (and telling
you to use force if you want to overwrite), it'll show a confirm "popup" at the
bottom and you'll be good to do.

### Quick example

When you want to quit a file that isn't saved, here's what you get:

    E37: No write since last change (add ! to override)

With the `confirm` option on, you get

    Save changes to "tips/vim-confirm.md"?
    [Y]es, (N)o, (C)ancel:

You just need to press the corresponding letter (not even <kbd>enter</kbd>), and
you'll be good to go!

