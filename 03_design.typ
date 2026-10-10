= Конструкторская часть

#text(size: 20pt, fill: gray)[Пишем про алгоритмы, архитектуру ПО и т.п.]

== #lorem(8)

Схемы алгоритмов представлены на рисунках~@fig:diagram-1[]--@fig:diagram-2[].

#figure(
  image("images/diagram_1.svg", width: 25%),
  caption: [Подпись к схеме],
)<fig:diagram-1>

#figure(
  image("images/diagram_2.svg", width: 20%),
  caption: [Подпись к схеме],
)<fig:diagram-2>

== #lorem(10)

#lorem(20)

- #lorem(20)
  + #lorem(20)
  + #lorem(20)
- #lorem(20)
- #lorem(20)

#lorem(30)

+ #lorem(15)
+ #lorem(10)
  + #lorem(10)
  + #lorem(10)
+ #lorem(8)

== Оценка трудоёмкости

Трудоёмкость алгоритмов приведена в @tbl:costs[таблице].

// Небольшую таблицу лучше не разрывать между страницами, иначе на следующую может уйти одна строка.
#show table: set block(breakable: false)
#figure(
  table(
    columns: (1fr, auto, auto),
    align: (left, center, center),
    table.header([*Алгоритм*], [*Лучший случай*], [*Худший случай*]),
    [Классический], [$10 m n q + 4 m q + 4 m + 2$], [$10 m n q + 4 m q + 4 m + 2$],
    [Виноград], [$...$], [$...$],
  ),
  caption: [Трудоёмкость алгоритмов],
)<tbl:costs>

#heading(numbering: none, level: 2, outlined: false, [Вывод])

#text(size: 20pt, fill: gray)[Что сделали в конструкторской части и получили в результате, кратко]

#pagebreak(weak: true)
