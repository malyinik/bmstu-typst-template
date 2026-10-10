#import "template/bmstu.typ": *
// При numbering-by-chapter: false рисунки, таблицы, листинги и формулы нумеруются сквозь весь документ, а не в пределах раздела.
// При code-highlighting: false код в листингах выводится без подсветки синтаксиса.
#show: config.bmstu_config.with(numbering-by-chapter: true, code-highlighting: true)

#include "00_title.typ"
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
