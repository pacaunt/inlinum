# inlinum
An attempt to fix the behavior of Typst's native paragraph handling. This package may be useful until [#3206](https://github.com/typst/typst/issues/3206) is fixed.

## Usage
This package provides 2 functions: `fix-indent` and `newpar`.
```typ
#import "@preview/inlinum:0.1.0": fix-indent, newpar

#show: fix-indent

#set par(first-line-indent: 2em) // of your choice

// Your content goes here.
```

## Rules of indentation

For every block level elements (defaults are equations, enums, lists, and figures), the paragraph will remains as if it is the same paragraph when it is not followed by `parbreak()` (consecutive newlines).

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

```typ
#figure([FIG ONE], caption: [This is figure 1.])
#lorem(10) // no indent 

#figure([FIG TWO], caption: [This is figure 2.])

#lorem(10) // indented

$ e + f $

#newpar
#lorem(10) // No indented, like first paragraph.
```
<img alt="image" src="https://github.com/user-attachments/assets/5a4252d1-88a6-4665-bcc2-589a0e5e6129" />

## Limitations
The process of fixing requires a show rule of Typst's internal `sequence` function, which is constructed *all the time* when you are working with `content` type. Therefore, it may slow down your compile time. Moreover, this process *does not* produce new paragraph, so `par.line` will **not** work as expected.