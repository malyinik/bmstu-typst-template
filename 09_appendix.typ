#import "template/config.typ": appendices
#show: appendices

#align(center)[#heading[ПРИЛОЖЕНИЕ]<sec:appendix-a>]

#lorem(250)

На~@lst:matrix-types[листинге] приведены определения типов матрицы.

#figure(
  raw(read("listings/matrix.hpp"), lang: "cpp", block: true),
  caption: [Определения типов матрицы],
)<matrix-types>
