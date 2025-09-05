#import "widgets.typ"

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *

#let bmstu_config(content) = {
    /**
     * Настройка шрифта и языка документа
     */
    set text(
        font: "Times New Roman",
        lang: "ru",
        size: 14pt,
    )

    /**
     * Настройка абзацев
     */
    set par(
        first-line-indent: (
            amount: 1.25cm,
            all: true,
        ),
        justify: true,
        leading: 1em,
        spacing: 1em,
    )

    /**
     * Настройка страницы
     */
    set page(
        margin: (
            left: 30mm,
            right: 10mm,
            top: 20mm,
            bottom: 20mm,
        ),
        number-align: center,
        numbering: "1",
    )

    /**
     * Настройка содержания
     */
    set outline(title: "СОДЕРЖАНИЕ")
    show outline: set align(center)

    /**
     * Настройка заголовков
     */
    set heading(numbering: "1.1")
    show heading: it => {
        set text(size: 16pt, hyphenate: false)
        v(2em, weak: true)
        pad(
            left: 1.25cm,
            it,
        )
        v(2em, weak: true)
    }

    /**
     * Настройка подписей к фигурам
     */
    set figure.caption(separator: [ --- ])
    show figure.caption: set par(leading: 0.5em, justify: true)
    show figure.where(kind: image): set figure(supplement: [Рисунок])
    show figure.where(kind: image): it => {
        set figure.caption(position: bottom)
        it
    }

    /**
     * Общие настройки для всех фигур
     */
    show figure: it => {
        it
        v(0.5em)
    }

    /**
     * Настройка таблиц
     * TODO: Добавить подписи к продолжениям таблиц, рисунков и листингов, если они переносятся на следующую страницу
     * BUG: Заголовок таблицы может остаться на предыдущей странице
     */
    show figure.where(kind: table): it => {
        set block(breakable: true)
        set figure.caption(position: top)
        block(align(left)[
            #it.caption
            #v(6pt, weak: true)
            #it.body
        ])
    }

    /**
     * Настройка блоков кода, вложенных в figure
     */
    show figure.where(kind: raw): it => {
        set block(breakable: true)
        set figure.caption(position: bottom)
        show figure.caption: set text(size: 14pt)
        set text(size: 12pt)
        it
    }

    show: codly-init
    codly(
        display-icon: false,
        display-name: false,
        languages: codly-languages,
        number-align: right,
        skip-line: align(center, "..."),
        skip-number: align(left, "..."),
        smart-skip: true,
        stroke: black + 0.8pt,
        zebra-fill: none,
    )

    /**
     * Настройка списков
     * TODO: Нумерация вложенных списков кириллическими буквами
     */
    set list(
        indent: 1.25cm,
        marker: [--],
    )

    set enum(
        indent: 1.25cm,
        numbering: "1.a)",
    )

    /**
     * TODO: Настроить формулы
     */

    content
}

