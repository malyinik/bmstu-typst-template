# Шаблон Typst для написания отчётов в МГТУ им. Н. Э. Баумана

> [!WARNING]
> Шаблон не проверялся на соответствие всем требованиям и ГОСТ.

В ветке `main` содержится базовый шаблон.

**Специализированные ветки:**

- [`subject/algorithm-analysis`](https://github.com/malyinik/bmstu-typst-template/tree/subject/algorithm-analysis) — версия для отчётов по дисциплине "Анализ алгоритмов" (ИУ7)

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
