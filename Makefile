TYPST_FILES := $(wildcard *.typ)
VENV := .venv

report.pdf: $(TYPST_FILES) 08_references.yml $(VENV)/.installed
	typst compile --no-pdf-tags report.typ report.typst.pdf
	$(VENV)/bin/python tools/fix-pdf-spaces.py report.typst.pdf report.pdf
	rm report.typst.pdf

$(VENV)/.installed:
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install --quiet pikepdf==10.3.0
	touch $@
