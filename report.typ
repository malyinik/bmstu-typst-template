#import "template/bmstu.typ": *

#titlepage.create(
    author: "Автор",
    group: "Группа",
)[
    #titlepage.header(
        faculty: "Информатика, искусственный интеллект и системы управления",
        department: "Программное обеспечение ЭВМ и информационные технологии",
        field_of_study: "09.03.04 Программная инженерия", // Необязательное поле, можно удалить
    )

    #titlepage.body()[
        #align(center, [
            #text(weight: "bold", [ОТЧЁТ \ по лабораторной работе № X])
        ])
        #v(33mm)
        *Название:* "Название работы"
        #v(1em)
        *Дисциплина:* "Название дисциплины"
    ]

    #titlepage.footer(content: grid(
        columns: (40%, 30%, 30%),
        align: (left, right, right),
        row-gutter: 7mm,
        [#widgets.form_field(label: "Студент", value: "ИУ7-41Б", hint: "(Группа)", length: 25mm)],
        [#widgets.form_field(label: "", value: "", hint: "(Подпись, дата)", length: 95%)],
        [#widgets.form_field(label: "", value: "И. О. Фамилия", hint: "(И. О. Фамилия)", length: 95%)],

        [#widgets.form_field(label: "Преподаватель", value: "", hint: "", length: 0mm)],
        [#widgets.form_field(label: "", value: "", hint: "(Подпись, дата)", length: 95%)],
        [#widgets.form_field(label: "", value: "И. О. Фамилия", hint: "(И. О. Фамилия)", length: 95%)],
    ))
]

#show: config.bmstu_config

#outline()
#pagebreak()

#align(center, heading(numbering: none)[ОСНОВНАЯ ЧАСТЬ])

= Заголовок первого уровня

#lorem(20)

#heading(numbering: none, level: 2, outlined: false)[Не отслеживаемый заголовок второго уровня без номера]

#lorem(50)

#figure(image("template/images/bmstu_logo.svg", width: 50%), caption: "Герб МГТУ", supplement: "Рисунок")<img-Герб>

Ссылки:
- @img-Герб[Рисунке]
- @img-Герб[Изображении]
- @img-Герб[Фотографии]
- см. @img-Герб

#lorem(17)

#pagebreak()
#figure(
    table(
        columns: (50%, 25%, 25%),
        align: (right + horizon, left, left),
        rows: auto,
        table.header([Формула], [Изображение], [Описание]),
        [$integral_(-infinity)^(+infinity) f(x) d x$], [#image("template/images/bmstu_logo.svg", width: 30mm)], [Текст],
    ),
    caption: "Подпись к таблице",
)

#figure(
    ```cpp
    int main()
    {
        for (int i = 0; i < 10; i++) {
            std::cout << i << std::endl;
        }
        return EXIT_SUCCESS;
    }
    ```,
    caption: [Длинная подпись к блоку кода, занимающая несколько строк (межстрочный интервал меньше)],
)<lst-Цикл>

Ссылка на @lst-Цикл[листинг].

#lorem(30)
$
    "Формула:" mat(
        a, b, c;
        x, x + y, x + y + z;
    )
$

== Заголовок второго уровня

#lorem(60)

#[
    #set par(justify: false)
    #figure(
        table(
            columns: (25%, auto),
            table.header([*Первая колонка*], [*Вторая колонка*]),
            [#lorem(5)], [#lorem(30)],
            [#lorem(3)], [#lorem(20)],
            [#lorem(8)], [#lorem(42)],
        ),
        caption: [Таблица с переносом на следующую страницу],
    )<таблица-с-переносом>
]

В таблице с переносом (@таблица-с-переносом[таблица]) у первой строки на следующей странице остаётся пустая ячейка.

#lorem(50)

=== Заголовок третьего уровня

#lorem(75)

#lorem(50)

== Списки

#lorem(25)

- Пункт 1
- Пункт 2
    - Подпункт 1
    - Подпункт 2
- Пункт 3
    - Подпункт 1
        - Подподпункт 1

#lorem(55)

+ Пункт 1
+ Пункт 2
    + Подпункт 1
    + Подпункт 2
+ Пункт 3
    + Подпункт 1
        + Подподпункт 1

#lorem(55)

#pagebreak()
#align(center, heading(numbering: none)[ЗАКЛЮЧЕНИЕ])

#lorem(120)
