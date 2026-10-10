#import "template/bmstu.typ": *
// При numbering-by-chapter: true рисунки, таблицы, листинги и формулы нумеруются в пределах раздела, а не сквозь весь документ.
// При code-highlighting: false код в листингах выводится без подсветки синтаксиса.
#show: config.bmstu_config.with(
  numbering-by-chapter: false,
  code-highlighting: true,
)

#include "00_title.typ"
#outline()
#include "01_main.typ"
#bibliography("02_references.yml")
#include "03_appendix.typ"
