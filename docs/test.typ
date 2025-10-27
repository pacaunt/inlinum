#import "@local/inlinum:0.1.0": fix-indent, newpar



// #set par(first-line-indent: )
#show: fix-indent
// #show math.equation.where(block: true): block.with(stroke: red)
#set par(
  first-line-indent: (amount: 2em, all: true),
)
// #show parbreak: box(width: 10pt, height: 10pt, fill: red)
Hello
$
  x=1
$
#lorem(10) // no indent
$ ["component"_i] = frac(n_i, V("L")) a/b $
where volume of mixture $V$ *must* be in liters (L).
$
  y=1
$
#lorem(10) // indented

$
  y = 1
$
#lorem(10)

- A1
- B1
#lorem(10) // no indent

- A2
- B2

#lorem(10) // indented
+ A3
+ B3

#lorem(10) // no indent + less spacing

#figure([FIG ONE], caption: [This is figure 1.])
#lorem(10) // no indent

#figure([FIG TWO], caption: [This is figure 2.])

#lorem(10) // indented

$ e + f $

#newpar
#lorem(10) // No indented, like first paragraph.

#import "@local/scitools:1.1.0": qty, unit
#import "@preview/zero:0.5.0": num
#import "@preview/physica:0.9.7": *
#import "@preview/mannot:0.3.0": *
#set text(font: "LMRoman10")
#show math.equation: set text(font: "Latin Modern Math")


$
  markrect(outset: #.5em, (pdv(G, T))_T)
$
#lorem(20)
$
  b^2
$
#lorem(20)
$
  a^2
$
w#lorem(20)