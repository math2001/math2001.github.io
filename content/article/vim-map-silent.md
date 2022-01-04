---
title: Silent command-line mapping
slug: silent-command-line-mapping
tags: [tip, vim, map, command]
date: 2017-08-27
place: From a very warm car
draft: true
---

If you want to set a mapping to run something that is echoed into the command
line (something starting with `:` or `/` for example) to _not_ be displayed, you
can use the special argument `silent`. <!--more-->

```vim
map <silent> <leader>r :MyCommand
```

By the way, <tiplink to="vim-difference-map-noremap.md">you should (almost) always use
`noremap`</tiplink>.

Learn more: `:help :map-silent`
