---
title: Motion and calculus
slug: motion-and-calculus
date: 2019-02-15T11:12:47+11:00
tags: [mathematics, calculus, physics, newtown]
---

### Motions

If you studied physics, one of the first things you probably did was graph the
"motion" of objects. That is the displacement, velocity, and acceleration at
an instant *t*.

#### Observation

Let's say we have an object whos displacement is such that:

$$
s(t) = t^2 \quad \text{where t is the time}
$$

If we graphed this function, we'd get a parabola:

<iframe src="https://www.desmos.com/calculator/kyuoometzc?embed" class='desmos' frameborder="0"></iframe>

Now, let's graph its velocity. You can do it manually, but if you try to feel it,
you'll see that since as the time goes by the displacement keeps on increasing
faster and faster, the velocity could increase linearly. The velocity of that
object at an instant $t$ could be given by:

$$
v(t) = t
$$

Which would look something like this:

<iframe src="https://www.desmos.com/calculator/w5fy20gttr?embed" class='desmos' frameborder="0"></iframe>

What if we graphed the acceleration? Since the velocity is increasing at a
constant rate, the acceleration must be constant, something like:

$$
v(t) = 1
$$

<iframe src="https://www.desmos.com/calculator/klppykcplt?embed" class='desmos' frameborder="0"></iframe>

Now, doesn't that make you think of a derivating the function $v$? Everytime,
the function is one degree lower.

### The meaning

#### The derivative

Say we graphed the displacement of a ball with time on x-axis and displacement
on the y-axis. What would be the meaning of the gradient at any point?

$$
m = \frac{rise}{run} = \frac{displacement}{time}
$$

The rise over the run is a displacement over some time, which is a velocity. And
it makes sense! The gradient (which is the rate of change) of any point on this
displacement/time graph gives us the *velocity* (which is the change of position
per unit time, ie. how quickly it's changing position, its *rate*).

Now, from a velocity/time graph, the gradient gives us the change in velocity,
which is called *acceleration*.

#### The integral

What if you want to go the other way? From a velocity/time graph, the
displacement is given by the area under the curve.

If you're not convinced, it's easier to think of a simple example where the
velocity is constant (a straight flat line). If you want to know by how much
an object traveled knowing it's speed (2 m/s) and the time it took (5 s), you'd
just multiply (2 * 5 = 10 m). Now, this happens to be area under the graph
(width * height). And with a bit of thinking, you can convince yourself that
this isn't a coincidence.

Can you see that this also works for an acceleration/time graph (it gives you
the velocity).

So, the derivative of a function let's you go from displacement to velocity to
acceleration, and the integral let's you go the other way.

No wonder Newton was into calculus...
