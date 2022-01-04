---
title: How to combine svgs
slug: combine-svgs
date: 2017-10-08T17:18:21+11:00
tags: [howto, svg, performances, css, nodejs, svgstore]
---

If you want your website to be fast, you should limit the number of http
requests. A great way of doing that is combining your images. If you use SVGS
for your icons and stuff like that, here's how you can combine all your icon in
one big file, and use them in your website!<!--more-->

### How it works

A combined svg would look like this:

```xml
<svg xmlns="http://www.w3.org/2000/svg">
    <symbol viewBox="0 0 20 20" id='circle'>
        <circle cx="10" cy="10" r="5" fill="currentColor" />
    </symbol>
    <symbol viewBox="0 0 100 100">
        <ellipse cx="50" cy="50" rx="60" ry="40" fill="currentColor" />
    </symbol>
</svg>
```

Here's how you use it in your web page:

```html
<style>
p { color: #34495e; }
p svg { width: 2em; vertical-align: middle; }
</style>
<p>
    Do you want to see what a circle looks like? Here's one:
    <svg><use href="combined.svg#circle"></svg>
</p>
```

Which would give you something like this:

<p style="color: #34495e; text-align: center;">
    Do you want to see what a circle looks like? Here's one:
    <svg viewBox="0 0 20 20" width="2em" style="vertical-align: middle;">
        <circle cx="10" cy="10" r="5" fill="currentColor" />
    </svg>
</p>

### Combining your SVGs

You could have fun doing by hand, but there are some tools out there that allow
you to do that in super easily.

You can combine your SVGs by using `gulp` or `grunt` using their `svgstore`
plugin (`gulp-svgstore` and `grunt-svgstore`), but in this case, we'll just use
a simple CLI.

The CLI I use is called [`svgstore-cli`][], and it's a simple npm package.

```sh
$ yarn global add svgstore-cli
$ # or, if you want to wait for at least 3 hours :smile:
$ npm install --global svgstore-cli
```

Awesome! Now you have access to the `svgstore` command in your terminal.

#### Here's the magical comment :tada:

```sh
$ svgstore svgs/*.svg > combined.svg
```

This will load every `.svg` file in the `svgs` directory, *combine* them, and
write this into `combined.svg`.

And there you have it!

[`svgstore-cli`]: https://github.com/svgstore/svgstore-cli