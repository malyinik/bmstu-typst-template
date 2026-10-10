SOURCES := $(wildcard *.typ *.yml template/* images/* listings/* data/*)
PYTHON ?= python3

release/report.pdf: $(SOURCES)
	mkdir -p release
	typst compile --no-pdf-tags report.typ release/report.typst.pdf
	$(PYTHON) tools/fix-pdf-spaces.py release/report.typst.pdf release/report.spaces.pdf
	$(PYTHON) tools/optimize-pdf-images.py release/report.spaces.pdf $@
	rm release/report.typst.pdf release/report.spaces.pdf
