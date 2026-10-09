/**
 * Нумерация рисунков, таблиц, листингов и формул: сквозная (1, 2, 3) или в пределах раздела (1.1, 1.2, 2.1).
 *
 * Счётчики элементов всегда сквозные и на заголовках не сбрасываются.
 * Номер в разделе равен сквозному номеру за вычетом значения того же счётчика на заголовке раздела.
 * Номер раздела оформляется по нумерации его заголовка, поэтому в приложениях он становится буквой без отдельных правил.
 * Разделом считается последний нумерованный заголовок первого уровня перед элементом.
 */

/// Последний нумерованный заголовок первого уровня перед местом `loc` или `none`, если такого нет.
#let chapter-heading(loc) = {
  let headings = query(heading.where(level: 1).before(loc)).filter(h => h.numbering != none)
  headings.at(-1, default: none)
}

/// Счётчик, которым нумеруется элемент `el`: собственный счётчик фигуры или общий счётчик формул.
#let element-counter(el) = {
  if el.func() == figure {
    el.counter
  } else {
    counter(math.equation)
  }
}

/// Номер фигуры или формулы `el` без скобок.
/// При `by-chapter: true` номер берётся в пределах раздела ("2.1", "А.1"), иначе сквозной ("5").
/// Перед первым нумерованным разделом номер всегда сквозной.
/// Нужен контекст.
#let element-number(el, by-chapter: true) = {
  let elem-counter = element-counter(el)
  let n = elem-counter.at(el.location()).first()
  if not by-chapter {
    return str(n)
  }
  let chapter = chapter-heading(el.location())
  if chapter == none {
    return str(n)
  }
  let chapter-number = counter(heading).at(chapter.location()).first()
  let chapter-start = elem-counter.at(chapter.location()).first()
  [#numbering(chapter.numbering, chapter-number).#(n - chapter-start)]
}

/// Номер элемента, в контексте которого Typst вызвал функцию нумерации.
/// Typst вызывает её в контексте самого элемента и в подписи, и в ссылке на него.
#let here-number(nums, by-chapter) = {
  let el = query(here()).at(0, default: none)
  if el == none {
    return str(nums.pos().last())
  }
  element-number(el, by-chapter: by-chapter)
}

/// Функция нумерации фигур для `set figure(numbering: ...)`.
/// Режим задаётся через `figure-numbering.with(by-chapter: false)`.
#let figure-numbering(by-chapter: true, ..nums) = here-number(nums, by-chapter)

/// Функция нумерации формул для `set math.equation(numbering: ...)`: тот же номер в круглых скобках.
#let equation-numbering(by-chapter: true, ..nums) = [(#here-number(nums, by-chapter))]
