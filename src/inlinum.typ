#let _prefix = "_inlinum:0.1.0"
#let _label = label(_prefix + "_processed")
#let _sequence = [].func()
#let _state = state(_prefix + "_par-state", none)

// Fix the paragraph by being the first paragraph.
#let newpar = metadata(_prefix + "_start-par")
#let protect(seq) = [#seq#_label]

#let fix-indent(doc, fix: ()) = {
  // show metadata: it => {
  //   if it.value == newpar.value {
  //     _state.update(false)
  //   } else {
  //     it
  //   }
  // }
  // show par: p => {
  //   let parindent = par.first-line-indent
  //   if p.has("label") and p.label == _label {
  //     p
  //   } else {
  //     let fix-amount = 0pt
  //     let (fix, unfix) = if parindent.all {
  //       (0pt, parindent)
  //     } else {
  //       (0pt, (amount: parindent.amount, all: true))
  //     }
  //     context if _state.get() {
  //       [#par(p.body, first-line-indent: fix)#_label]
  //     } else {
  //       [#par(p.body, first-line-indent: unfix)#_label]
  //     }
  //   }
  // }
  // show _sequence: seq => {
  //   let item-family = (enum.item, list.item, terms.item)
  //   let block-family = (enum, list, terms, figure) + fix
  //   let children = seq.children
  //   let peek(arr: children, i) = arr.at(i, default: none)
  //   let eat-spacing = v(-par.spacing + par.leading)

  //   // Check the element's function
  //   let func(elem) = if type(elem) == content {
  //     elem.func()
  //   } else {
  //     none
  //   }

  //   // Modification to the text
  //   let (unpar, parred) = (_state.update(true), _state.update(false))

  //   let check = false
  //   let result = ()
  //   let item = 0
  //   let item-tight = true
  //   let last-item = false

  //   // Avoid recursion
  //   if seq.has("label") and seq.label == _label {
  //     seq
  //   } else {
  //     // Main Loop
  //     let i = 0
  //     while i < children.len() {
  //       let c = children.at(i)
  //       result.push(c)

  //       // check if we need to reset the paragraph
  //       check = (
  //         {
  //           func(c) == math.equation and c.block
  //         }
  //           or {
  //             func(c) in item-family and func(peek(i + 2)) not in item-family
  //           }
  //           or {
  //             func(c) in block-family
  //           }
  //           or {
  //             c == newpar
  //           }
  //       )

  //       // Checking the tightness of the `item`s.
  //       if c == parbreak() and func(peek(i + 1)) in item-family {
  //         item-tight = false
  //       }

  //       if func(c) in item-family {
  //         if func(peek(i + 2)) in item-family {
  //           item += 1
  //         }
  //       }

  //       if item > 0 {
  //         if c == parbreak() {
  //           item-tight = false
  //         }
  //       }

  //       // We will reach this only when the items are ended.
  //       if check {
  //         if peek(i + 1) == parbreak() {
  //           i += 1
  //           result.push(parred)
  //         } else if peek(i + 1) == newpar or peek(i + 2) == newpar {
  //           // Do nothing
  //         } else  {
  //           if func(c) in item-family and item-tight {
  //             result.push(eat-spacing)
  //           }
  //           result.push(unpar)
  //         }

  //         // reset the items
  //         item = 0
  //         last-item = false
  //         item-tight = true
  //       }
  //       i += 1
  //     }
  //     [#_sequence(result)#_label]
  //   }
  // }
  // #let the-label = <par-fix>

  show parbreak: p => {
    p
    _state.update(false)
  }

  show selector.or(figure, math.equation.where(block: true), enum, terms, list): it => {
    it
   _state.update(true)
  }

  show par: p => context {
    let body = p.body
    if p.has("label") and p.label == _label {
      p
    } else {
      context if _state.get() == true {
        [#par(body + _state.update(false), first-line-indent: 0pt)#_label]
      } else {
        [#par(body + _state.update(false))#_label]
      }
    }
  }
  doc
}
