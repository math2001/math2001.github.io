---
title: Current buffer only mapping
slug: current-buffer-only-mapping-vim
tags: [tip, vim, map, buffer]
date: 2017-08-27
place: In a stopped car
draft: true
---

If you want to set a mapping only for the current buffer in VIM, it's super
simple: just use the `buffer` special argument.<!--more-->

```vim
nnoremap <buffer> ,tip call InsertTipYamlFrontMatter()
```

Learn more: `:help :map-local`
