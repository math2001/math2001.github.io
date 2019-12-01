---
title: Test suites should include old tag's test suites
slug: test-suites-should-include-old-tags-test-suites
date: 2019-11-30T08:30:14+11:00
tags: [dependencies management, testing]
draft: true
---

I'm just cloning some "old" project (anything that I wrote more than 2 months
ago is old), [nine43][] on my machine, and I'm scarred that the dependencies
are going to mess up. The main reason is that I have to bump up a dependency
because GitHub found a security issue in it...

But I just realized that I shouldn't be scared of that. Upgrading a dependency
shouldn't break anything at all (unless you bump the major version, which isn't
what I'm doing).

Therefore, the current code base should pass against not only the current
tests, but all the ones in the previous versions, tags, commits, whatever. I'll
name this the v test suite (version...ized).

Hence, if the v test suite, then we should be more confident that the current
version is indeed compatible with previous version, assuming that the tests in
the previous version tested what they meant to test.

Also, the test in the v test suite should only test exposed functions, and
completely ignore internals.

Now this would be a pain to implement if the tests are mixed up with the
current code base, or if they have side effect. [example needed]

But it's definitely a good idea to do something like this in the CI.

Of course, it might seem like all those old tests are superflous, because who
would delete old tests, right? That's true, but I certainly do *edit* old test,
and I'm not confident that I haven't changed the test to fit the *current*
version, and that they all still pass with older version. The only way you
could have that confidence is if you forced yourself to write each test once,
and *never touch it ever again* (until your major bump).

But we all know there's going to be hick up at some point, and we have a great
tool at our fingertip, VCS, let's make use of it.

However, the test in the different versions don't have to be compatible with
each other, and hence we can't just iterate every version and "collect" the
tests.

## What do I want

```
$ go test -versions
```

Imagine that. It would
