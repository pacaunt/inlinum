#let _prefix = "_inlinum:0.1.0"
#let _label = label(_prefix + "_processed")
#let _sequence = [].func()

// Fix the paragraph by being the first paragraph.
#let newpar = metadata(_prefix + "_start-par")
#let protect(seq) = [#seq#_label]

#let fix-indent(doc, fix: ()) = {
  show metadata: it => {
    if it.value == newpar.value {
      let indent = par.first-line-indent
      if type(indent) == dictionary {
        if indent.all {
          h(indent.amount)
        } else {
          h(-indent.amount)
        }
      } else {
        h(-indent)
      }
    } else {
      it
    }
  }
  show _sequence: seq => {
    let item-family = (enum.item, list.item, terms.item)
    let block-family = (enum, list, terms, figure) + fix
    let children = seq.children
    let peek(arr: children, i) = arr.at(i, default: none)
    let eat-spacing = v(-par.spacing + par.leading)

    // Check the element's function
    let func(elem) = if type(elem) == content {
      elem.func()
    } else {
      none
    }

    // Modification to the text
    let (unpar, parred) = {
      let indent = par.first-line-indent
      if type(indent) == dictionary {
        if indent.all {
          (h(-indent.amount), none)
        } else {
          (none, h(indent.amount))
        }
      } else {
        (none, h(indent))
      }
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
              c == newpar
            }
        )

        // Checking the tightness of the `item`s.
        if c == parbreak() and func(peek(i + 1)) in item-family {
          item-tight = false
        }

        if func(c) in item-family {
          if func(peek(i + 2)) in item-family {
            item += 1
          }
        }

        if item > 0 {
          if c == parbreak() {
            item-tight = false
          }
        }

        // We will reach this only when the items are ended.
        if check {
          if peek(i + 1) == parbreak() {
            i += 1
            result.push(parred)
          } else if peek(i + 1) == newpar or peek(i + 2) == newpar {
            // Do nothing
          } else  {
            if func(c) in item-family and item-tight {
              result.push(eat-spacing)
            }
            result.push(unpar)
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
