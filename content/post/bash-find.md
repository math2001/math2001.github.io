---
title: Bash Find
date: 2017-09-24T07:51:15+10:00
categories: [itsbuiltin]
tags: [bash, find, file manupilation]
draft: true
---

The `find` command in bash is quite powerful, and knowing the basics might save
you some scripting.

What does it do? It "finds" files. You can apply some "filters" and it outputs
their relative path.

For example, with the following structure:

```
dist
├── app.js
├── index.html
└── style.css
``````

```
$ find
.
./app
./app/app.js
./app/index.html
./app/style.css
./dist
./dist/app.js
./dist/index.html
./dist/style.css
```

It lists every folder and files recursively.

### Tests

Some of `find`'s power comes from it's ability to *filter* which files and folder
it "selects". They are called *tests*. So, here are some of them:

#### `-type`

```
$ find -type f
./app/app.js
./app/index.html
./app/style.css
./dist/app.js
./dist/index.html
./dist/style.css
$ find -type d
.
./app
./dist
```

Here, the filter is `-type`. You guessed it, `f` is for `file` and `d` for
`directory`. [More about `-type`][-type]

```
f - files
d - directory
```

##### `-name`

```
$ find -name "*.js"
./app/app.js
./dist/app.js
$ find -name "*.JS"
$ find -iname "*.JS"
./app/app.js
./dist/app.js
```

`-name` takes a glob. The `-iname` variant is case insensitive. [More about `-name`][-name]


#### `-path`

This is the exact same as name, except that it doesn't only apply on the
filename, but the whole path (the path that would be outputted). Unlike `-path`
though, `*` will match both `/` and leading dots in filename

Same, you have `-ipath` for a case *insensitive* version of it. [More about
`-path`][-path]

Note: `-wholename` is the same as `-path`, but `-path` is more portable.

### Combining test

You can add multiple tests to filter the items you select. For example:

```
$ find -name "*.js" -type f
./app/app.js
./dist/app.js
```

Pretty straight forward, right? You select items that finish with `.js` *and* that
are a file. `find -name "*.js" -and -type f` is the exact same!

The default *operator* is `-and`. What if you want `.js` and `.css` files? You
use the `-or` operator:

```
$ find -name "*.js" -or -name "*.css" -type f
./app/app.js
./app/style.css
./dist/app.js
./dist/style.css
```

Again, this is the same as `find -name "*.js" -or -name "*.css" -and -type f`.

`-o` is an alias for `-or`, just as `-a` is an alias for `-and`

If you want every files that do *not* end with `.js`, you can do:

```
$ find -not -name "*.js" -type f
./app/index.html
./app/style.css
./dist/index.html
./dist/style.css
```

The `-not` only applies to the first next test, not the other ones. `!` is an
alias for `-not` but you will probably need to escape it or quote it so that your
shell doesn't interpret it. That's why I prefer to use `-not`.

> Everything returns a boolean except for operators

So, for each file `-name "*.js"` for example will return `true` or `false`,
depending whether the file matches or not. The file is "selected" depending on
whether everything combined returns true. This might seems obvious, but I just
needed to make sure this was clear before we moved on, we're going to need it
:wink:.

[More about combining test][-combining]

### Actions

Now, printing out the filenames if fun, doing some stuff with them is even
better! And guess why it actually prints out the filenames: because the default
action is `-print`!

Just as the tests, actions **return a value** too. Remember this.

```
$ find -type f -print
./app/app.js
./app/index.html
./app/style.css
./dist/app.js
./dist/index.html
./dist/style.css
```

It's exactly what you'd expect, right?

#### `-delete`

`-delete` is a pretty useful action (watch out though: it doesn't through what it
deletes to the bin, it *actually* deletes them, like `rm`).

If you want to delete every temporary file created by vim (files that end with
`~`), you can just run this:

```
$ find -name "*~" -delete
```

Gone! Every temp files are gone!

What I recommend you do before this is run just `find -name "*~"` so that you see
which file are going to be deleted when you run `find -name "*~" -delete`.

#### `-exec`

If you want to do some more complex things though, you might want to use the
action `-exec`.

This action takes an undefined number of parameters representing a command that
it's going to run on *every* selected files. It stops "consuming" arguments as
soon as it sees a `;`. Note that `{}` will be replace with file's path. So,

```
$ find -name "*~" -delete
$ # does the same thing as
$ find -name "*~" -exec rm {} \;
```

Note: as you can see, we need to escape the `;` to prevent bash from interpreting
it.

##### Optimizing

It's better to run one command on multiple files than multiple commands on one
file each time. For example, the first one is better:

```
$ rm 1.jpg 2.jpg 3.jpg
```

```
$ rm 1.jpg
$ rm 2.jpg
$ rm 3.jpg
```

If course, it depends on the command, but `find` gives you the possibility of
doing the first thing in your `-exec` actions. It'll automatically adapt to the
maximum command line length of your system. 

In order to do that, you have to use `{} +`, like so:

```
$ find -name "*~" -exec rm {} +
```



Back to our example with `~` files. 

[-type]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Type
[-name]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Base-Name-Patterns
[-path]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Full-Name-Patterns
[-combining]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Combining-Primaries-With-Operators

