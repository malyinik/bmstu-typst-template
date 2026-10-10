= Аналитическая часть

#text(size: 20pt, fill: gray)[Пишем про тему и всё, связанное с ней]

== #lorem(5)

#lorem(25) $A$ размером $m times n$. Элементы произведения вычисляются по @eqt:product[формуле]~@veretennikov2015[с.~23]:
$
  c_(i j) = sum_(k=1)^n a_(i k) dot b_(k j), quad i = 1, ..., m, quad j = 1, ..., q,
$<eqt:product>
где $c_(i j)$~--- элемент матрицы $C$, $a_(i k)$ и $b_(k j)$~--- элементы матриц $A$ и $B$.

#lorem(20) по @eqt:winograd[формуле]:
$
  c_(i j) = sum_(k=1)^d (a_(i, 2k-1) + b_(2k, j)) dot (a_(i, 2k) + b_(2k-1, j)) - r_i - s_j,
$<eqt:winograd>
где $d = floor(n slash 2)$~--- число пар элементов; \
$r_i$~--- множитель строки $i$ матрицы $A$; \
$s_j$~--- множитель столбца $j$ матрицы $B$.

== #lorem(4)

#lorem(30) Формула с меткой `<->` не нумеруется:
$
  r_i = sum_(k=1)^d a_(i, 2k-1) dot a_(i, 2k).
$<->

#lorem(40)

#heading(numbering: none, level: 2, outlined: false, [Вывод])

#text(size: 20pt, fill: gray)[Что сделали в аналитической части, кратко]

#pagebreak(weak: true)
