---
title: Deploying a hugo site on GitHub pages
date: 2017-09-23T11:23:45+10:00
categories: [howto]
tags: [hugo, static site, bash, github-pages]
draft: true
---

When you want to deploy a static website built with the fantastic [Hugo][] on
GitHub pages, you don't have 100 of possibilities. A clean one, and an easy one
:smile:.

The easy one is to build your website to the `docs` folder. It's not super clean
though since the source code is on the same branch as the built code. It doesn't
make diffing super great, gives a long output when you commit, you have to build
at every single commit to keep consistent.

You got it, I don't like it.

So, the other solution is to build it on the `gh-pages` branch. I could do it
manually every time, but wasting my time isn't my thing... :smile: No, I wanted
to build something like [mkdocs][] has:

    mkdocs gh-deploy

And boom, it builds your website to an other branch (in this case `gh-pages`),
commit, and push.

So, I tripped a few times along the way of making this little script (life tip:
if you `rm` files automatically, make sure at least 3 times that no files in a
`.git` folder gets delete :wink:, you'd loose **everything**)

### Installation

Just download [this
script](https://GitHub.com/math2001/math2001.GitHub.io/blob/dev/deploy.sh).

### Usage

In your hugo config, add a `publishBranch` key with the name of the branch you
want. It should be a string.

Then, you just need run the script you just downloaded, and it'll build, commit,
and push for you!

---

This script does some weird stuff due to git submodules not coping very well with
branches in the parent repository. When you `checkout`, the submodules don't get
removed/added, you need to do it manually. If you have submodules in your
website's sources elsewhere than in your theme folders (`themes` by default),
you'll need to tweak this script a bit.

[Hugo]: https://gohugo.io
[mkdocs]: https://www.mkdocs.org
