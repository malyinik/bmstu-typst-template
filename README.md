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
