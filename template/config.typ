#import "widgets.typ"

// Параметры шрифта
#let font_config = (
    font: "Times New Roman",
    size: 14pt,
)

// Основной язык документа
#let document_language = "ru"

// Параметры абзаца
#let paragraph_config = (
    justify: true,
    indent: 12.5mm,
    spacing_between_lines: 1em,
    spacing_between_paragraphs: 1em,
)

// Параметры страницы
#let page_config = (
    numbering: "1",
    number_align: center,
    margin: (left: 30mm, right: 10mm, top: 20mm, bottom: 20mm),
)

// Параметры содержания
#let toc_config = (
    title: "СОДЕРЖАНИЕ",
    align: center,
)

// Параметры заголовков
#let heading_config = (
    numbering: "1.1",
    size: font_config.size + 2pt,
    spacing_after: font_config.size - 4pt,
)


// Параметры таблиц
#let table_config = (
    caption_vertical_space: 5pt,
    align: left,
    caption_position: top,
)

// Параметры блоков кода
#let code_block_config = (
    caption_vertical_space: 5pt,
    align: left,
    caption_position: top,
)

#let bmstu_config(content) = {
    set text(size: font_config.size, font: font_config.font, lang: document_language)

    set par(
        justify: paragraph_config.justify,
        first-line-indent: (amount: paragraph_config.indent, all: true),
        leading: paragraph_config.spacing_between_lines,
        spacing: paragraph_config.spacing_between_paragraphs,
    )

    set page(margin: page_config.margin, numbering: page_config.numbering, number-align: page_config.number_align)

    set outline(title: toc_config.title)
    show outline: it => {
        show heading: set align(toc_config.align)
        it
    }

    set heading(numbering: heading_config.numbering)
    show heading: it => {
        set text(size: heading_config.size)
        it
        v(heading_config.spacing_after)
    }

    set figure.caption(separator: [ --- ])
    show figure.where(kind: image): set figure.caption(position: bottom)

    // Настройка таблиц
    show figure.where(kind: table): set figure(gap: table_config.caption_vertical_space)
    show figure.where(kind: table): set figure.caption(position: table_config.caption_position)
    show figure.where(kind: table): it => align(table_config.align)[#it]

    // Настройка блоков кода
    show figure.where(kind: raw): it => align(code_block_config.align)[#it]
    show figure.where(kind: raw): set figure.caption(position: code_block_config.caption_position)

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

