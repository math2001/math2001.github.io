---
title: The Last Terminal Title
slug: the-last-terminal-title
date: 2018-02-04T15:07:11+11:00
tags: [tip, bash, terminal]
---

![ls@asyncio   vim@math2001.github.io   git@dotfiles](/img/tmux-title.png)

I use tmux, and in the tabs title, it displays the terminal's title, which is
just done by this 2 lines in your `.tmux.conf` <!--more-->

```
setw -g window-status-current-format ' #{pane_title} '
setw -g window-status-format ' #{pane_title} '
```

What should you display in the tabs in your opinion? For me, it's obvious: the
last command that I ran, and the location. Now, we can't display the whole path,
but just the current folder name does perfectly the job. It'd be something like
`vim@math2001.github.io`.

And I tried this a fair while ago, but didn't succeed (it was super slow,
because you have to re-compute it every time).

But, today, I find a super simple (and fast) solution.

### The last command

To get the last command, we use bash's history, like so:

```bash
history | awk '{END print $2}'
```

This might look a bit complex if you don't know awk, but all it does is take the
history of commands, take the last line only (because of the `END`), and print
the second word (the second field for the purists :smile:), which is the
command.

### The location

Now, we want the folder name, which we can easily get from the environment
variable `$PWD`.

```bash
~/some/place $ echo ${PWD/*\//}
place
```

This is fairly simple: the `*` matches any character, and because there is a `/`
after it (which we have to escape), it only stops when it finds a forward slash.
Because by default `*` is greedy (meaning it wants to match as many character as
possible), it leaves us with the current folder name.

### Into our `.bashrc`

Now, here's how you plug it in your `.bashrc`:

```bash
function window_title {
    echo -ne "\033]0;$(history | awk 'END {print $2}')@${PWD/*\//}\007"
}

function my_custom_prompt {
    window_title
    # your prompt code
}

PROMPT_COMMAND=my_custom_prompt
window_title
```
