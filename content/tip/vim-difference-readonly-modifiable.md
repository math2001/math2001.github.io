---
title: The difference between the VIM options 'readonly' and 'modifiable'
slug: difference-vim-options-readonly-modifiable
tags: [ vim, options ]
categories: [ infos ]
date: 2017-08-26
place: In the car, on the way back from x-ski
---

All the `readonly` does, when enabled, is it prevents you from *writing* the file
(you can bypass it by doing `:w!` though), while `modifiable`, when *disabled*
prevents you from actually *editing* the buffer.
