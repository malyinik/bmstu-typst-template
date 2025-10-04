#import "template/bmstu.typ": *

#titlepage.create[
    #titlepage.header(
        faculty: "Информатика и системы управления",
        department: "Программное обеспечение ЭВМ и информационные технологии",
    )

    #titlepage.body()[
        #align(center, [
            #text(weight: "bold", size: 20pt, [Лабораторная работа № N \ по дисциплине "Анализ алгоритмов"])
        ])
        #v(33mm)
        #widgets.form_field(
            font_size: 14pt,
            label: [*Тема*],
            value: [],
            length: 7.3cm,
            hint: "",
        )
        #v(1em)
    ]

    #titlepage.footer(content: grid(
        columns: (40%, 30%, 30%),
        align: (left, right, right),
        row-gutter: 7mm,
        [#widgets.form_field(
            label: "Студент",
            value: "ИУ7-51Б",
            hint: "(Группа)",
            length: 25mm,
        )],
        [#widgets.form_field(
            label: "",
            value: "",
            hint: "(Подпись, дата)",
            length: 95%,
        )],
        [#widgets.form_field(
            label: "",
            value: "И. И. Иванов",
            hint: "(И. О. Фамилия)",
            length: 95%,
        )],

        [#widgets.form_field(
            label: "Преподаватель",
            value: "",
            hint: "",
            length: 0mm,
        )],
        [#widgets.form_field(
            label: "",
            value: "",
            hint: "(Подпись, дата)",
            length: 95%,
        )],
        [#widgets.form_field(
            label: "",
            value: "П. П. Петров",
            hint: "(И. О. Фамилия)",
            length: 95%,
        )],
    ))
]
