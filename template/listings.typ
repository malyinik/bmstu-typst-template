/**
 * Блоки кода: строки в рамке с номерами слева и, для листингов, подпись под рамкой.
 *
 * Блок собирается таблицей из номеров строк и самих строк, поэтому он разрывается между страницами по границам строк.
 * Рамка закрывается на каждой странице: верхнюю линию даёт повторяющийся заголовок таблицы, нижнюю - повторяющийся подвал.
 * Подпись листинга занимает последнюю строку той же таблицы и переходит на новую страницу вместе с последними строками кода.
 */

/// Линия рамки блока кода.
#let code-stroke = black + 0.8pt

/// Число последних строк кода, которые не отрываются от подписи.
#let lines-kept-with-caption = 2

/// Нижняя линия рамки на странице, где блок кода, начатый в месте `origin`, продолжается дальше.
/// На последней странице блока над подписью уже есть своя линия, и подвал ничего не рисует.
#let bottom-line(origin) = context {
  let ends = query(selector(<code-block-end>).after(origin).before(here()))
  if ends.len() == 0 or ends.last().location().page() != here().page() {
    line(length: 100%, stroke: code-stroke)
  }
}

/// Блок кода `it` (элемент `raw` с `block: true`) в виде таблицы с номерами строк.
/// При `highlight: false` строки выводятся без подсветки синтаксиса независимо от указанного языка.
/// Подпись `caption`, если она задана, ставится под рамкой вплотную, поэтому промежуток до неё входит в саму подпись.
/// Подпись не отрывается от последних строк кода.
#let code-block(it, highlight: true, caption: none) = context {
  // Размер шрифта блока закрепляется, чтобы на код не действовали правила оформления таблиц документа.
  show table: set text(size: text.size)
  // Перевод строки в конце файла не даёт пустой последней строки.
  let lines = it.lines
  if lines.len() > 1 and lines.last().text == "" {
    lines = lines.slice(0, -1)
  }
  // Перенесённая часть длинной строки начинается на отступе самой строки и ещё на четыре символа правее.
  let char-width = measure[0].width
  let rows = lines.map(line => {
    let body = if highlight {
      line.body
    } else {
      line.text
    }
    let indent = line.text.len() - line.text.trim(at: start).len()
    let wrapped = par(
      first-line-indent: 0pt,
      justify: false,
      hanging-indent: (indent + 4) * char-width,
      body,
    )
    ([#line.number], wrapped)
  })

  let cells = if caption == none {
    rows.flatten()
  } else {
    // Третья колонка нулевой ширины держит неразрывную ячейку, которая оставляет последние строки кода на одной странице с подписью.
    let kept = calc.min(lines-kept-with-caption, rows.len())
    let free = rows.slice(0, rows.len() - kept)
    let tail = rows.slice(rows.len() - kept)
    (
      ..free.map(row => (..row, [])).flatten(),
      ..tail.first(),
      table.cell(rowspan: kept + 1, breakable: false)[],
      ..tail.slice(1).flatten(),
      table.cell(
        colspan: 2,
        inset: 0pt,
        align: center,
        stroke: (top: code-stroke, rest: none),
      )[#metadata(none)<code-block-end>#caption],
    )
  }
  let columns = if caption == none {
    (auto, 1fr)
  } else {
    (auto, 1fr, 0pt)
  }

  table(
    columns: columns,
    inset: (x, y) => if x < 2 { 0.48em } else { 0pt },
    align: (right + top, left + top, left),
    // Строка 0 - пустой заголовок нулевой высоты, у строк кода есть только боковые линии.
    stroke: (x, y) => if y > 0 {
      (
        left: if x == 0 { code-stroke },
        right: if x == 1 { code-stroke },
      )
    },
    table.header(table.cell(colspan: columns.len(), inset: 0pt, stroke: (bottom: code-stroke))[]),
    ..cells,
    table.footer(table.cell(colspan: columns.len(), inset: 0pt, stroke: none, bottom-line(here()))),
  )
}
