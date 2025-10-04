#import "@preview/codly:1.3.0"
#import "@preview/codly-languages:0.1.8": *
#import "@preview/i-figured:0.2.4"

#let bmstu_config(content) = {
    /**
     * Настройка шрифта и языка документа
     */
    set text(
        font: "New Computer Modern",
        lang: "ru",
        size: 12pt,
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
        linebreaks: "simple",
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
    show outline: it => {
        show heading: title => {
            align(center, title)
            v(1em, weak: true)
        }
        it
        pagebreak(weak: true)
    }
    set outline.entry(fill: repeat(text(weight: "regular")[.], gap: 0.2em))
    show outline.entry.where(level: 1): it => {
        v(1.5em, weak: true)
        set text(weight: "bold")
        it
    }

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
    show heading: i-figured.reset-counters

    /**
     * Настройка подписей к фигурам
     */
    set figure.caption(separator: [~---~])
    show figure.caption: set par(leading: 0.5em, justify: true)
    show figure.where(kind: image): set figure(supplement: [Рисунок])
    show figure.where(kind: "i-figured-image"): it => {
        block(it.body, sticky: true)
        it.caption
    }

    /**
     * Общие настройки для всех фигур
     */
    show figure: i-figured.show-figure // Нумерация по заголовкам
    show figure: it => {
        set block(breakable: true)
        v(1.5em, weak: true)
        it
        v(1.5em, weak: true)
    }

    /**
     * Настройка таблиц
     */
    show figure.where(kind: table): it => {
        set figure.caption(position: top)
        show figure.caption: it => {
            set block(sticky: true)
            align(left, it)
            v(-0.2em, weak: false)
        }
        it
    }

    /**
     * Настройка блоков кода, вложенных в figure
     */
    show figure.where(kind: "i-figured-raw"): it => {
        set block(breakable: true)
        set text(size: 12pt)
        block(it.body, sticky: true)
        it.caption
    }

    show: codly.codly-init
    codly.codly(
        display-icon: false,
        display-name: false,
        languages: codly-languages,
        number-align: right,
        radius: 0pt,
        skip-line: align(center, "..."),
        skip-number: align(left, "..."),
        smart-skip: true,
        stroke: black + 0.8pt,
        zebra-fill: none,
    )

    /**
     * Настройка списков
     */

    // @typstyle off
    let rus_letters = ("а", "б", "в", "г", "д", "е", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я")
    // @typstyle on
    let enum-numbering(n) = { [#rus_letters.at(n - 1))] }

    set list(
        indent: 1.25cm,
        marker: [---],
    )
    show list: it => {
        set enum(numbering: enum-numbering)
        it
    }

    set enum(
        indent: 1.25cm,
        numbering: "1)",
    )
    // Нумерация вложенных списков кириллическими буквами
    show enum: outer => {
        show enum: inner => {
            set enum(numbering: enum-numbering)
            inner
        }
        outer
    }

    /**
     * Настройка формул
     */
    show math.equation.where(block: true): it => {
        v(2em, weak: true)
        it
        v(2em, weak: true)
    }
    show math.equation: i-figured.show-equation // Нумерация по заголовкам
    show sym.integral: math.limits
    show sym.integral.double: math.limits
    show sym.integral.triple: math.limits
    show sym.integral.quad: math.limits
    show sym.integral.cont: math.limits
    show sym.integral.surf: math.limits
    show sym.integral.vol: math.limits
    show sym.lt.eq: sym.lt.slant
    show sym.gt.eq: sym.gt.slant

    /**
     * Настройка библиографии
     */
    set bibliography(style: "gost-r-7-0-5-2008-numeric.csl", title: [СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ])
    show bibliography: it => {
        pagebreak(weak: true)
        show heading: title => {
            align(center, title)
            v(2em, weak: true)
        }
        show link: it => context {
            let size = measure(it)
            if size.width < (page.width - page.margin.left - page.margin.right) {
                box(it)
            } else {
                it
            }
        }
        it
        pagebreak(weak: true)
    }

    content
}

