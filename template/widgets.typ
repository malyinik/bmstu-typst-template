#let form_field(label: "Label", value: "Value", hint: "hint", length: 40mm, font_size: 12pt, align: (right, center)) = {
    box(grid(
        columns: (auto, auto),
        align: align,
        row-gutter: (0.3em, 1mm),
        column-gutter: (0.4em, 1mm),
        [#text(size: font_size, [#label])], [#text(size: font_size, [#value])],
        [], [#line(length: length, stroke: 0.5pt)],
        [], [#text(size: 9pt, [#hint])],
    ))
}
