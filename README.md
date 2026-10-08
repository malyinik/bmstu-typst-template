# Шаблон для курсовых работ (РПЗ)

Установка в папку с курсовой работой:

- Linux/MacOS
  ```bash
  git clone --depth 1 -b subject/coursework https://github.com/malyinik/bmstu-typst-template.git report/ && \
  cd report && \
  rm -rf .git README.md
  ```
- Windows
  ```powershell
  git clone --depth 1 -b subject/coursework https://github.com/malyinik/bmstu-typst-template.git report/;
  if ($?) { cd report; rm -Recurse -Force .git, README.md }
  ```

Сборка PDF:

```bash
make
```

Для сборки нужен `python3`. При первом запуске `make` создаёт каталог `.venv` с пакетом `pikepdf`, через который PDF после Typst дорабатывают два скрипта:

- `tools/fix-pdf-spaces.py` убирает глифы пробелов, чтобы документ принимала программа предварительной проверки TestVkr;
- `tools/optimize-pdf-images.py` заново сжимает растровые картинки без потерь, чтобы проверка `check-gs-pdfs` кафедрального CI не требовала дополнительного сжатия.

Ghostscript в сборке не используется. После него TestVkr перестаёт распознавать в PDF из Typst титульный лист и структуру документа, а сжимать после Typst ему почти нечего. Файл после Ghostscript выходит даже больше исходного.

Пример отчёта из шаблона проходит программу предварительной проверки TestVkr.exe версии 1.0.0.232 (вид работы КуР) без замечаний, а также PDF-проверки CI из открытого доступа на GitLab кафедры ИУ7 по состоянию на 9 октября 2026 года.
