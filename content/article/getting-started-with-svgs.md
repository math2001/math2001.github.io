---
title: Getting started with svgs
slug: getting-started-with-svgs
date: 2017-10-10T17:55:27+11:00
tags: [introduction, svg, image, vector ]
draft: true
---

Have you heard about SVGs? What are they? Here's a quick introduction to this
fabulous format.<!--more-->

SVG stands for Scalable Vector Graphic. And, it's an other format of image, just
as you have PNG, JPG, etc...

The great thing about it is that doesn't store pixels, but shapes. The advantage
of this is that it's infinitely re-sizable. If know you have a circle that has
its center at 20% horizontally, 40% vertically and that it's radius is 5% (the
percentage being relative to the image size), you can draw it as big as you
want, it'll always be as detailed!

SVG can do much more than just circles of course, but that's the idea. If you
know the shape of something, be it huge tiny, you'll always be able to draw it
with the same precision on your screen (not you, eh, you computer :wink:).

### The format

The format for svgs is just `xml`! That means you can edit them by hand (as
long as they are simple svgs, unless you want to get your brain to crash
:smile:).

Here's a simple svgs that just displays a blue circle that takes the full width
and
the full height

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
    <circle cx="5" cy="5" r="5" />
</svg>
```

The `svg` tag, you guessed it, is the main attribute into which all the code for
your svgs goes. Let's look at it's attribute:

- `xmlns`: that's just something that's required (sometimes it isn't though,
you'll see when :wink:)
- `viewBox`: that's important. This attribute defines the position and size of
your canvas. `0 0` is the top left corner, and `10 10` is the bottom right
corner. So, if you change this, your image will be completely deformed!

Note: SVGs are unit less! It's just a question of percentage depending on which
size you want your image to be when it's rendered.

So here, we have a square sheet of 10.

#### Let's draw!

`<circle>` draws a circle, using 3 attributes: the coordinates of its center,
and its radius. In this case, the coordinates of its center are `5` and `5`
(horizontally and vertically from the top left corner, as usual). That's the
equivalent of the middle of our canvas. And its radius is `5` (radius, not
diameter :wink:).

Here it is:

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <circle cx="5" cy="5" r="5" />
    </svg>
</p>

Note: all the demos have a grey border, so you can see the canvas size. It isn't
included by default by the SVG of course.


### A bit of customization won't hurt...

#### Bring some joy!

Now, let's give it a bit of color, shall we? This circle looks pretty sad to
me. :slightly_frowning_face:

We can specify a `fill` attribute on our `circle` tag which will fill our
circle!

```xml
<circle cx="5" cy="5" r="5" fill="#E74C3C" />
```

Note: I'm not writing the whole thing again, just remember you need to outer
`svg` for it to work :slightly_smiling_face:

And this time, we get:

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <circle cx="5" cy="5" r="5" fill="#E74C3C"/>
    </svg>
</p>

#### "Stroke" you said?

What if we want to give it a border, hey? Well, in svgs term, that's called a
*stroke*. And in order to add one, it's as simple as saying `stroke="color"`
:smile:

```xml
<circle cx="5" cy="5" r="5" fill="#E74C3C" stroke="#3498DB" />
```

And here's how that looks:

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <circle cx="5" cy="5" r="5" fill="#E74C3C" stroke="#3498DB" />
    </svg>
</p>

Oh no!! What happen to it? Isn't the stroke suppose to be even?

Yes, it should, and it *is*. It's just that the stroke *adds* up to the width of
the circle. And our canvas has a size of 10 units, and our radius is `5` (so,
our diameter is `10`), so we don't have enough room on the sides of our canvas
to fit the stroke!

We have to option: make the canvas bigger, or make the circle smaller. Let's go
with the second one.

```xml
<circle cx="5" cy="5" r="3" fill="#E74C3C" stroke="#3498DB" />
```

The radius is now 3 units, instead of 5. This time, we get:

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <circle cx="5" cy="5" r="3" fill="#E74C3C" stroke="#3498DB" />
    </svg>
</p>

> But, the border's too thick! How can I make it thiner?

Using the `stroke-width` attribute! If you don't specify it, it will take the
value of 1 unit.

```xml
<circle cx="5" cy="5" r="3" fill="#E74C3C" stroke="#3498DB" stroke-width=".5" />
```

Note: like in CSS, you can write `.5` instead of `0.5`. It saves you one
keystroke, and makes you look cool :sunglasses:

The result:

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <circle cx="5" cy="5" r="3" fill="#E74C3C" stroke="#3498DB" stroke-width=".5" />
    </svg>
</p>

### Other shapes?

SVG allows you do to plenty of other shapes, like rectangles, ellipses,
polygon, etc... Here are a few examples

#### Rectangles

[→ MDN documentation](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/rect)

```xml
<rect x="1" y="1" width="3" height="3" fill="#F1C40F" />
<rect x="5" y="3" width="4" height="3" rx=".5" ry="1" fill="#1ABC9C" />
```

You give its top left corner position (`x` and `y`), its size (`width` and
`height`), if you want to, the radius for the corners (`rx` and `ry`). 

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <rect x="1" y="1" width="3" height="3" fill="#F1C40F" />
        <rect x="5" y="3" width="4" height="3" rx=".5" ry="1" fill="#1ABC9C" />
    </svg>
</p>

#### Polygons

[→ MDN
documentation](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polygon)

```xml
<polygon points="1,1 7,2, 9,6, 6,9 3,6" fill="none" stroke="#8E44AD"
         stroke-width=".5" />
```

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <polygon points="1,1 7,2, 9,6, 6,9 3,6" fill="none" stroke="#8E44AD"
        stroke-width=".5" />
    </svg>
</p>

#### The ultimate element

Sometime, you want to really weird shape (say I told you to make a car). You
can't just use circles and rectangles. You have to use something different. And
that is: `path` :tada:

`path` takes an attribute `d` which might look like absolute jibberish, but it's
basically a set of movement (not going to get into the details of it here
though). Most of the time, you'd want to use a SVG editor to this kind of stuff.
But, as usual, here's a quick example:

<figure>
    <img src="http://jakearchibald.github.io/svgomg/test-svgs/car-lite.svg">
    <figcaption>From <a href="http://jakearchibald.github.io/svgomg">SVGOMG</a>,
    an svg optimizer GUI based svgo</figcaption>
</figure>

### We're all the same!

As you probably understood, there are some *global* attributes, and some
*specific* attributes. For example, `fill` is a global one, and `r` is a
specific one to the `circle` tag.

What if you want to apply some global attributes to more than one element that
all have to same value? That's when the `g` tag comes in.

```xml
<g fill="#e74c3c">
    <circle cx="3" cy="3" r="2" />
    <circle cx="5" cy="7" r="1" />
    <circle cx="8" cy="8" r="1" fill="#3498db" />
</g>
<circle cx="7" cy="2" r="1.5" fill="#2ecc71" />
```

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <g fill="#e74c3c">
            <circle cx="3" cy="3" r="2" />
            <circle cx="5" cy="7" r="1" />
            <circle cx="8" cy="8" r="1" fill="#3498db" />
        </g>
        <circle cx="7" cy="2" r="1.5" fill="#2ecc71" />
    </svg>
</p>

Cool, right? You can specify a some options to a group (`<g>`), and still
overwrite them for specific elements.

**Pro tip**: You can create nested groups :wink:

### CSS with SVG? No way!

Guess what? You can use **CSS with SVG**! For starters, general attributes that are used for styling (like `fill`, `stroke`, `stroke-width`, etc...) can be specified in a `style` attribute using the CSS syntax. 

```xml
<circle style="fill: #f1c40f; stroke: #d35400; stroke-dasharray: 3,2;" cx="5" cy="5" r="4" />
```

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <circle style="fill: #f1c40f; stroke: #d35400; stroke-dasharray: 3,2;" cx="5" cy="5" r="4" />
    </svg>
</p>

I don't really like this way of doing this though, since it's more verbose. The
good part about this comes now:

You can use an actual `style` tag in your svg. For example:

```xml
<style>
circle {
    fill: #1abc9c;
    stroke: #f1c40f;
    stroke-width: .5;
}
</style>
<circle cx="5" cy="5" r="3" />
```

<p style="text-align: center;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
        <style> circle { fill: #1abc9c; stroke: #f1c40f; stroke-width: .5; } </style>
        <circle cx="5" cy="5" r="2" />
    </svg>
</p>

Again, this is *inside* your big `svg` tag!

### Web + SVG = :hearts:

There is two way of including a SVG into a web page: using a regular `img` tag,
like so:

```html
<img src="myimage.svg">
```

Or using the `svg` tag. This solution as the advantage of making the SVG taking into
account the CSS of the *web page*!

You heard right! You can insert an SVG's code straight into your web page (and in this
case you don't even need to `xmlns` attribute). Let's take an example:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My SVG inside my web page!</title>
    <style>
        ellipse {
            fill: #27ae60;
        }
    </style>
</head>
<body>
    <h1>My SVG inside my web page!</h1>
    <svg viewBox="0 0 100 100">
        <ellipse cx="50" cy="50" rx="40" ry="50" /> 
    </svg>
</body>
</html>
```

<style>
.page-content svg {
    outline: 1px solid #888;
    width: 100px;
    height: 100px;
}
</style>
