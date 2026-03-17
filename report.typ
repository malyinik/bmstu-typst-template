#import "template/bmstu.typ": *
#show: config.bmstu_config

#include "00_title.typ"
// Вставка страниц ТЗ и обновление счётчика страниц
// #page(numbering: none, margin: 0mm)[
//     #image("ТЗ.pdf", width: 100%, page: 1)
// ]
// #page(numbering: none, margin: 0mm)[
//     #image("ТЗ.pdf", width: 100%, page: 2)
// ]
// #counter(page).update(4)
#include "01_abstract.typ"
#outline()
#include "02_intro.typ"
#include "03_analytical.typ"
#include "04_design.typ"
#include "05_tech.typ"
#include "06_research.typ"
#include "07_conclusion.typ"
#bibliography("08_references.yml")
#include "09_appendix.typ"
