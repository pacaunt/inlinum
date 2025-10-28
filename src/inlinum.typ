#let _prefix = "_inlinum:0.1.0"
#let _label = label(_prefix + "_processed")
#let _sequence = [].func()
#let _space = [ ].func()
#let _state = state(_prefix + "_par-state", none)

#let (_unpar, _parred) = ("_unpar", "_parred").map(s => metadata(_prefix + s))
#let red-box = box(fill: red, width: 10pt, height: 10pt, stroke: 1pt)
#let green-box = box(fill: green, width: 10pt, height: 10pt, stroke: 1pt)

// Fix the paragraph by being the first paragraph.
#let newpar = metadata(_prefix + "_start-par")

#let protect(seq) = [#seq#_label]

#let fix-indent(doc, fix: (), debug: true, ignored: ()) = {
  let block-family = (enum, list, terms, figure) + fix
  let ignored-blocks = (heading, _sequence) + ignored
  let all-blocks = block-family + ignored-blocks + (math.equation,)
  // show metadata: it => {
  //   if it.value == newpar.value {
  //     _state.update(none)
  //   } else {
  //     it
  //   }
  // }
  show _label: p => {
    let ind = par.first-line-indent
    let (unindent, indented) = if ind.all {
      (-ind.amount, 0pt)
    } else {
      (0pt, ind.amount)
    }
    show metadata: it => {
      if it.value == _unpar.value {
        if debug { green-box } else { h(unindent) }
      } else if it.value == _parred.value {
        if debug { red-box } else { h(indented) }
      }
    }
    p
    // if p.has("label") and p.label == _label {
    //   p
    // } else {
    //   [#par(p.body)#_label]
    // }
  }
  // show par: p => {
  //   let parindent = par.first-line-indent
  //   if p.has("label") and p.label == _label {
  //     p
  //   } else {
  //     let fix-amount = 0pt
  //     let body = p.body + _state.update(none)
  //     let (fix, unfix) = if parindent.all {
  //       (0pt, parindent)
  //     } else {
  //       (0pt,(amount: parindent.amount, all: true))
  //     }
  //     if _state.get() == true {
  //       [#par(body, first-line-indent: fix)#_label]
  //     } else if _state.get() == false {
  //       [#par(body, first-line-indent: unfix)#_label]
  //     } else {
  //       p
  //     }
  //   }
  // }
  show _sequence: seq => {
    let item-family = (enum.item, list.item, terms.item)
    let children = seq.children
    let peek(arr: children, i) = arr.at(i, default: none)
    let eat-spacing = v(-par.spacing + par.leading)

    // Check the element's function
    let func(elem) = if type(elem) == content {
      elem.func()
    } else {
      none
    }

    let check = false
    let result = ()
    let item = 0
    let item-tight = true
    let last-item = false

    // Avoid recursion
    if seq.has("label") and seq.label == _label {
      seq
    } else {
      // Main Loop
      let i = 0
      while i < children.len() {
        let c = children.at(i)
        result.push(c)

        // check if we need to reset the paragraph
        check = (
          {
            func(c) == math.equation and c.block
          }
            or {
              func(c) in item-family and func(peek(i + 2)) not in item-family
            }
            or {
              func(c) in block-family
            }
            or {
              c in (newpar,)
            }
        )

        // Checking the tightness of the `item`s.
        if c == parbreak() and func(peek(i + 1)) in item-family {
          item-tight = false
        }

        if func(c) in item-family and func(peek(i + 2)) in item-family {
          item += 1
        }

        if item > 0 {
          if c == parbreak() {
            item-tight = false
          }
        }

        // We will reach this only when the items are ended.
        if check {
          if peek(i + 1) == parbreak() {
            if (
              func(peek(i + 2)) != none and func(peek(i + 2)) not in all-blocks
            ) {
              result.push(_parred)
            }
            i += 1
          } else if peek(i + 1) == newpar or peek(i + 2) == newpar {
            // Do nothing
          } else {
            if func(c) in item-family and item-tight {
              result.push(eat-spacing)
            }
            if (
              // { func(peek(i + 1)) != _space and func(peek(i + 1)) != none }
              //   or if func(peek(i + 1)) == _space {
              //     func(peek(i + 2)) not in (all-blocks + item-family)
              //   } else {
              //     false
              //   }
              if func(peek(i + 1)) == _space {
                func(peek(i + 2)) != none and  func(peek(i + 2)) not in all-blocks
              } else {
                func(peek(i + 1)) != none
              }
            ) {
              result.push(_unpar)
            }
          }

          // reset the items
          item = 0
          last-item = false
          item-tight = true
        }
        i += 1
      }
      [#_sequence(result)#_label]
    }
  }
  doc
}
