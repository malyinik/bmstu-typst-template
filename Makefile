VENV := .venv
PYTHON := $(VENV)/bin/python

include iu7-nir-student.mk

release/report.pdf: $(VENV)/.installed

$(VENV)/.installed:
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install --quiet pikepdf==10.3.0
	touch $@
