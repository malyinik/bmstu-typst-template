#import "widgets.typ"

#let header(faculty: "", department: "", field_of_study: "") = {
    grid(
        columns: (auto, auto),
        align: (left, center + horizon),
        inset: (left: -4mm),
        [
            #image("images/bmstu_logo.svg", height: 36mm)
        ],
        [
            #set text(weight: "bold")
            #set par(leading: 0.5em)
            Министерство науки и высшего образования Российской Федерации \
            Федеральное государственное автономное образовательное \
            учреждение высшего образования \
            "Московский государственный технический университет \
            имени Н.~Э.~Баумана \
            (национальный исследовательский университет)" \
            (МГТУ им. Н.~Э.~Баумана)
        ],
    )

    v(-3.2mm)
    line(length: 100%, stroke: 0.9mm)
    v(-2.9mm)
    line(length: 100%, stroke: 0.2mm)
    v(1.8mm)

    widgets.form_field(
        label: "ФАКУЛЬТЕТ",
        value: ["#faculty"],
        hint: "",
        length: 100%,
        align: left,
    )
    v(-2.5mm)
    widgets.form_field(
        label: "КАФЕДРА",
        value: ["#department"],
        hint: "",
        length: 100%,
        align: left,
    )
    v(-2.5mm)
    if field_of_study != "" {
        widgets.form_field(
            label: "НАПРАВЛЕНИЕ ПОДГОТОВКИ",
            value: ["#field_of_study"],
            hint: "",
            length: 100%,
            align: left,
        )
    } else {
        hide(widgets.form_field())
    }
    v(20mm)
}

#let body(font_size: 14pt, content) = {
    set text(size: font_size)
    set par(leading: 1em)
    content
}

#let footer(content: grid()) = {
    place(bottom, dy: -3cm, content)
}

#let create(
    city: "",
    year: datetime.today().year(),
    doc,
) = {
    set par(
        justify: false,
        first-line-indent: 0pt,
        spacing: 1em,
    )
    set text(
        size: 11pt,
        font: "New Computer Modern",
        lang: "ru",
    )
    set page(
        margin: (
            left: 30mm,
            right: 10mm,
            top: 20mm,
            bottom: 20mm,
        ),
        numbering: none,
        footer: [
            #set align(center)
            #set text(size: 14pt, style: "italic")
            #if city != "" {
                [#city,]
            }
            #year~г.
        ],
        footer-descent: 0cm,
    )
    doc
    pagebreak()
}
