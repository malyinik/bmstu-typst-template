#import "@preview/i-figured:0.2.4"
#import "template/config.typ": cyrillic-numbering, cyrillic-upper

#counter(heading).update(0)
#set heading(supplement: [Приложение], numbering: (..nums) => {
  let n = nums.pos()
  if n.len() == 0 { return "" }
  cyrillic-upper.at(n.first() - 1)
})

#show heading: it => align(center, [
  #let number = numbering(it.numbering, ..counter(heading).at(it.location()))
  #set text(size: 16pt, hyphenate: false)
  #v(1.5em, weak: true)
  #it.body~#number
  #v(1.5em, weak: true)
])

#show figure: i-figured.show-figure.with(numbering: cyrillic-numbering)
#show math.equation: i-figured.show-equation.with(numbering: cyrillic-numbering)

#align(center)[#heading[ПРИЛОЖЕНИЕ]<sec:appendix-a>]

#lorem(250)
