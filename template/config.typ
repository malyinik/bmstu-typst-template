#import "@preview/codly:1.3.0"
#import "@preview/codly-languages:0.1.8": *
#import "@preview/i-figured:0.2.4"

// @typstyle off
#let cyrillic-upper = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "З", "И", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Э", "Ю", "Я")
// @typstyle on

#let cyrillic-numbering(..nums) = {
  let numbers = nums.pos()
  if numbers.len() == 0 { return "" }
  let first = cyrillic-upper.at(numbers.first() - 1)
  if numbers.len() == 1 { return first }
  first + "." + numbers.slice(1).map(str).join(".")
}

#let font_name = "Times New Roman"

#let bmstu_config(content) = {
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
      tracking: (min: -0.01em, max: 0.01em),
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
  // HACK: Чтобы TestVkr.exe корректно читал заголовки в содержании, которые другие программы читают без проблем...
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

    if cyrillic-upper.contains(number) {
      [#link(it.element.location(), title)~#number]
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
    [СПИСОК~ИСПОЛЬЗОВАННЫХ~ИСТОЧНИКОВ],
    [ЗАКЛЮЧЕНИЕ],
    [ПРИЛОЖЕНИЕ~A],
    [ПРИЛОЖЕНИЕ Б],
    [ПРИЛОЖЕНИЕ В],
    [ПРИЛОЖЕНИЕ Г],
  )
  set heading(numbering: "1.1")
  show heading.where(level: 4): set heading(numbering: none, outlined: false)
  show heading.where(level: 5): set heading(numbering: none, outlined: false)
  show heading: it => {
    // HACK: Чтобы TestVkr.exe корректно читал заголовки в тексте, которые другие программы читают без проблем...
    // TODO: включить перед отправкой
    // place(horizon, rect(width: 100%, height: 100%, stroke: white.transparentize(100%)))

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
  show table: set text(size: 12pt)
  show figure.where(kind: table): it => {
    set par(justify: false, leading: 0.5em)
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
    [
      #set text(size: 10pt)
      #it.body
    ]
    set text(size: 14pt)
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
  show math.equation.where(block: false): set math.frac(style: "horizontal")
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
  set bibliography(style: "gost-r-7-0-5-2008-numeric.csl", title: [СПИСОК~ИСПОЛЬЗОВАННЫХ~ИСТОЧНИКОВ])
  show bibliography: it => {
    pagebreak(weak: true)
    show heading: title => {
      align(center, title)
      v(2em, weak: true)
    }
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

  content
}
