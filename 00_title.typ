#import "template/bmstu.typ": *

#titlepage.create[
  #titlepage.header(
    faculty: "Информатика и системы управления",
    department: "Программное обеспечение ЭВМ и информационные технологии",
  )

  #titlepage.body()[
    #align(center, [
      #text(size: 18pt)[
        *РАСЧЁТНО-ПОЯСНИТЕЛЬНАЯ ЗАПИСКА*

        _К КУРСОВОЙ РАБОТЕ \ НА ТЕМУ:_

        _"Тема курсовой работы"_
      ]
    ])
    #v(33mm)
    #v(1em)
  ]

  #titlepage.footer(content: grid(
    columns: (44%, 28%, 28%),
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
      label: "Руководитель курсовой работы",
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
