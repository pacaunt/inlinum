# inlinum
An attempt to fix the behavior of Typst's native paragraph handling.

## Usage
This package provides 2 functions: `fix-indent` and `newpar`.
```typ
#import "@preview/inlinum:0.1.0": fix-indent, newpar

#show: fix-indent

#set par(first-line-indent: 2em) // of your choice

// Your content goes here.
```

## Rules of indentation

For every block level elements (defaults are equations, enums, lists, and figures), the paragraph will remains as if it is the same paragraph when it is not followed by `parbreak()`.

```typ
#show: fix-indent

#set par(
  first-line-indent: 2em
)

Hello
$
  x=1
$ 
#lorem(10) // no indent
$
  y=1
$

#lorem(10) // indented

- A1
- B1
#lorem(10) // no indent

- A2
- B2

#lorem(10) // indented
+ A3
+ B3
#lorem(10) // no indent + less spacing
```
<img alt="image" src="https://github.com/user-attachments/assets/c7ba7e47-fd36-4928-b19e-ec7751ee14dc" />

You can manually set the first paragraph by using `#newpar`.