---
title: Bash's fc command
slug: bashs-fc-command
date: 2017-09-26T18:03:22+10:00
tags: [tip, bash, editor]
---

When editing long commands in your terminal (you know, the one that wraps
:wink:), sometimes you'd be better of using your actual editor (like vim or
Sublime). And guess what? Bash let's you do that! :tada:<!--more-->


First, you need to set your `$EDITOR` environment variable. It's just a little
`export EDITOR=<cmd>` in your `.bashrc`.

Here are the command you need to replace `<cmd>` with for different editors:

| Editor       | Command       |
|--------------|---------------|
| vim          | `vim`         |
| Sublime Text | `subl -w -n`  |
| Atom         | `atom --wait` |

If you use `vim`, just replace `<cmd>` with `vim`. For Sublime Text, it'd be
`subl -n -w`.

You'll need to restart your terminal or `source ~/.bashrc`

To check that it's right:

```bash
~/some/where $ echo $EDITOR
<cmd>
```

### Edit current command

Now, let's say you started writing a chain of command like this

```bash
~/some/where $ ps -A | grep ssh-agent | grep 
```

But then you realize you'd like to write this in your editor, with all your
shortcuts and everything.

Just press <kbd>ctrl+x+e</kbd>!

Now, you editor opens up with the bit of command already typed in already there
in your editor.

And now, as soon as you save and quit your editor, the command will be run!

### Edit previous command

If you want to write the command you run just before in your editor, just do
this:

```bash
~/some/where $ fc
```

Same thing, as soon as you'll save and quit your editor, it'll run the command.
