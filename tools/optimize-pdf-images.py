"""Заново сжимает растровые картинки PDF, собранного Typst, без потерь качества.

Typst распаковывает PNG до пикселей и сжимает их заново методом Deflate, но без PNG-предиктора, который есть в самом формате PNG.
Ghostscript с флагами кафедральной проверки check-gs-pdfs возвращает предиктор, и на фотоподобных PNG выигрывает до четверти размера, после чего проверка падает.
Скрипт для каждой такой картинки пробует сжатие с предиктором и без него и оставляет самый компактный вариант.
Пиксели не меняются, меняется только способ их записи.

Использование: python optimize-pdf-images.py входной.pdf выходной.pdf
"""

import sys
import zlib

import pikepdf

ABS_BYTE = bytes(min(v, 256 - v) for v in range(256))
"""Таблица для `bytes.translate`, которая заменяет каждый байт разности её модулем.

Разность хранится по модулю 256, поэтому байт 255 означает -1, а 254 означает -2.
Таблица из 256 значений строится один раз при загрузке скрипта, выписывать её вручную было бы нечитаемо.
"""

COST_STEP = 4
"""Шаг выборки байтов при оценке фильтра: каждый четвёртый байт строки даёт ту же оценку вчетверо быстрее."""


def png_predict(pixels: bytes, width: int, height: int, bpp: int) -> bytes:
    """Кодирует строки картинки PNG-фильтрами, каждую своим, как при `/Predictor 15` в PDF.

    `bpp` - число байтов на пиксель, на это расстояние отстоит сосед слева.
    Используются фильтры "без предсказания", "сосед слева", "сосед сверху" и "среднее левого и верхнего".
    Фильтр Паэта не используется: на проверенных картинках он не давал выигрыша, а считается только побайтово и очень медленно.
    """
    stride = width * bpp
    n = len(pixels)

    # Побайтовая арифметика в цикле Python слишком медленная, поэтому вся картинка обрабатывается как одно большое целое число.
    # Это приём SWAR ("SIMD within a register"): одна операция над числом выполняется сразу над всеми байтами внутри интерпретатора на C.
    # Маски high и low выделяют в каждом байте старший бит и семь младших.
    high = int.from_bytes(b"\x80" * n, "big")
    low = (high >> 7) * 0x7F
    full = (1 << (8 * n)) - 1

    # Сосед слева - тот же массив, сдвинутый на один пиксель, но у первого пикселя каждой строки соседа нет, и формат PNG считает его нулём.
    left_bytes = bytearray(bytes(bpp) + pixels[:-bpp])
    zeros = bytes(bpp)
    for y in range(1, height):
        left_bytes[y * stride : y * stride + bpp] = zeros
    current = int.from_bytes(pixels, "big")
    left = int.from_bytes(left_bytes, "big")
    # Сосед сверху - массив, сдвинутый на одну строку, у первой строки это нули.
    up = current >> (8 * stride)

    def subtract(a: int, b: int) -> bytes:
        """Возвращает побайтовую разность a - b по модулю 256."""
        # Старший бит a принудительно ставится, а у b снимается, поэтому заём при вычитании не перетекает в соседний байт.
        # Затем старший бит каждого байта исправляется по правилу сложения по модулю 2.
        return (((a | high) - (b & ~high)) ^ ((a ^ b ^ full) & high)).to_bytes(n, "big")

    # Среднее (left + up) / 2 с округлением вниз без переполнения байта: общие биты плюс половина различающихся.
    average = (left & up) + (((left ^ up) >> 1) & low)

    # Каждый фильтр хранит разность между байтом и своим предсказанием, номер фильтра совпадает с номером в формате PNG.
    candidates = (pixels, subtract(current, left), subtract(current, up), subtract(current, average))
    # Для оценки фильтров каждый байт разности заменяется её модулем, иначе разность -1 (байт 255) считалась бы огромной.
    # Замена по таблице делается одним вызовом translate на C, а memoryview позволяет потом брать срезы строк без копирования.
    costs = [memoryview(c.translate(ABS_BYTE)) for c in candidates]

    out = bytearray()
    for y in range(height):
        start, end = y * stride, (y + 1) * stride
        # Как и библиотека libpng, выбираем фильтр с наименьшей суммой модулей разностей.
        # Маленькие разности повторяются чаще, и Deflate сжимает их лучше.
        kind = min(range(len(candidates)), key=lambda k: sum(costs[k][start:end:COST_STEP]))
        out.append(kind)
        out += candidates[kind][start:end]
    return bytes(out)


def optimize_image(image: pikepdf.Stream) -> None:
    """Заново сжимает одну картинку, если это уменьшает её размер.

    Обрабатываются только картинки, сжатые одним Deflate без предиктора, с 8 или 16 битами на компоненту.
    Остальные, в том числе JPEG, остаются как есть.
    """
    # Typst пишет PNG с фильтром /FlateDecode и без /DecodeParms, а JPEG - с /DCTDecode, и его нельзя сжать заново без потерь.
    if image.get("/Filter") != "/FlateDecode" or "/DecodeParms" in image or image.get("/ImageMask"):
        return
    bits = int(image.get("/BitsPerComponent") or 0)
    if bits not in (8, 16):
        return

    width, height = int(image.Width), int(image.Height)
    pixels = image.read_bytes()
    # Число байтов на пиксель выводится из размера данных, так что разбирать цветовое пространство не нужно.
    bpp, rest = divmod(len(pixels), width * height)
    if rest or bpp == 0 or bpp * 8 % bits:
        return

    # Сжатые данные картинки в том виде, в каком их записал Typst.
    original = image.read_raw_bytes()
    # Два варианта новой записи тех же пикселей: просто Deflate на максимальном уровне и Deflate после PNG-фильтров.
    compressed = zlib.compress(pixels, 9)
    compressed_predicted = zlib.compress(png_predict(pixels, width, height, bpp), 9)
    # Сравниваются размеры сжатых данных в байтах: если ни один новый вариант не короче исходного, картинка остаётся как есть.
    if min(len(compressed), len(compressed_predicted)) >= len(original):
        return

    if len(compressed_predicted) < len(compressed):
        # Параметры предиктора сообщают программе просмотра, как восстановить пиксели из разностей.
        # Predictor 15 означает PNG-фильтры, свои для каждой строки, номер фильтра записан первым байтом строки.
        # Значения 10-14 означают один фильтр на все строки, а 1 - отсутствие предсказания.
        # Источник: ISO 32000-1:2008, таблица 10 "Predictor values", с. 29.
        parms = pikepdf.Dictionary(Predictor=15, Colors=bpp * 8 // bits, BitsPerComponent=bits, Columns=width)
        image.write(compressed_predicted, filter=pikepdf.Name.FlateDecode, decode_parms=parms)
    else:
        image.write(compressed, filter=pikepdf.Name.FlateDecode)

    # Страховка от ошибки в кодировании: если пиксели после распаковки не совпали, возвращается исходная запись.
    if image.read_bytes() != pixels:
        image.write(original, filter=pikepdf.Name.FlateDecode)


def main() -> None:
    """Читает PDF из первого аргумента и сохраняет результат во второй."""
    if len(sys.argv) != 3:
        sys.exit("Использование: python optimize-pdf-images.py входной.pdf выходной.pdf")
    source, target = sys.argv[1:]
    with pikepdf.open(source) as pdf:
        # Картинка хранится в PDF одним объектом, сколько бы страниц на неё ни ссылалось, поэтому перебираются сами объекты.
        # Маски прозрачности (/SMask) тоже картинки и сжимаются так же.
        for obj in pdf.objects:
            if isinstance(obj, pikepdf.Stream) and obj.get("/Subtype") == "/Image":
                optimize_image(obj)
        pdf.save(target)


if __name__ == "__main__":
    main()
