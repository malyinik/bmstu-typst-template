#import "@preview/lilaq:0.5.0" as lq

= Исследовательская часть

#text(
  size: 20pt,
  fill: gray,
)[Цель исследования, на какой машине делали (указать ЦПУ, ОЗУ, ОС), желательно написать, как исследовали и при каких условиях; что получили в результате (таблицы + графики)]

== Технические характеристики

Замеры выполнялись на ноутбуке со следующими характеристиками:

- операционная система #lorem(2);
- процессор #lorem(4);
- оперативная память #lorem(3).

== #lorem(5)

Результаты замеров приведены в @tbl:benchmark-data[таблице] и на @fig:benchmark[рисунке], графики построены библиотекой Lilaq~@lilaq.

#let data_1 = csv("data/1.csv")
#let data_2 = csv("data/2.csv")
#let data_3 = csv("data/3.csv")

// Строки таблицы собираются из трёх CSV-файлов: первая колонка берётся из первого файла, остальные из своих файлов.
// Таблица из одного CSV-файла передаётся сразу: ..csv("data/1.csv").flatten().
#let rows = range(data_1.len()).map(i => (
  data_1.at(i).at(0),
  data_1.at(i).at(1),
  data_2.at(i).at(1),
  data_3.at(i).at(1),
))

#[
  #set par(justify: false)
  #show table: set block(breakable: false)
  #figure(
    table(
      columns: (1fr, 1fr, 1fr, 1fr),
      align: center + horizon,
      table.header([*Колонка 1*], [*Колонка 2*], [*Колонка 3*], [*Колонка 4*]),
      ..rows.flatten(),
    ),
    caption: [Подпись к таблице],
  )<tbl:benchmark-data>
]

#let plot_thickness = 1.5pt
#let plot_mark_size = 5pt
#let stroke_1 = stroke(dash: "dashed", thickness: plot_thickness)
#let stroke_2 = stroke(dash: (10pt, 10pt), thickness: plot_thickness)

#figure(
  lq.diagram(
    width: 100%,
    height: 40%,
    xlabel: [Подпись оси $X$],
    ylabel: [Подпись оси $Y$],
    legend: (position: left + top),

    let (x, y) = lq.load-txt(read("data/1.csv")),
    lq.plot(
      x,
      y,
      mark: "o",
      mark-size: plot_mark_size,
      label: [График 1],
      smooth: true,
      stroke: stroke_1,
    ),
    (x, y) = lq.load-txt(read("data/2.csv")),
    lq.plot(
      x,
      y,
      mark: "v",
      mark-size: plot_mark_size,
      label: [График 2],
      smooth: true,
      stroke: stroke_2,
    ),
    (x, y) = lq.load-txt(read("data/3.csv")),
    lq.plot(
      x,
      y,
      mark: "s",
      mark-size: plot_mark_size,
      label: [График 3],
      smooth: true,
      stroke: plot_thickness,
    ),
  ),
  caption: [#lorem(21)],
)<fig:benchmark>

#lorem(40)

== Вывод

#text(size: 20pt, fill: gray)[Что сделали и получили в результате, кратко]

#pagebreak(weak: true)
