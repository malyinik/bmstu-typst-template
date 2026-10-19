#import "template/bmstu.typ": *

// По умолчанию внизу страницы выводится только год на момент сборки.
// Город и другой год задаются параметрами: #titlepage.create(city: "Москва", year: 2026)[...].
#titlepage.create[
  #titlepage.header(
    faculty: "Информатика и системы управления",
    faculty_code: "ИУ",
    department: "Программное обеспечение ЭВМ и информационные технологии",
    department_code: "ИУ7",
    // Необязательное поле, его можно удалить.
    // field_of_study: "09.03.04 Программная инженерия",
  )

  #titlepage.body()[
    #align(center, text(weight: "bold")[ОТЧЁТ \ по лабораторной работе № 1])
    #v(33mm)
    *Название:* "Численное интегрирование"
    #v(1em)
    *Дисциплина:* "Вычислительные алгоритмы"
  ]

  #titlepage.footer(content: grid(
    columns: (40%, 30%, 30%),
    align: (left, right, right),
    row-gutter: 7mm,
    [#widgets.form_field(
      label: "Студент",
      value: "ИУ7-41Б",
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
      value: "И.И. Иванов",
      hint: "(И.О. Фамилия)",
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
      value: "П.П. Петров",
      hint: "(И.О. Фамилия)",
      length: 95%,
    )],
  ))
]
