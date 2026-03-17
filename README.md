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
