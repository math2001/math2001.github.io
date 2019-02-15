---
title: So binary numbers are useful?
slug: so-binary-numbers-are-useful
date: 2017-10-13T16:14:21+11:00
categories: [ cool feature ]
tags: [ binary, python, binary, bit-manipulation ]
commentsIssueId: 4
---

Do you know what binary numbers are? They're just a way of counting with just 2
numbers: 0 and 1. For example, `9` is in binary `1001`.

This is the format your computer uses to do everything, at a very low level.
Either there is some current, or there isn't. And then, it interprets these
numbers, and becomes what it is.

So, what the heck could be the use of binary numbers to us, simple programmers
who write some code with all these different symbols, letters, and numbers?
:thinking:

One use case I stumbled upon a few days ago (I was making a little Sublime Text
plugin, textwidth) was passing multiple flags just through a number. Basically,
you'd give the function a cursor position, and it'd tell you if you were at the
end of a word, at the end of a line, at an opening bracket, etc...

This made me realize that you can pass a lot more information than we'd think
through a simple number.

Sound's interesting? Let's get going. :rocket:

### Binary (base 2) and regular numbers (base 10)

(If you already know how to count in binary, then you can skip this section)

Regular numbers as I'll call them, are in base 10, meaning we have 10 different
figures (0, 1, 2, 3, 4, 5, 6, 7, 8 and 9) to represent them. Base 2 just uses
the first 2 figures (0 and 1).

Note: an other common base is base 16, or hexadecimal. The figures are (0, 1, 2,
3, 4, 5, 6, 7, 8, 9, a, b, c, d, e and f). So, for example, 15 is in hexadecimal
`e`.

> What?! How the heck are we suppose to count with only 2 numbers?

It's fairly simple once you get it. But first we must understand how we *count
with regular numbers*.

If I ask you what is the result of `5 + 1`, you'll just tell me `6`. You just
*increased* the last figure by one.

But what if I tell you to do `9 + 1`?

There isn't any figure after `9`, so you have to replace it with a 0, and
increase the number *before* it. In this case, it's a 0 (it's implied here, 09
is the same as 9). This gives you 10.

And, as long as you get a 9, you repeat the same operation: replace it with a 0,
and increase the number before it. Check for `29 + 1` or `99 + 1` if you want.  

The exact same thing happens for binary numbers (and any numbers in any base)!

What is the result of `1 + 1` in binary? There isn't any figure after `1`,
therefore, you replace it with a `0` and increase the number before it, which
gives you `10`.

In binary again, `10 + 1` gives you `11`, and `11 + 1` gives you `100`. 

##### Regular → binary, some examples

| Regular | Binary |
|---------|--------|
|       0 |      0 |
|       1 |      1 |
|       2 |     10 |
|       3 |     11 |
|       4 |    100 |
|       5 |    101 |
|       6 |    110 |
|       7 |    111 |
|       8 |   1000 |
|       9 |   1001 |
|      10 |   1010 |

Note: each figure on a binary number is called a *bit*.

#### Binary to regular, an other story

What if you want to convert binary to a regular number. Right now, what is the
regular number for `100101`? :thinking:

Pretty tough, hey? :smile: You'd have to convert every regular number its binary
version and see which one matches, which isn't efficient at all. Instead, here's
a better way to do it.

First, we must understand that every bit as a value. The last number is worth 1,
and every other number is worth the double of the value of the number on its right.

```
100101
     ^ worth 1
    ^ worth 2 (2 x 1)
   ^ worth 4 (2 x 2)
  ^ worth 8 (2 x 4)
 ^ worth 16 (2 x 8)
^ worth 32 (2 x 16)
```

Get it? Let's move on then.

> The value of a binary number is the sum of each value of the bit that are equal to 1

It's easier to read from right to left in this case, it makes it simpler to know
what is the value of the bit we're at, since it's just the double of the
previous one.

So, let's decode `100101`. Our sum is currently 0.

The last number being a 1, we add its value (1) to the sum. Our sum is
currently 1.

The previous number being a 0, we don't do anything.

The previous number being a 1, we add its value (4) to the sum. Our sum is now
5.

The 2 previous numbers being 0, we ignore both of them.

The previous number being a 1, we add its value (32) to the sum. Our sum is now
1 + 4 + 32, which is 37.

So, `100101` is equal to 37.

### Operators

What makes binary numbers useful to us is that you can make some operation with
them (called *bitwise* operations). In this post, I'll use Python because it's
awesome, but pretty much every programming language should be able to do this.

The 2 operators I'm about to show you use 2 numbers, and does some operations of
the *binary form* of the number.

#### The "and" bitwise operator

It's basically the regular `and` operator for every bit in our numbers.

```
First:  10111001
Second: 01011010
Result: 00011000
```

In simple words, it adds a 1 to the result if both current bits are a 1 too,
otherwise, it adds a 0.

#### The "or" bitwise operator

You guessed it, it's the equivalent of the `or` operator for every bit in our
numbers.

```
First:  10111001
Second: 01011010
Result: 11111011
```

In simple words, it adds a 1 to the result if at least one bit is 1, otherwise a
0.

#### Python way

In python, here's what it'd look like:

```python
first = 1
second = 2

# writing numbers in a binary form
print(first == 0b1) # True
print(second == 0b10) # True

# converting numbers into a binary form
print(bin(first)) # 0b1
print(bin(second)) # 0b10

# bitwise operators "and"
print(first & second) # 0b00, or 0
print(first | second) # 0b11, or 3
```

### The use?

> Ok, thanks, but what's the use of this??

Flags.

For example, you want to write a function that takes a number and tells you if
the number is a multiple of 2, 3, 5 and 7.

With some carefully chosen numbers, and the bitwise operators `or` and `and`,
your function can return a simple number, and the end user would be able to tell
which numbers can divide the number he called your function with.

#### The idea

The idea is to give a meaning to every bit. If the number I give you is `0101`, and I tell
you that if the second bite is 1, then the number is dividable by 2, and that if the
fourth bit is 1, the number is dividable by 5, you'll know that the number you gave is a
dividable both by 2 and 5.

And guess what: it's the `or` and `and` bitwise that allow you to do that.

You have to combine a set of number that will each "active" (set to 1) a
specific bit. 

So, which numbers could we combine (using the `or` bitwise operator) in any
order so that we could tell which one was used? These ones (in binary form):

```
   1
  10
 100
1000
...
```

Do you understand? If you combine `1` with `100` using the `or` bitwise
operator, you'll get `101`, and you'll know that you used `100` and `1`.

Do you recognize the relation between those numbers? They're the double of the previous
one, each time: 1, 2, 4, 8, etc...

#### Our little example

```python
DIVIDABLE_BY_2 = 0b0001 # we don't actually need all these extra 0
DIVIDABLE_BY_3 = 0b0010
DIVIDABLE_BY_5 = 0b0100
DIVIDABLE_BY_7 = 0b1000

def classify(number):
    # same as 0, but it makes it understandable that we're going to use bit
    result = 0b0
    if number % 2 == 0:
        # the number is dividable by 2 (the rest of the division is equal to 0)
        result = result | DIVIDABLE_BY_2
    if number % 3 == 0: result |= DIVIDABLE_BY_3
    if number % 5 == 0: result |= DIVIDABLE_BY_5
    if number % 7 == 0: result |= DIVIDABLE_BY_7
    return result
```

Let's see what we get:

```python
>>> classify(15)
'0b0110'
>>> classify(3)
'0b0010'
>>> classify(2 * 3 * 5 * 7)
'0b1111'
```

And now, we can use the `and` bitwise operator to check if the returned value
matches with a number.

If no bit matches, it'll return `0b0000`, which will be 0, and once converted to
a boolean, will be `False`. Otherwise, it'll return an other number, which we
don't care about (it'll be converted to `True`, since it will be different from
0).

```python
>>> classification = classify(15)
>>> bool(classification & DIVIDABLE_BY_2)
False
>>> bool(classification & DIVIDABLE_BY_3)
True
>>> bool(classification & DIVIDABLE_BY_5)
True
>>> bool(classification & DIVIDABLE_BY_7)
False
```

It might be a bit confusing, so *play with it*:

<script src="//repl.it/embed/M99I/1.js"></script>
