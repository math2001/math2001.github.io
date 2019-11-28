---
title: Lessons learned from rewriting MarkdownLivePreview
slug: lessons-learned-from-rewriting-markdownlivepreview
date: 2019-11-16T07:31:40+11:00
tags: [ python, sublime text, concurrency ]
draft: true
---

This blog post is quite long, and it's made of three parts:

1. Why I rewrote MarkdownLivePreview
2. Fetching images from the internet efficiently for the preview
3. How to update the preview in general.

### Why I rewrote MarkdownLivePreview

> [MarkdownLivePreview][github] is a plugin to preview markdown files within
> Sublime Text itself

As you might have seen in the previous README, I had written that I was not
going to be maintaining this project anymore, because it took to much time and
since I did not use this plugin myself much, I didn't have the energy to
maintain it.

However, I started to become [interested in concurrency][nine43], and really
liked thinking about the different problems and patterns that were used in
concurrent programs. An issued I had noticed whilst developing
MarkdownLivePreview was that images, once they had finished loading, didn't
trigger an update of the preview, and hence the user would have to put in some
manual keystrokes to see the preview. I had the idea of adding a callback in
the image loader, but because the code base was so messy and unorganized, it
was a pain, so I ended up never implementing it.

However, having now gained a little experience in concurrency (just enough to
start enjoying the different problems), I noticed that this issue needed a
concurrent solution (I mean, loading images off the internet is like the 101
problem). So, I decided that, after my HSC (final exams before university in
Australia), I would rewrite this whole package and implement a neat solution to
this classic issue.

Turns out, it's done really easily with Python, but another concurrent problem
was waiting for me. So, here I go about solving them as efficiently as I can
with the tools I got. Fun times!

### Fetching images from the internet efficiently

> FIXME: write me!!

### How should the preview be updated?

The flickering comes from updating the phantoms too much. Therefore, we need to
make sure that not too many updates happen too quickly. How can we do that?

#### Require `DELAY_BETWEEN` seconds between each update

We can throw away updates which are too close (too soon) after the last update,
something like this:


```python
last_update = 0

def update():
	if time.time() - last_update < DELAY:
		return

	last_update = time.time()

	# do the update
```

This is really good, because it's super simple and fast (just number
comparisons, no threads), but it has a major problem: it often discards the last
modification(s).

In this plugin's case, that means that an update is triggered because the user
is typing, then the user types a few more characters and stops to look at the
preview. The problem is that the last characters haven't triggered an update,
because they were too close to the last one, and hence the user doesn't see the
matching preview (just a older version, which is less than `DELAY` seconds old).

How can we remedy this?

#### Delaying

We can use the previous solution, and add little tweak: when the user presses
a key, we don't *try to* update straight away (remember, we might not do
anything if the last update is too close), but wait `DELAY` seconds.

Now this simple modifications makes it a lot harder to think about (at least for
me).

> FIXME: this is extremely unclear.

Why does it solve our problem? Because when the user presses the last few
keystrokes, the update will run *later*, hence it will use the final version.
And it is guaranteed to use the final version because the keystrokes it can
miss will be in a time interval of `DELAY` seconds, and we only update *after*
`DELAY` seconds.

And this solution can get

#### Queue up updates

We would have two threads:

1. One loop spinning one turn per `DELAY`, and checking a shared variable,
   `need_update`. If it is set to `True`, then preview is updated, and
   `need_update` is set to `False`. Otherwise, nothing happens.
2. On each keystroke, we set `need_update` to `True`.

Hence, hitting a lot a keystrokes quickly will not trigger anymore updates,
and updates will only occur at a controlled speed.

> FIXME: actually try this solution

[github]: https://github.com/math2001/MarkdownLivePreview
[nine43]: https://github.com/math2001/nine43
