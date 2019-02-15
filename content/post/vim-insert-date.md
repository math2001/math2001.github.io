---
title: How to insert the date in Vim?
slug: how-to-insert-the-date-in-vim
tags: [tip, vim, date, strftime]
date: 2017-08-20
---

First off, I really don't recommend you use the `strftime()` function vim has,
since, as it says in the help message (`:help strftime`)

> The accepted {format} depends on your system, thus this is not portable!

So, a somewhat better solution is to use the `date` shell command. Yes, it seems
even less portable, but at least you know for sure if it's going to work or not
(with `strftime()`, I don't know if vim could get mixed up about the OS when you
use a simulate a Unix environment in your terminal)

```sh
$ date +"%A %d %B %Y @ %H:%M"
Sunday 20 August 2017 @ 11:11
```

So, now, you just need to add this to your `.vimrc`

```vim
function! Insert(text)
    " a simple function to insert text where the cursor is
    execute "normal! \<Esc>a".a:text
endfunction

function! Strip(text)
    return substitute(a:text, '^\_s*\(.\{-}\)\_s*$', '\1', '')
endfunction

command! InsertDate :call Insert(Strip(system('date +"%A %d %B %Y @ %H:%M"')))
```

All you need to do now is:

```
:InsertDate
```

And, you'll get the date inserted automatically.

If you want to customize the format of the date, I'd recommend using a tool like
[strftime.net](https://strftime.net).

