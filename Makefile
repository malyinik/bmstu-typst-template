SOURCES := $(wildcard *.typ *.yml template/* images/* listings/* data/*)
VENV := .venv

report.pdf: $(SOURCES) $(VENV)/.installed
	typst compile --no-pdf-tags report.typ report.typst.pdf
	$(VENV)/bin/python tools/fix-pdf-spaces.py report.typst.pdf report.spaces.pdf
	$(VENV)/bin/python tools/optimize-pdf-images.py report.spaces.pdf report.pdf
	rm report.typst.pdf report.spaces.pdf

$(VENV)/.installed:
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install --quiet pikepdf==10.3.0
	touch $@
