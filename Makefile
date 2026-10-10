SOURCES := $(wildcard *.typ *.yml template/* images/* listings/* data/*)
VENV := .venv

report.pdf: $(SOURCES)
	typst compile --no-pdf-tags report.typ report.pdf

# Сборка со сжатием растровых картинок без потерь.
# При первом запуске создаёт каталог .venv с пакетом pikepdf.
.PHONY: compressed
compressed: $(SOURCES) $(VENV)/.installed
	typst compile --no-pdf-tags report.typ report.typst.pdf
	$(VENV)/bin/python tools/optimize-pdf-images.py report.typst.pdf report.pdf
	rm report.typst.pdf

$(VENV)/.installed:
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install --quiet --disable-pip-version-check pikepdf==10.3.0
	touch $@
