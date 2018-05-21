# My blog

I just blog that often I can't remember how to:

## Clone

```bash
# the basics
$ git clone git@github.com:math2001/math2001.github.io

# Get the dev branch, so you can actually write the post in markdown
$ git fetch dev

# don't forget the themes, cause you ain't seeing shit otherwise
$ git submodule update --init
```

## Post

```bash
$ hugo new post/your-title.md
# "Publishing a post" should be :outbox_tray:
# "Drafting a post" should be :writing_hand:
$ git commit
$ ./deploy.sh
```

Nice and simple. See you on my blog :)
