"""Убирает глифы пробелов из составных шрифтов PDF, собранного Typst.

Typst рисует пробел обычным глифом внутри CID-шрифта.
Программа предварительной проверки TestVkr такой пробел не распознаёт и считает, что в документе нет таблиц перекодировки в Юникод.
Скрипт заменяет каждый такой глиф в операторах `TJ` и `Tj` сдвигом на ширину пробела.
Изображение страницы не меняется, а программы извлечения текста восстанавливают пробелы по промежуткам между словами.
Закладки, ссылки и шрифты остаются нетронутыми.

Использование: python fix-pdf-spaces.py входной.pdf выходной.pdf
"""

import re
import sys
from typing import NamedTuple

import pikepdf


class SpaceGlyph(NamedTuple):
    """Глиф пробела в составном шрифте."""

    code: bytes
    """Двухбайтовый код глифа в строках оператора `TJ`."""
    width: float
    """Ширина глифа в тысячных долях кегля."""


def space_glyph(font: pikepdf.Object) -> SpaceGlyph | None:
    """Возвращает глиф пробела составного шрифта.

    Код берётся из таблицы ToUnicode, ширина - из массива `/W` дочернего CID-шрифта.
    Для простых шрифтов и шрифтов без пробела возвращает `None`.
    """
    # Составной шрифт (Type0) кодирует каждый символ двумя байтами, номер глифа выбирает сам Typst.
    # Понять, какой из номеров означает пробел, можно только по таблице ToUnicode, которая сопоставляет номерам символы Юникода.
    if font.get("/Subtype") != "/Type0" or "/ToUnicode" not in font:
        return None

    # Таблица ToUnicode - текст на языке PostScript со строками вида "<000A> <0020>": номер глифа и код символа в Юникоде.
    # Typst пишет только такие одиночные пары, без диапазонов, поэтому их достаточно найти регулярным выражением.
    cmap = font.ToUnicode.read_bytes()
    code = None
    for src, dst in re.findall(rb"<([0-9A-Fa-f]{4})>\s*<([0-9A-Fa-f]+)>", cmap):
        # U+0020 - обычный пробел, неразрывный пробел (U+00A0) остаётся глифом.
        if dst.upper() == b"0020":
            code = int(src, 16)
            break
    if code is None:
        return None

    # Ширины глифов хранятся не в самом составном шрифте, а в единственном дочернем CID-шрифте.
    cid_font = font.DescendantFonts[0]
    glyph = code.to_bytes(2, "big")
    w = cid_font.get("/W")
    widths: list[pikepdf.Object] = [] if w is None else list(w.as_list())
    i = 0
    # /W - плоский список записей разной длины, поэтому записи перебираются по очереди в поисках той, что покрывает код пробела.
    # Массив /W чередует две формы: "c [w1 w2 ...]" и "c_first c_last w".
    while i < len(widths):
        first = int(widths[i])
        if isinstance(widths[i + 1], pikepdf.Array):
            # Первая форма: глифы first, first + 1, ... получают ширины из вложенного массива по порядку.
            consecutive_widths = list(widths[i + 1].as_list())
            if first <= code < first + len(consecutive_widths):
                return SpaceGlyph(glyph, float(consecutive_widths[code - first]))
            i += 2
        else:
            # Вторая форма: все глифы от first до last включительно имеют одну ширину w.
            if first <= code <= int(widths[i + 1]):
                return SpaceGlyph(glyph, float(widths[i + 2]))
            i += 3

    # Пробела в /W нет, и действует ширина по умолчанию /DW. Если /DW нет, спецификация PDF (ISO 32000) считает её равной 1000.
    # Источник: ISO 32000-1:2008, таблица 117 "Entries in a CIDFont dictionary", с. 269.
    # Копия стандарта от Adobe: https://github.com/adobe/dc-acrobat-sdk-docs/blob/master/docs/standards/pdfstandards/pdf/PDF32000_2008.pdf
    dw = cid_font.get("/DW")
    return SpaceGlyph(glyph, 1000.0 if dw is None else float(dw))


def split_spaces(items: list[pikepdf.Object], space: SpaceGlyph) -> tuple[list[pikepdf.Object | float], bool]:
    """Разбивает элементы оператора `TJ` по глифам пробела.

    Возвращает новый список элементов, где каждый пробел заменён сдвигом на его ширину, и признак того, что замены были.
    Сдвиг отрицательный, потому что в `TJ` положительное число двигает перо назад.
    """
    # Оператор TJ получает массив, в котором строки глифов чередуются с числами.
    # Строка рисуется глиф за глифом, а число сдвигает перо между ними, не рисуя ничего.
    result: list[pikepdf.Object | float] = []
    changed = False
    for item in items:
        # Числа (кернинг, межбуквенная разрядка и растяжение пробелов при выключке) переносятся как есть.
        if not isinstance(item, pikepdf.String):
            result.append(item)
            continue
        data = bytes(item)
        # В chunk копятся глифы до очередного пробела, чтобы затем записать их одной строкой.
        chunk = b""
        # Строка составного шрифта - последовательность двухбайтовых номеров глифов, поэтому шаг равен двум.
        for k in range(0, len(data), 2):
            glyph = data[k : k + 2]
            if glyph == space.code:
                # Пробел закрывает накопленную строку и превращается в сдвиг на свою ширину.
                if chunk:
                    result.append(pikepdf.String(chunk))
                    chunk = b""
                result.append(-space.width)
                changed = True
            else:
                chunk += glyph
        # Глифы после последнего пробела тоже нужно сохранить.
        if chunk:
            result.append(pikepdf.String(chunk))
    return result, changed


def fix_content(pdf: pikepdf.Pdf, owner: pikepdf.Object, visited: set[tuple[int, int]]) -> None:
    """Переписывает поток содержимого страницы или формы и рекурсивно обходит вложенные формы.

    Считается, что межсимвольный интервал `Tc` равен нулю, как в выводе Typst.
    """
    # Ресурсы перечисляют шрифты и вложенные объекты, на которые поток ссылается по коротким именам вроде /f0.
    resources = owner.get("/Resources")
    if resources is None:
        return

    # Форма (Form XObject) - вложенный фрагмент со своим потоком команд, который страница вставляет целиком.
    # В нём тоже может быть текст, поэтому формы обрабатываются той же функцией.
    # Одна форма может встречаться на многих страницах, и visited не даёт переписать её дважды.
    xobjects = resources.get("/XObject")
    for _, xobject in [] if xobjects is None else xobjects.items():
        if xobject.get("/Subtype") == "/Form" and xobject.objgen not in visited:
            visited.add(xobject.objgen)
            fix_content(pdf, xobject, visited)

    # Для каждого шрифта из ресурсов запоминается его глиф пробела, если он есть.
    spaces: dict[str, SpaceGlyph] = {}
    fonts = resources.get("/Font")
    for name, font in [] if fonts is None else fonts.items():
        glyph = space_glyph(font)
        if glyph:
            spaces[name] = glyph
    # Без составных шрифтов с пробелом переписывать нечего.
    if not spaces:
        return

    # Поток содержимого - последовательность команд в постфиксной записи: сначала операнды, потом имя оператора.
    instructions = pikepdf.parse_content_stream(owner)

    # Операторы q и Q сохраняют и восстанавливают графическое состояние: систему координат, цвет, текущий шрифт и прочее.
    # Всё, что изменилось между q и парным ему Q, после Q отменяется, как при save() и restore() в canvas.
    # Стек повторяет эти сохранения, чтобы после Q снова знать, каким шрифтом рисуется текст.
    font_stack: list[str | None] = [None]
    changed = False
    for i, instruction in enumerate(instructions):
        operands = instruction.operands
        name = str(instruction.operator)
        if name == "q":
            font_stack.append(font_stack[-1])
        # Лишний Q без парного q не должен опустошить стек.
        elif name == "Q" and len(font_stack) > 1:
            font_stack.pop()
        elif name == "Tf":
            # Tf выбирает текущий шрифт и кегль, и все следующие Tj и TJ рисуют им, пока шрифт не сменят.
            # В "/f0 14 Tf" это шрифт /f0 кеглем 14, а скрипту нужно только имя шрифта.
            font_stack[-1] = str(operands[0])
        elif name in ("TJ", "Tj") and (space := spaces.get(font_stack[-1] or "")):
            # Tj рисует одну строку, TJ - массив строк и сдвигов.
            # Строка Tj приводится к массиву из одного элемента, и результат в обоих случаях записывается через TJ.
            items = list(operands[0].as_list()) if name == "TJ" else [operands[0]]
            split, replaced = split_spaces(items, space)
            if replaced:
                instructions[i] = pikepdf.ContentStreamInstruction([pikepdf.Array(split)], pikepdf.Operator("TJ"))
                changed = True

    if not changed:
        return
    # Команды собираются обратно в текст потока, нетронутые записываются байт в байт как были.
    data = pikepdf.unparse_content_stream(instructions)
    if isinstance(owner, pikepdf.Stream):
        # Форма сама является потоком, и её содержимое заменяется на месте.
        owner.write(data)
    else:
        # У страницы содержимое лежит в /Contents, иногда массивом из нескольких потоков, и заменяется одним новым.
        owner.Contents = pdf.make_stream(data)


def main() -> None:
    """Читает PDF из первого аргумента и сохраняет исправленный во второй."""
    if len(sys.argv) != 3:
        sys.exit("Использование: python fix-pdf-spaces.py входной.pdf выходной.pdf")
    source, target = sys.argv[1:]
    with pikepdf.open(source) as pdf:
        # Множество уже обработанных форм общее для всех страниц.
        visited: set[tuple[int, int]] = set()
        for page in pdf.pages:
            fix_content(pdf, page.obj, visited)
        pdf.save(target)


if __name__ == "__main__":
    main()
