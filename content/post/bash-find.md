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
```

```bash
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

```bash
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

#### `-name`

```bash
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

### Combining test – operators

So, everything returns a value (except operators of course). A test returns true
if it matches (`-name "*.js"` returns true for `app.js`, but not `index.html`).
You can conjugate everything with operators.

Every operators only applies to the next expression. So, `expr1 or expr2 and
expr3` is the same as `(expr1 or expr2) and expr3`.

#### `-and`

```bash
$ find -name "*.js" -type f
./app/app.js
./dist/app.js
```

Pretty straight forward, right? You select items that finish with `.js` *and*
that are a file. You can guess the operator `-and` is the default one. Therefore
`find -name "*.js" -and -type f` is the exact same!

#### `-or`

What if you want `.js` and `.css` files? You can use the `-or` operator:

```bash
$ find -name "*.js" -or -name "*.css" -type f
./app/app.js
./app/style.css
./dist/app.js
./dist/style.css
```

Again, this is the same as `find -name "*.js" -or -name "*.css" -and -type f`.

#### `-not`

If you want every files that do *not* end with `.js`, you can do:

```bash
$ find -not -name "*.js" -type f
./app/index.html
./app/style.css
./dist/index.html
./dist/style.css
```

#### Grouping

Of course, you can group stuff together. Here, we find every file that finishes
by `.js` or any directories.

```bash
$ find \( -name "*.js" -type f \) -or -type d
.
./app
./app/script
./app/script/app.js
./app/style
./dist
./dist/app.js
```

Again, you might have to escape the brackets (it's so that it looks cool :rage:)

#### Comma `,`

Separates 2 expressions: it evaluates both of them, but only returns the value of
the second one.

```
$ find -name "whatever" , -name "*.html"
./app/index.html
./dist/index.html
```

This will become handy when we'll use `-prune`.

#### Aliases

You can use some aliases, although I don't recommend doing so, they aren't as
clear:

```
-o = -or
-a = -and
! = -not (you'll need to escape it though, like so \!)
```

[More about combining test][-combining]

### Actions

Now, printing out the filenames if fun, doing some stuff with them is even
better! And guess why it actually prints out the filenames: because the default
action is `-print`!

Just as the tests, actions **return a value** too. Remember this.

```bash
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

```bash
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

```bash
$ find -name "*~" -delete
$ # does the same thing as
$ find -name "*~" -exec rm {} \;
```

Note: as you can see, we need to escape the `;` to prevent bash from interpreting
it.

##### Optimizing

It's better to run one command on multiple files than multiple commands on one
file each time. For example, the first one is better:

```bash
$ rm 1.jpg 2.jpg 3.jpg
```

```bash
$ rm 1.jpg
$ rm 2.jpg
$ rm 3.jpg
```

If course, it depends on the command, but `find` gives you the possibility of
doing the first thing in your `-exec` actions. It'll automatically adapt to the
maximum command line length of your system. 

In order to do that, you have to use `{} +`, like so:

```bash
$ find -name "*~" -exec rm {} +
```

Note that `{} +` has to be at the *end* of the command. [More about
optimizing][optimizing]

### Tips and tricks

#### `-maxdepth`

> Descend at most levels (a non-negative integer) levels of directories below the
> command line arguments. ‘-maxdepth 0’ means only apply the tests and actions to
> the command line arguments.

#### `-depth`

The `-depth` option makes `find` list folders *content* before itself.
The `-depth` options makes find start move from the *bottom* to the *top* instead
of the opposite. T

Note: the `-delete` action implies `-depth`

#### `-prune`

The `-prune` action allows you to prevent `find` from going into a directory that
matches some tests. Weirdly enough though, it returns `true` when it found a
directory to ignore. For example:

```bash
$ find -name "app" -prune -or -print
.
./dist
./dist/app.js
./dist/index.html
./dist/style.css
```

You need to `-or` operator since `-prune` is true when it **excludes** a
directory. It is false when it doesn't.

##### Gotcha

The problem is that it doesn't play well with `-depth`. It actually doesn't work,
have a look:

```bash
$ find -depth -name "app" -prune -or -print
./app/index.html
./app/script/app.js
./app/script
./app/style/style.css
./app/style
./dist/app.js
./dist/index.html
./dist/style.css
./dist
.
```

Remember: `-delete` implies `-depth`. Therefore, DO NOT USE `-prune` with
`-delete`. Instead, do it manually with `-path`:

```bash
$ find -depth -not -path "*app*"
./dist/index.html
./dist/style.css
./dist
.
```

Ok, I guess that's it! If you want to learn even more, have a look at the [documentation][]  Hope it'll save you some time. If it does, please share
this post!

[-type]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Type
[-name]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Base-Name-Patterns
[-path]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Full-Name-Patterns
[-combining]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Combining-Primaries-With-Operators
[optimizing]: https://www.gnu.org/software/findutils/manual/html_mono/find.html#Multiple-Files
[documentation]: https://www.gnu.org/software/findutils/manual/html_mono/find.html

