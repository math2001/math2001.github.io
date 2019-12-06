---
title: "Go Order of Operation Matters"
date: 2019-12-07T10:00:06+11:00
---

In Go, two mathematically equivalent expression can yield different result
based on the order in which you do things! Thanks rounding errors... <!--more-->

For example:

```go
fmt.Println(1 / 2 * 10) // prints 0
fmt.Println(1 * 10 / 2) // prints 5
```

However, mathematically, they should both be 5 (we just moved the `/ 2` within
a product).

So why does go give different results? Both operations `/` and `*` have the
same prevalence (unlike `+` and `/` for example, where the division would be
evaluated first). Hence, they are evaluated from left to right.

In the first case, `1 / 2` is evaluated, and then whatever that was is
multiplied by `10`. Now, since both `1` and `2` are integers, go just gives
back an `int`. Yet `0.5` can't be represented as an `int`, so it truncates the
floating part and gives you `0`. `0 * 10` is still 0.

You can figure out why the second case works.

To counter that, you want to make sure that the operands are floats, so that go
gives you floats back:

```go
fmt.Println(1.0 / 2.0 * 10) does give you 5
```

