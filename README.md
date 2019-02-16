# My blog

```
$ git clone git@github.com:math2001/math2001.github.io
$ git clone git@github.com:math2001/fasty themes/fasty
$ git fetch origin dev
$ git checkout dev
$ hugo new post/some-new-awesome-post.md

# write the post

$ git add .
$ git commit -m "New post!"
$ python bin/deploy.py
```