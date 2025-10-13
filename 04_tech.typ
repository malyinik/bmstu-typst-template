#import "@preview/i-figured:0.2.4"

= Технологическая часть

#text(size: 20pt, fill: gray)[
    Пишем всё про реализацию: какие языки, какие IDE и т.д.; коды алгоритмов/программы.

    Тестовые данные и волшебные слова "все тесты пройдены успешно".
]

Визуализация результатов исследования выполнялась с помощью библиотеки для построения графиков Lilaq в системе вёрстки Typst~@lilaq.

== #lorem(2)

На @lst:classic[листинге] #lorem(15).

#figure(
    raw(read("listings/classic.cpp"), lang: "cpp", block: true),
    caption: [Подпись к листингу],
)<classic>

== #lorem(6)

В @tbl:tests[таблице] #lorem(19)

#[
    #show table: set par(justify: false)
    #show table.cell.where(y: 0): strong
    #show math.equation.where(block: true): set text(size: 10pt)
    #show math.equation.where(block: false): it => { box(it) }
    #figure(
        table(
            columns: (auto, auto, auto, auto, auto),
            align: horizon,
            table.header([№ \ теста], [Описание], [Входные данные], [Эталонный результат], [Фактический результат]),
            [1],
            [Матрицы $[3 times 3] times [3 times 3]$<->],
            [$
                A & = mat(1, 2, 3; 4, 5, 6; 7, 8, 9) \
                B & = mat(9, 8, 7; 6, 5, 4; 3, 2, 1)
            $<->],
            [$ C = mat(30, 24, 18; 84, 69, 54; 138, 114, 90) $<->],
            [$ C = mat(30, 24, 18; 84, 69, 54; 138, 114, 90) $<->],

            [2],
            [Матрицы $[3 times 3] times [3 times 3]$<->],
            [$
                A & = mat(1, 2, 3; 4, 5, 6; 7, 8, 9) \
                B & = mat(9, 8, 7; 6, 5, 4; 3, 2, 1)
            $<->],
            [$ C = mat(30, 24, 18; 84, 69, 54; 138, 114, 90) $<->],
            [$ C = mat(30, 24, 18; 84, 69, 54; 138, 114, 90) $<->],

            [3],
            [Матрицы $[3 times 3] times [3 times 3]$<->],
            [$
                A & = mat(1, 2, 3; 4, 5, 6; 7, 8, 9) \
                B & = mat(9, 8, 7; 6, 5, 4; 3, 2, 1)
            $<->],
            [$ C = mat(30, 24, 18; 84, 69, 54; 138, 114, 90) $<->],
            [$ C = mat(30, 24, 18; 84, 69, 54; 138, 114, 90) $<->],

            [4],
            [#lorem(33)],
            [$
                A & = mat(2, 3, 4) \
                B & = mat(1; 2; 3)
            $<->],
            [$ C = mat(20) $<->],
            [$ C = mat(20) $<->],
        ),
        caption: [Подпись к таблице],
    )<tests>

    #counter(figure.where(kind: "i-figured-table")).update(n => n - 1)
    #figure(
        table(
            columns: (auto, auto, auto, auto, auto),
            align: horizon,
            table.header([№ \ теста], [Описание], [Входные данные], [Эталонный результат], [Фактический результат]),

            [9], [#lorem(10)], [#lorem(10)], [#lorem(10)], [#lorem(10)],
        ),
        caption: [Продолжение @tbl:tests[таблицы]],
        supplement: none,
    )
]

#heading(numbering: none, level: 2, outlined: false, [Вывод])

#text(size: 20pt, fill: gray)[Что делали и получили в результате]

#pagebreak(weak: true)
