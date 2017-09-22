---
title: Live Svg
date: 2017-09-22T18:31:15+10:00
categories: [cli]
tags: [nodejs, svg, preview]
draft: true
repository: live-svg
---

SVGs are awesome. They allow you to make some infinitely resizable images. 

Sometimes, you want to make a complex image, so you use something [Inkscape][],
but sometimes, you just want to make a simple one, so you take a deep breath and
away you go to write a SVG by hand!

So, you open your favorite text editor and your browser, splitting your screen in
half.

- edit
- save
- <kbd>alt+tab</kbd>
- <kbd>ctrl+r</kbd>
- <kbd>alt+tab</kbd>

Picture how fun this workflow would can be when you try to learn to write
`path`'s `d` attribute by hand! 

To not go completely crazy and throw my computer out the window (and because live
preview is just super cool), I wrote a simple CLI in JavaScript that will
automatically refresh your svg in the browser as soon as you save.

[![live svg preview demo](/img/live-svg.gif)](/img/live-svg.gif)

## Installation

To install it, it's super simple:

    $ npm install -g live-svg

Or, if you have `yarn`:

    $ yarn global add live-svg

## Usage

Just run `live-svg`. It'll start a server on `localhost`. Then, you just need to
open `http://localhost/path/to/your/svg.svg`, the path being, of course, relative
to where you started `live-svg` from.

That's basically it! You'll find more informations about usage in the README.

[Inkscape]: https://inkscape.org
