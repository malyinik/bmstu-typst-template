# Шаблон Typst для написания отчётов в МГТУ им. Н. Э. Баумана

> [!WARNING]
> Шаблон не проверялся на соответствие всем требованиям и ГОСТ.

В ветке `main` содержится базовый шаблон для отчётов по лабораторным работам с произвольным содержанием.

**Специализированные ветки:**

- [`subject/algorithm-analysis`](https://github.com/malyinik/bmstu-typst-template/tree/subject/algorithm-analysis) — версия для отчётов по дисциплине "Анализ алгоритмов" (ИУ7)
- [`subject/coursework`](https://github.com/malyinik/bmstu-typst-template/tree/subject/coursework) — версия для курсовых работ (РПЗ)
- [`subject/nir`](https://github.com/malyinik/bmstu-typst-template/tree/subject/nir) — версия для НИР (РПЗ)

## Установка шаблона

- Linux/MacOS
  ```bash
  git clone --depth 1 https://github.com/malyinik/bmstu-typst-template.git report/ && \
  cd report && \
  rm -rf .git README.md
  ```
- Windows
  ```powershell
  git clone --depth 1 https://github.com/malyinik/bmstu-typst-template.git report/;
  if ($?) { cd report; rm -Recurse -Force .git, README.md }
  ```

## Сборка

```bash
make
```

Для сборки нужен только `typst`.

Typst записывает картинки PNG в PDF без PNG-предиктора, которым сжат сам файл PNG, поэтому фотографии и снимки экрана в формате PNG занимают в PDF заметно больше места, чем могли бы. Если таких картинок в отчёте много, его стоит собирать со сжатием:

```bash
make compressed
```

Скрипт `tools/optimize-pdf-images.py` сжимает картинки заново без потерь качества. Фотография в PNG после этого занимает в PDF почти вдвое меньше места. Картинки JPEG Typst переносит в PDF без изменений, и скрипт их не трогает, потому что JPEG уже сжат с потерями и без потерь заново не сжимается. Графики и схемы в PNG уменьшаются на несколько процентов, а векторные изображения скрипт не трогает. Для работы скрипта нужны `python3` и пакет `pikepdf`. Пакет ставится при первом запуске `make compressed` в каталог `.venv` размером около 64 МБ.
