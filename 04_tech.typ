= Технологическая часть

#text(size: 20pt, fill: gray)[
  Пишем всё про реализацию: какие языки, какие IDE и т.д.; коды алгоритмов/программы.

  Тестовые данные и волшебные слова "все тесты пройдены успешно".
]

== #lorem(2)

#lorem(30)

Основной цикл классического алгоритма приведён на @lst:classic-loop[листинге], полная реализация~--- в~@sec:appendix-a[приложении] на @lst:classic[листинге].

#figure(
  ```cpp
  for (size_t i = 0; i < nRowsA; ++i)
    for (size_t j = 0; j < nColsB; ++j)
      for (size_t k = 0; k < nColsA; ++k)
        result[i][j] += matrixA[i][k] * matrixB[k][j];
  ```,
  caption: [Основной цикл классического алгоритма],
)<lst:classic-loop>

== Тестирование

В @tbl:tests[таблице] #lorem(19)

#[
  #show table: set par(justify: false)
  #show table.cell.where(y: 0): strong
  #show math.equation.where(block: true): set text(size: 10pt)
  #show math.equation.where(block: false): it => { box(it) }
  #let test(number, description, a, b, c) = (
    [#number],
    description,
    [$
      A & = #a \
      B & = #b
    $<->],
    [$ C = #c $<->],
    [$ C = #c $<->],
  )
  #figure(
    table(
      columns: (auto, auto, auto, auto, auto),
      align: horizon,
      table.header([№ \ теста], [Описание], [Входные данные], [Эталонный результат], [Фактический результат]),
      ..test(
        1,
        [Квадратные матрицы $[3 times 3] times [3 times 3]$<->],
        $mat(1, 2, 3; 4, 5, 6; 7, 8, 9)$,
        $mat(9, 8, 7; 6, 5, 4; 3, 2, 1)$,
        $mat(30, 24, 18; 84, 69, 54; 138, 114, 90)$,
      ),
      ..test(
        2,
        [Строка на столбец],
        $mat(2, 3, 4)$,
        $mat(1; 2; 3)$,
        $mat(20)$,
      ),
      ..test(
        3,
        [Столбец на строку],
        $mat(1; 2)$,
        $mat(3, 4)$,
        $mat(3, 4; 6, 8)$,
      ),
      ..test(
        4,
        [Умножение на единичную матрицу],
        $mat(1, 2; 3, 4)$,
        $mat(1, 0; 0, 1)$,
        $mat(1, 2; 3, 4)$,
      ),
      ..test(
        5,
        [Умножение на нулевую матрицу],
        $mat(1, 2; 3, 4)$,
        $mat(0, 0; 0, 0)$,
        $mat(0, 0; 0, 0)$,
      ),
      ..test(
        6,
        [Матрицы из одного элемента],
        $mat(5)$,
        $mat(-3)$,
        $mat(-15)$,
      ),
      ..test(
        7,
        [Нечётная внутренняя размерность $[2 times 3] times [3 times 2]$<->],
        $mat(1, 0, 2; 0, 1, 1)$,
        $mat(1, 2; 3, 4; 5, 6)$,
        $mat(11, 14; 8, 10)$,
      ),
      ..test(
        8,
        [Отрицательные элементы],
        $mat(-1, 2; 3, -4)$,
        $mat(2, -1; -3, 4)$,
        $mat(-8, 9; 18, -19)$,
      ),
      ..test(
        9,
        [Матрица из нулевого и единичного столбцов],
        $mat(0, 1; 0, 1)$,
        $mat(1, 1; 1, 1)$,
        $mat(1, 1; 1, 1)$,
      ),
      ..test(
        10,
        [Несимметричные матрицы $[2 times 2] times [2 times 2]$<->],
        $mat(1, 2; 0, 1)$,
        $mat(1, 0; 3, 1)$,
        $mat(7, 2; 3, 1)$,
      ),
      ..test(
        11,
        [Прямоугольные матрицы $[3 times 2] times [2 times 3]$<->],
        $mat(1, 2; 3, 4; 5, 6)$,
        $mat(1, 0, 1; 0, 1, 1)$,
        $mat(1, 2, 3; 3, 4, 7; 5, 6, 11)$,
      ),
      [12],
      [Несогласованные размеры],
      [$A$ размером $2 times 3$, $B$ размером $2 times 2$],
      [Сообщение об ошибке],
      [Сообщение об ошибке],
    ),
    caption: [Функциональные тесты],
  )<tbl:tests>
]

Все тесты пройдены.

#heading(numbering: none, level: 2, outlined: false, [Вывод])

#text(size: 20pt, fill: gray)[Что делали и получили в результате]

#pagebreak(weak: true)
