#align(center, heading(numbering: none, [РЕФЕРАТ]))

#let total_pages = context counter(page).final().at(0)
#let total_figures = context counter(figure.where(kind: image)).final().at(0)
#let total_tables = context counter(figure.where(kind: table)).final().at(0)
#let total_sources = yaml("08_references.yml").keys().len()

Расчётно-пояснительная записка #total_pages~с., #total_figures~рис., #total_tables~табл., #total_sources~источн.


#pagebreak(weak: true)
