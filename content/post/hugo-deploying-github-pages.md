---
title: Deploying a hugo site on GitHub pages
date: 2017-09-23T11:23:45+10:00
categories: [howto]
tags: [hugo, static site, bash, github-pages]
draft: true
---

If you don't already know it, [Hugo][] is a super fast static website generator, written in [golang][]. 

Of course, you'll get to a point where you want to publish your website. Super
easy! You just need to run `hugo` in your website directory, and you'll get a
`public` directory containing your website, ready to be published!

If, like me, you decided to host it on github pages, you just need add this to
your configuration file:

```yaml
pusblishDir: docs
```

And hugo will put your website in a directory called `docs` instead of `public`.

Then you just need to set your GitHub pages source to be the `docs` folder in
your repository settings, and then run `git push` and your website's up and
running!

Now, that works perfectly fine. It's not super awesome though, the build and the
source code are on the same branch. It makes diffing *a lot* more fun (I'm trying
to be sarcastic here :smile:), and it isn't super clean in my opinion.

What I wanted to have was a branch with the source code, and a branch with the
dist.

GitHub allows you to do that since you can set your pages source to be from the
`gh-pages` branch instead of the `docs` folder.

So, on `master`, the source, and on `docs`, the website.

I'm not crazy, I didn't want to do that by hand, I wanted to make a little script
that would deploy everything for me. Basically, here's what it'd do:

1. Build my website into a temporary folder *out of the current repository*
2. Checkout on my publish branch (in this case, `gh-pages`)
3. Update my repository from the temporary folder
4. Commit (and eventually push)

Doesn't seem to hard, right? There are few tricks along the way though, here they
are:

### "Update my repository from the temporary folder", you said?

At first, I thought a simple `mv $TEMP/* .` would do the trick, but what if you
delete a post in the source? With `mv`, it wouldn't get erased in the build, and
therefore still appear on your website! Furthermore, it has troubles overwriting
existing directory.

So, `rm -rf *` before `mv $TEMP/* .`? No!! You'll remove the `.git` folder do,
and bye bye your sources!

So, you need to remove everything except the `.git` folder. So, something like
this should work:

```bash
# remove every file in the not in .git/
find -not -path "./.git*" -delete -type f
# remove every empty folder
find -not -path "./.git*" -depth -type d -empty -exec rmdir {} +
```

I thought that'd be enough to. But no. `git submodules` don't play very well with
branches in the parent repository. 

If you don't know what git submodules are, they're just repository *inside*
repository.

Git cannot delete them when you switch branches (which is understandable). So,
the submodules are present in every branches.

> Why would you use this submodule thingy, though?

For the themes. You need to put your theme in the `themes` directory and the
active it in your config. You install a theme like this:

```bash
$ #              -> the url                               -> where to download it
$ git submodule add https://github.com/someone/awesome-theme themes/awesome-theme
```
In this case, it's bad since you don't want your theme folder with the layouts
and everything to be up on your website.

> ?? Why don't you just `git clone` it inside? It should work, no?

Yes, it does when you have no intention of tweaking the theme. In my case, it
wasn't right since I'm using my own theme. If you `git clone`, you'd be
versioning a repository inside a repository I think, and it's not great.

### So, the solution?

The solution is to still use the git submodules, but make sure they aren't
committed on the publish branch (make sure they're not in the index). An other
little trick is to make sure you don't delete the theme's directory on the
publish branch, since because it isn't managed by git, you'll delete it for good,
*on every branches*.

Also, to make everyone's life easier, we ignore the whole `themes` folder, not
every theme separately (so every subfolder in `themes`).

And, [the solution][] is just ~ 50 lines long!

Here's how it works:

In your hugo configuration file, make sure you specify `publishBranch: ` plus
whatever you want it do be. It needs to be an exiting branch, though. Here's how
you can create it:

```
$ git checkout --orphan <your branch>
$ git reset --hard
$ git commit --allow-empty -m "Initial commit"
```

Creating an `orphan` branch means it doesn't have any commits by default. You
need to do a `git reset --hard` because by default, every files are the previous
branch will be added to the git index (which is pretty stupid in my opinion, but
anyway). And then, you commit with the `--allow-empty` flag because no file will
be actually committed (and at least one commit needs to be on a branch for it to
exists).

No, you just need to run `./deploy.sh`. It'll build your website, "move" it to the
publish branch, commit, push, and get back to the origin branch.
