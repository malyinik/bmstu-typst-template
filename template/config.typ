#import "continuation.typ": with-continuation
#import "listings.typ": code-block
#import "numbering.typ": by-chapter, equation-numbering, figure-numbering

// Буквы для обозначения приложений: по ГОСТ 7.32-2017 (п. 6.17.4) не используются Ё, З, Й, О, Ч, Ъ, Ы и Ь.
// @typstyle off
#let cyrillic-upper = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")
// @typstyle on

#let cyrillic-numbering(..nums) = {
  let numbers = nums.pos()
  if numbers.len() == 0 {
    return ""
  }
  let first = cyrillic-upper.at(numbers.first() - 1)
  if numbers.len() == 1 {
    return first
  }
  first + "." + numbers.slice(1).map(str).join(".")
}

#let font_name = "Times New Roman"

/**
 * Оформление расчётно-пояснительной записки.
 * Подключается в главном файле через `#show: config.bmstu_config`.
 *
 * Параметр `numbering-by-chapter` выбирает нумерацию рисунков, таблиц, листингов и формул.
 * При `true` они нумеруются в пределах раздела (1.1, 2.1), при `false` сквозь весь документ (1, 2, 3).
 * Оба режима предусмотрены ГОСТ 7.32-2017, пп. 6.5.4, 6.5.6, 6.6.4, 6.8.5.
 * В приложениях нумерация в обоих режимах идёт в пределах приложения (А.1, Б.1).
 *
 * Параметр `code-highlighting` включает подсветку синтаксиса в блоках кода.
 * При `false` код выводится без подсветки, и язык, указанный у блоков, менять не нужно.
 */
#let bmstu_config(numbering-by-chapter: true, code-highlighting: true, content) = {
  /**
   * Настройка шрифта и языка документа
   */
  set text(
    font: (font_name, "New Computer Modern"),
    lang: "ru",
    size: 14pt,
    overhang: false,
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
    linebreaks: "optimized",
    leading: 1em,
    spacing: 1em,
    justification-limits: (
      // Трекинг только растягивает строку, потому что сжимающий трекинг сужает и межсловный промежуток.
      // Пробел в PDF заменён сдвигом, и PyMuPDF (через него текст читает CI кафедры) склеивает слова, если промежуток уже 0,15 кегля.
      // Стандартное сжатие пробела до 2/3 вместе с отрицательным трекингом опускало промежуток ниже этого порога.
      tracking: (min: 0em, max: 0.01em),
    ),
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
  // Строка содержания собирается вручную: подразделы сдвигаются ровно на ширину номера родителя, а у приложений буква идёт после слова ("ПРИЛОЖЕНИЕ А").
  // Со стандартной строкой TestVkr принимает более глубокий сдвиг подразделов за неверный абзацный отступ и не находит приложение в содержании.
  show outline.entry: it => context {
    set par(first-line-indent: (amount: 0cm, all: true))

    let number = if it.element.numbering != none {
      numbering(it.element.numbering, ..counter(heading).at(it.element.location()))
    }
    let title = it.body()
    let page-num = it.page()

    // Отступы по уровню заголовка
    if it.level == 1 {
      h(0em)
    } else if it.level == 2 {
      h(measure([1~]).width)
    } else if it.level == 3 {
      h(measure([1~1.1~]).width)
    } else {
      h(measure([1~1.1~1.1.1~]).width + 0.2em)
    }

    if it.element.supplement == [Приложение] and it.level == 1 {
      link(it.element.location())[#title #number]
    } else if number != none {
      [#number #link(it.element.location(), title)]
    } else {
      link(it.element.location(), title)
    }

    h(0.3em)
    box(width: 1fr, repeat(text(weight: "regular")[.], gap: 0.2em))
    h(0.3em)
    page-num
    linebreak()
  }
  show outline.entry.where(level: 1): it => {
    v(1.5em, weak: true)
    set text(weight: "bold")
    it
  }

  /**
   * Настройка заголовков
   */
  let structural_elements = (
    [ВВЕДЕНИЕ],
    [РЕФЕРАТ],
    [СОДЕРЖАНИЕ],
    [СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ],
    [ЗАКЛЮЧЕНИЕ],
    [ПРИЛОЖЕНИЕ А],
    [ПРИЛОЖЕНИЕ Б],
    [ПРИЛОЖЕНИЕ В],
    [ПРИЛОЖЕНИЕ Г],
  )
  set heading(numbering: "1.1")
  show heading.where(level: 4): set heading(numbering: none, outlined: false)
  show heading.where(level: 5): set heading(numbering: none, outlined: false)
  show heading: it => {
    set text(size: 16pt, hyphenate: false)
    v(1.5em, weak: true)
    pad(
      left: if it.body not in structural_elements {
        1.25cm
      } else {
        0cm
      },
      it,
    )
    v(1.5em, weak: true)
  }

  /**
   * Настройка подписей к фигурам
   */
  set figure.caption(separator: [~---~])
  show figure.caption: set par(leading: 0.5em, justify: true)
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: image): it => {
    block(it.body, sticky: true)
    it.caption
  }

  /**
   * Настройка таблиц
   */
  show table: set text(size: 12pt)
  show figure.where(kind: table): it => {
    set par(justify: false, leading: 0.5em)
    set figure.caption(position: top)
    show figure.caption: it => {
      set block(sticky: true)
      align(left, it)
      v(-0.2em, weak: false)
    }
    // Часть таблицы, перенесённая на следующую страницу, начинается строкой "Продолжение таблицы N".
    show table: body => with-continuation(body, it, "таблицы")
    it
  }

  /**
   * Настройка блоков кода
   */
  show raw.where(block: true): it => code-block(it, highlight: code-highlighting)
  // Часть листинга, перенесённая на следующую страницу, начинается строкой "Продолжение листинга N".
  // Подпись выводится внутри блока кода, чтобы не отрываться от последних строк, поэтому шрифт и кегль текста закрепляются за ней заранее.
  show figure.where(kind: raw): it => context {
    let caption = text(font: text.font, size: text.size, pad(top: 1em, it.caption))
    set block(breakable: true)
    set text(size: 10pt)
    show raw.where(block: true): code => code-block(code, highlight: code-highlighting, caption: caption)
    with-continuation(it.body, it, "листинга")
  }

  /**
   * Общие настройки для всех фигур
   *
   * Правило объявлено после правил отдельных видов фигур, поэтому применяется к фигуре раньше них.
   * Правила рисунков и листингов возвращают тело и подпись вместо фигуры, и объявленное до них правило до фигуры бы не дошло.
   */
  set figure(numbering: figure-numbering)
  show figure: it => {
    set block(breakable: true)
    v(1.5em, weak: true)
    it
    v(1.5em, weak: true)
  }

  /**
   * Настройка списков
   */

  // @typstyle off
  let rus_letters = ("а", "б", "в", "г", "д", "е", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я")
  // @typstyle on
  let enum-numbering(n) = { [#rus_letters.at(n - 1))] }

  // Элемент списка оформляется как обычный абзац: маркер стоит на абзацном отступе, а перенесённые строки начинаются от левого поля.
  // При стандартной вёрстке перенесённые строки выравниваются по тексту после маркера, и TestVkr считает их отступ неверным.
  // Первая строка вложенного элемента начинается под текстом родительского, поэтому её отступ больше на ширину маркера родителя вместе с пробелом.
  // Накопленный отступ передаётся вложенным спискам через их поле indent.
  // Эти правила объявлены раньше остальных правил списков и поэтому применяются последними, когда маркер и нумерация уже выбраны.
  let list-items(it, marker) = for (i, item) in it.children.enumerate() {
    let label = marker(i, item)
    parbreak()
    context {
      let width = measure([#label~]).width
      set par(first-line-indent: (amount: it.indent, all: true))
      set list(indent: it.indent + width)
      set enum(indent: it.indent + width)
      [#box(width: width, label)#item.body]
    }
    parbreak()
  }
  show list: it => list-items(it, (..) => {
    if type(it.marker) == array {
      it.marker.first()
    } else {
      it.marker
    }
  })
  show enum: it => list-items(it, (i, item) => {
    let number = if type(item.number) == int {
      item.number
    } else if type(it.start) == int {
      it.start + i
    } else {
      i + 1
    }
    numbering(it.numbering, number)
  })

  set list(indent: 1.25cm, marker: [---])
  show list: it => {
    set enum(numbering: enum-numbering)
    it
  }

  set enum(indent: 1.25cm, numbering: "1)")
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
  show math.equation.where(block: false): set math.frac(style: "horizontal")
  set math.equation(numbering: equation-numbering)
  // Формула с меткой <-> не нумеруется.
  show <->: set math.equation(numbering: none)
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
   * Пояснение обозначений под формулой
   *
   * Абзац, который начинается со слова "где", считается пояснением к формуле и пишется без абзацного отступа (ГОСТ 7.32-2017, п. 6.8.2).
   * Если пояснения разделены переносом строки "\", слово "где" стоит у левого поля, а каждое пояснение начинается на абзацном отступе, как в образце из приложения к положению о нормоконтроле.
   */
  show par: it => {
    // Готовый абзац пояснения уже без отступа, и проверка не даёт правилу применяться к собственному результату.
    if it.first-line-indent.amount == 0pt {
      return it
    }
    let children = if it.body.func() == [].func() {
      it.body.children
    } else {
      (it.body,)
    }
    let first = children.at(0, default: none)
    let starts-with-where = (
      first != none and first.has("text") and (first.text == "где" or first.text.starts-with("где "))
    )
    if not starts-with-where {
      return it
    }

    let no-indent = (amount: 0pt, all: true)
    if not children.any(c => c.func() == linebreak) {
      return par(first-line-indent: no-indent, it.body)
    }
    // Слово "где" убирается из начала текста и ставится в ячейку шириной в абзацный отступ, а перенесённые строки выравниваются по её правому краю.
    let rest = if first.text == "где" {
      children.slice(1)
    } else {
      (first.text.slice("где ".len()),) + children.slice(1)
    }
    if rest.len() > 0 and rest.first() == [ ] {
      rest = rest.slice(1)
    }
    par(
      first-line-indent: no-indent,
      hanging-indent: 1.25cm,
      box(width: 1.25cm)[где] + rest.join(),
    )
  }

  /**
   * Настройка библиографии
   */
  set bibliography(
    style: "gost-r-7-0-5-2008-numeric.csl",
    title: [СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ],
  )
  show bibliography: it => {
    pagebreak(weak: true)
    // Запись оформляется как обычный абзац: номер стоит на абзацном отступе, а перенесённые строки начинаются от левого поля, как в списках.
    // Выравнивание номеров отдельной колонкой (second-field-align в CSL) TestVkr принимает за неверный отступ, поэтому в стиле оно отключено.
    // Typst кладёт каждую запись в отдельный блок без абзаца, и выключка по ширине к таким строкам применяется не всегда, поэтому блок заменяется абзацем.
    // Блоки без содержимого и заголовок списка правило пропускает.
    show block: entry => if entry.body in (none, auto) or entry.body == it.title {
      entry
    } else {
      par(entry.body)
    }
    show heading: title => align(center, title)
    show link: it => context {
      let size = measure(it)
      if size.width < (page.width - page.margin.left - page.margin.right) * 0.4 {
        box(it)
      } else {
        it
      }
    }
    it
    pagebreak(weak: true)
  }

  /*
   * Настройка ссылки на источник
   */
  show cite: it => {
    box(it)
  }

  by-chapter.update(numbering-by-chapter)
  content
}

/**
 * Оформление приложений: буквенная нумерация заголовков, рисунков, таблиц, листингов и формул.
 * Подключается в начале файла приложений через `#show: appendices` и действует до конца файла.
 */
#let appendices(content) = {
  // Заголовок первого уровня с текстом "ПРИЛОЖЕНИЕ" получает букву после слова, а подразделы нумеруются в пределах приложения с буквой впереди: А.1, А.1.1.
  set heading(
    supplement: [Приложение],
    bookmarked: false,
    numbering: cyrillic-numbering,
  )

  // Приложение начинается с новой страницы строкой "ПРИЛОЖЕНИЕ А" по центру (ГОСТ 7.32-2017, п. 6.17.3).
  // Названия у приложения нет ни на странице, ни в содержании.
  // Проверка check-ottochia кафедрального CI ищет в содержании строку "ПРИЛОЖЕНИЕ А", сразу за которой идут точки, и название между ними её ломает.
  // HACK: Закладка PDF у нумерованного заголовка начинается с номера ("А ПРИЛОЖЕНИЕ"), а проверки кафедры ищут её текст в документе.
  // Поэтому видимый заголовок в закладки не попадает, а закладку даёт невидимый ненумерованный заголовок с тем же текстом.
  show heading.where(level: 1): it => {
    if it.numbering == none {
      return it
    }
    let number = numbering(it.numbering, ..counter(heading).at(it.location()))
    pagebreak(weak: true)
    align(center, {
      set text(size: 16pt, weight: "bold", hyphenate: false)
      v(1.5em, weak: true)
      [#it.body #number]
      v(1.5em, weak: true)
    })
    place(hide(heading(
      level: 1,
      numbering: none,
      outlined: false,
      bookmarked: true,
    )[#it.body #number]))
  }

  // Рисунки, таблицы, листинги и формулы приложения нумеруются в пределах приложения и при сквозной нумерации основной части (ГОСТ 7.32-2017, пп. 6.5.5, 6.6.4, 6.8.5).
  by-chapter.update(true)

  counter(heading).update(0)
  content
}
