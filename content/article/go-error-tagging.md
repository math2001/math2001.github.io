---
title: Interpreting errors in Go
slug: Interpreting errors in Go
date: 2019-11-27T14:28:26+11:00
tags: [go, errors]
draft: true
---

I'm currently building [money][], a simple app to keep track of my expenses,
the aim being to teach myself how to use encryption properly. I have a private
folder to store my (encrypted) secret keys, my salts, and password hash which
are managed by a `KeysManager`.

I want to make sure that I detect unlawful modifications in this directory as
soon as possible, because that might be a hint that someone is attacking the
system. Hence, I want to be able to interpret the errors that `KeysManager`
returns to know if it's a potential corruption of the private directory.

Here are two different errors which `KeysManager` exports:

```go
var ErrAlreadyLoggedIn = errors.New("already logged in")

var ErrNoKeysfile = errors.New("no keys file")
```

`ErrNoKeysfile` is clearly indicating that the private folder is corrupted
(albeit deleting the keys file might not be the best way to attack a system,
but it's still a hint) because nowhere in my code do I delete only this file
and leave the folder as is. On the other hand, `ErrAlreadyLoggedIn` doesn't
imply that the private folder has been altered in any illicit way. Hence,
the user (user of `KeysManager`) should be able to *easily* detect that this
first error implies corruption.

How does `KeysManager` implement that?  There were two ways to go about it.

> FIXME: which one is better

### Error tagging

Error tagging makes use of the new `errors.Is` and `errors.As`.  If you don't
know about those two functions, go read the [blog post][go-errors] about it.
Essentially, they are utility functions for inspecting nested errors.

This approach tags `specific errors` with a `tag error`.

#### Tagging our own errors {#tagging-our-own-errors}

```go
// the tag error
var ErrPrivCorrupted = errors.New("corrupted private directory")

// a regular error
var ErrAlreadyLoggedIn = errors.New("already logged in")

// an error that needs to be tagged
// notice the %w: this means that ErrNoKeysfile wraps ErrPrivCorrupted
// the part "no keys file" is what we will call the specific error
var ErrNoKeysfile = fmt.Errorf("no keys file (%w)", ErrPrivCorrupted)
```

Usage:

```go
err := km.MyFunction() // may return ErrAlreadyLoggedIn or ErrNoKeysfile
if errors.Is(err, ErrPrivCorrupted) { // the error has been tagged
    log.Fatal("be careful! Potential attack: %s", err)
} else if err != nil {
    log.Fatalf("running my function: %s", err)
}
```

Here, `errors.Is` will unwrap the error chain and if it finds an
`ErrNoKeysfile`, return true.

> We could think of this approach as making specific errors *inherit* from the
> tag error.

#### Tagging within a call chain

Tagging *our own* errors was obvious enough. However, where do you insert the
tag when you are passing an error up the caller, for example:

```go
func LoadKeys() (Keys, error) {
    ...

    bytekey, err := hex.DecodeString(stringkey)
    if err != nil {
        // this error should be tagged with ErrPrivCorrupted
        return fmt.Errorf("hex decoding: %s", err)
    }

    ...
}
```

Adapting the terminology:

- `specific error`: the error which we have to pass up (in this case, whatever
  `hex.DecodeString` returned)
- `tag error`: the tag (in this case, `ErrPrivCorrupted`)
- `returned error`: the complete error that we return

So, where do you put the tag? Below, or at the same level as the returned
error? Although both approaches will generate the same string, they will
NOT be equivalent as the *error chain will be different*.

```go
// (below) returned -> specific -> tag
below := fmt.Errorf("hex decoding: %w", fmt.Errorf("%s (%w)", err, ErrPrivCorrupted)) // THIS DOESN'T EVEN WORK!

// (same level) returned + specific -> tag
sameLevel := fmt.Errorf("hex decoding: %s (%w)", err, ErrPrivCorrupted)

// string generated
"hex decoding: [error from hex lib] (tag)"
```

Notice the difference in the error chain:

- *below*: error that wraps the specific error which then wraps the tag
- *same level*: error that includes the specific error in it's *message* and
  then wraps the tag

Which strategy is better? It depends on the context, the same way [you
shouldn't always wrap when you pass up an error][whether-to-wrap]

If you want to expose the `specific error` to your user's *program* (for the
person it will be the exact same thing as the strings are equal), then you
should use the strategy *below* (wrap the `specific error`).

However, if the above program shouldn't depend on the `specific error`, then
you should use the strategy *same level*.

In this example, the program calling `KeysManager` shouldn't depend on the fact
that keys are hex encoded. Hence, I use the *same level* strategy.

For the sake of the example, let's assume that the `LoadKeys` function had to
parse some string given as an argument to retrieve the password, which would
then be used to decrypt the keys, and for some reason X, failing to parse the
given string would mean that the private folder was corrupted.

> FIXME: please find a better example

```go
func LoadKeys(address string) {
    ...

    userinfo, err := parseUserInfo(address)
    if err != nil {
        // since address was given by the caller, it makes sense to give
        // detailed information back (ie. wrap)
        return fmt.Errorf("parsing user info: %w", fmt.Errorf("%s (%w)"))
    }
}
```

I would use the *below* strategy where

[money]: https://github.com/math2001/money
[go-errors]: https://blog.golang.org/go1.13-errors
[whether-to-wrap]: https://blog.golang.org/go1.13-errors#TOC_3.4.
