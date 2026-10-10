#import "template/config.typ": appendices
#show: appendices

= ПРИЛОЖЕНИЕ <sec:appendix-a>

#text(
  size: 20pt,
  fill: gray,
)[Тут всякие слишком большие ништяки, которые вы хотели бы добавить в отчёт]

Реализация классического алгоритма приведена на~@lst:classic[листинге].

#figure(
  raw(read("listings/classic.cpp"), lang: "cpp", block: true),
  caption: [Реализация классического алгоритма умножения матриц],
)<lst:classic>
