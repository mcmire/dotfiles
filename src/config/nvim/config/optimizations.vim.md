*(← Back to [index](../README.md))*

# Optimizations

Over time I have found ways to tweak the performance of Vim. While it's not
perfect, these techniques definitely help. (It's worth noting that there used to
be more here, but it appears that a couple of the settings I was using were
removed in Neovim, so I think we get the optimizations for free now.)

First, the syntax highlighter will get tripped up on files that have super long
lines, and when this happens, Vim will slow to a halt. To prevent this from
happening, we stop the highlighting after 128 characters. This can make lines
following the offending line look funny, but it's the price we pay:

``` vim
set synmaxcol=128
```

Next, we turn on `lazyredraw`, which, according to the help documentation, works
like this:

> When this option is set, the screen will not be redrawn while executing
> macros, registers and other commands that have not been typed. Also, updating
> the window title is postponed.

``` vim
set lazyredraw
```
