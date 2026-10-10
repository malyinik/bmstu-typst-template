#import "template/bmstu.typ": *
// При numbering-by-chapter: false рисунки, таблицы, листинги и формулы нумеруются сквозь весь документ, а не в пределах раздела.
// При code-highlighting: false код в листингах выводится без подсветки синтаксиса.
#show: config.bmstu_config.with(numbering-by-chapter: true, code-highlighting: true)

#include "00_title.typ"
#outline()
#include "01_intro.typ"
#include "02_analytical.typ"
#include "03_design.typ"
#include "04_tech.typ"
#include "05_research.typ"
#include "06_conclusion.typ"
#bibliography("07_references.yml")
#include "08_appendix.typ"
