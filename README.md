# Шаблон для отчётов по дисциплине "Анализ алгоритмов"

Установка в папку с лабораторной работой:

- Linux/MacOS
  ```bash
  git clone --depth 1 -b subject/algorithm-analysis https://github.com/malyinik/bmstu-typst-template.git report/ && \
  cd report && \
  rm -rf .git README.md
  ```
- Windows
  ```powershell
  git clone --depth 1 -b subject/algorithm-analysis https://github.com/malyinik/bmstu-typst-template.git report/;
  if ($?) { cd report; rm -Recurse -Force .git, README.md }
  ```

Сборка PDF:

```bash
make
```

Для сборки нужен `python3`. При первом запуске `make` создаёт каталог `.venv` размером около 64 МБ с пакетом `pikepdf`, который используется двумя скриптами доработки PDF после Typst:

- `tools/fix-pdf-spaces.py` убирает глифы пробелов, чтобы документ принимала программа предварительной проверки TestVkr;
- `tools/optimize-pdf-images.py` заново сжимает растровые картинки без потерь, чтобы проверка `check-gs-pdfs` кафедрального CI не требовала дополнительного сжатия.
