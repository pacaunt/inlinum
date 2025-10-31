#let _prefix = "_inlinum:0.1.0"
#let _label = label(_prefix + "_processed")
#let _sequence = [].func()
#let _space = [ ].func()
#let _state = state(_prefix + "_par-state", none)


#let red-box = box(fill: red, width: 10pt, height: 10pt, stroke: 1pt)
#let green-box = box(fill: green, width: 10pt, height: 10pt, stroke: 1pt)

// Fix the paragraph by being the first paragraph.
#let newpar = metadata(_prefix + "_start-par")

#let protect(seq) = [#seq#_label]

#let fix-indent(doc, fix: (), debug: false, ignored: ()) = {
  let block-family = (enum, list, terms, figure) + fix
  let ignored-blocks = (heading, _sequence) + ignored
  let all-blocks = block-family + ignored-blocks + (math.equation,)

  show _sequence: seq => {
    let item-family = (enum.item, list.item, terms.item)
    let children = seq.children
    let peek(arr: children, i) = arr.at(i, default: none)
    let eat-spacing = v(-par.spacing + par.leading)

    // Fixing indentation length
    let (parred, unpar) = {
      let indent = par.first-line-indent
      if debug {
        (green-box, red-box)
      } else {
        if indent.all {
          (none, h(-indent.amount))
        } else {
          (h(indent.amount), none)
        }
      }
    }

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
              result.push(parred)
            }
            i += 1
          } else if peek(i + 1) == newpar or peek(i + 2) == newpar {
            // Do nothing
          } else {
            if func(c) in item-family and item-tight {
              result.push(eat-spacing)
            }
            if (
              if func(peek(i + 1)) == _space {
                func(peek(i + 2)) != none and func(peek(i + 2)) not in all-blocks
              } else {
                func(peek(i + 1)) != none
              }
            ) {
              result.push(unpar)
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
