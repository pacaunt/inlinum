#import "@local/inlinum:0.1.0": fix-indent, newpar

#set page(width: 300pt)


#show: fix-indent

#set par(
  first-line-indent: (amount: 2em, all: false)
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

#figure([FIG ONE], caption: [This is figure 1.])
#lorem(10) // no indent 

#figure([FIG TWO], caption: [This is figure 2.])

#lorem(10) // indented

$ e + f $

#newpar
#lorem(10) // No indented, like first paragraph.
