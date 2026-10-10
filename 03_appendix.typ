#import "template/config.typ": appendices
#show: appendices

= ПРИЛОЖЕНИЕ <sec:appendix-a>

Полный текст программы приведён на~@lst:program[листинге]. Программа вычисляет погрешность квадратурных формул и записывает её в CSV-файл, по которому построены @tbl:errors[таблица] и @fig:errors[рисунок]. При запуске с ключом `--test` программа вместо этого выполняет функциональные тесты.

#figure(
  raw(read("listings/integrate.py"), lang: "python", block: true),
  caption: [Программа вычисления погрешности квадратурных формул],
)<lst:program>
