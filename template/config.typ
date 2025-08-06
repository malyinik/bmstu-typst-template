#import "widgets.typ"



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
        pad(left: 1.25cm, it)
        v(10pt)
    }

    /**
     * Настройка подписей к фигурам
     */
    set figure.caption(separator: [ --- ])
    show figure.where(kind: image): it => {
        set figure.caption(position: bottom)
        it
    }

    /**
     * Настройка таблиц
     * TODO: Добавить подписи к продолжениям таблиц, рисунков и листингов, если они переносятся на следующую страницу
     */
    show figure.where(kind: table): set figure(gap: 6pt)
    show figure.where(kind: table): it => {
        set block(breakable: true)
        set figure.caption(position: top)
        align(left, it)
    }

    /**
     * Настройка блоков кода, вложенных в figure
     */
    show figure.where(kind: raw): it => {
        set figure.caption(position: bottom)
        it
    }
     * TODO: Настроить формулы
     * TODO: Настроить таблицы
     * TODO: Настроить заголовки
     * TODO: Настроить листинг
     */

    content
}

