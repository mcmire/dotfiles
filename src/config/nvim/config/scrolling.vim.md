*(← Back to [index](../README.md))*

# Scrolling settings

When scrolling vertically, it's hard to see the cursor when it's at the very top
or bottom of the window, especially on large screens. So we set a vertical limit
on where the cursor can appear. This setting in particular will cause the cursor
to stop at the third line from the top or bottom.

``` vim
set scrolloff=3
```

Similarly, when scrolling horizontally -- which assumes that soft wrapping is
disabled -- we set a limit on where the cursor can appear. This setting causes
the cursor to stop at the third column from the left or right:

``` vim
set sidescrolloff=3
```

And we make it so that horizontal scrolling occurs one column at a time:

``` vim
set sidescroll=1
```
