---
title: "Itp: insert template please"
slug: itp-insert-template-please
date: 2017-09-27T11:18:56+10:00
categories: [cli]
tags: [nodejs, javascript, template]
repository: itp
---

I was getting pretty sick of typing the same `.gitignore`, copy/pasting my
license, README and everything. 

So, I made a tiny template manager, called `itp`, for *Insert Template
Please*.<!--more-->

### Installation

It's on `npm`, so:

```sh
~ $ npm install --global itp
# or if you have yarn
~ $ yarn global add itp
```

### The basics

You put your templates in `~/.templates`. And then, from anywhere, you run:

```sh
~/my/repo $ itp README.md .gitignore
```

And it will insert `~/templates/README.md` and `~/.gitignore` where you are.

### Handlebars

`itp` allows you to use [handlebars][] in your templates. The list of every
variables you have access to is on the [README.md][].

### Tip

If you want to version your templates in your config repository (in my case,
it's `dotfiles`), you can make `.templates` actually be a symlink pointing to
your actual template directory :wink:

### Example

You can have a look at my [dotfiles/templates][] to see some useful templates
:wink:.

Hopefully it'll save you some time!

[handlebars]: https://handlebarsjs.com/
[README.md]: https://GitHub.com/math2001/itp/#variables
[dotfiles/templates]: https://GitHub.com/math2001/dotfiles/tree/master/.templates
