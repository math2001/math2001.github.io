---
title: "'readonly' != 'modifiable'"
slug: difference-vim-options-readonly-modifiable
tags: [vim, options]
date: 2017-08-26
place: In the car, on the way back from x-ski
draft: true
---

Do you know the difference between the option `readonly` and `nomodifiable` in
vim?<!--more-->

All the `readonly` does, when enabled, is it prevents you from _writing_ the file
(you can bypass it by doing `:w!` though), while `modifiable`, when _disabled_
prevents you from actually _editing_ the buffer.
