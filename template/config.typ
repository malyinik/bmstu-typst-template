#import "widgets.typ"

#let bmstu_config(content) = {
    set text(size: 14pt, font: "Times New Roman", lang: "ru")
    set par(justify: true, first-line-indent: (amount: 12.5mm, all: true), leading: 1em, spacing: 1em)
    set page(margin: (left: 30mm, right: 10mm, top: 20mm, bottom: 20mm), numbering: "1", supplement: [стр.])
    set outline(title: "СОДЕРЖАНИЕ")
    show outline: it => {
        show heading: set align(center)
        it
    }
    set heading(numbering: "1.1")

    set figure.caption(separator: [ --- ])
    show figure.where(kind: image): set figure.caption(position: bottom)
    show figure.where(kind: table): set figure.caption(position: top)
    show figure.where(kind: raw): set figure.caption(position: top)

    /**
     * TODO: Настроить содержание
     * TODO: Настроить списки
     * TODO: Настроить формулы
     * TODO: Настроить таблицы
     * TODO: Настроить заголовки
     * TODO: Настроить листинг
     */

    content
}

