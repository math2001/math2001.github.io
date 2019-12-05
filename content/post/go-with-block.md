---
title: Go with blocks
slug: go-with-blocks
date: 2019-12-05T12:32:43+11:00
tags: [go, with]
draft: true
---

I find `with` blocks in python very neat, especially for doing things like
cleaning up and acquiring locks. Go has its own strategy which works for one,
but not the other. Thankfully, we can use a function to do the
trick.<!--more-->

TLDR:

```go
func {
    setup()
    defer teardown()

    // do stuff
}
```

The typical example:

```python
with open("myfile", "r") as fp:
    content = fp.read()

# here file.close() is called automatically thanks to that with block
```

Go has its own strategy for that:

```go
func main() {
    f, err := os.Open("myfile")
    if err != nil {
        // handle err
    }
    defer f.Close()

    content, err := ioutil.ReadFull(f)
    if err != nil {
        // handle err
    }
}
```

Here, the `f.Close()` will be called whenever the function it's in `main`
returns.


### Locks

Now acquiring locks is super neat in Python as well:

```python
def myfunction():
    with resource.acquire():
        if resource.a() == 0:
            # resource is released
            raise ValueError("we got 0!")
        elif resource.b() == 1:
            # resource is released
            return "we should stop"
        resource.do_stuff()

    # resource is released
    do_some_more_stuff()
```

Notice how the lock is released as soon as possible (as soon as we don't need
`resource` anymore). This is good practice, and especially important if many
parts of your program want `resource`.

And here, go falls short:

```go
func myfunction() (string, error) {
    resource.Lock()
    defer resource.Unlock()

    if resource.A() == 0 {
        // resource is released
        return "", errors.New("we got 0!")
    } else if resource.B() == 1 {
        // resource is released
        return "we should stop", nil
    }

    // oh no! resource is still not released
    doSomeMoreStuff()

    // finally, we release it
    return "", nil
}
```

As you can see, the hold onto the resource longer than we need to...

So, here's the trick:

```go
func myfunction() (string, error) {
    instruction, err := func() (string, error) {
        resource.Lock()
        defer resource.Unlock()

        if resource.A() == 0 {
            // resource is released
            return "", errors.New("we got 0!")
        } else if resource.B() == 1 {
            // resource is released
            return "we should stop", nil
        }
    }()

    // oh no! resource is still not released
    doSomeMoreStuff()

    // finally, we release it
    return nil
}
```

``````
