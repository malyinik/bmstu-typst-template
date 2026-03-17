TYPST_FILES := $(wildcard *.typ)

report.pdf: $(TYPST_FILES) 08_references.yml
	typst compile --no-pdf-tags report.typ
	make optimize_pdf

.PHONY: optimize_pdf
optimize_pdf:
	gs -sDEVICE=pdfwrite \
		-dCompatibilityLevel=1.4 \
		-dNOPAUSE \
		-dOptimize=true \
		-dQUIET \
		-dBATCH \
		-dRemoveUnusedFonts=true \
		-dRemoveUnusedImages=true \
		-dOptimizeResources=true \
		-dDetectDuplicateImages \
		-dCompressFonts=true \
		-dEmbedAllFonts=true \
		-dSubsetFonts=true \
		-dPreserveAnnots=true \
		-dPreserveMarkedContent=true \
		-dPreserveOverprintSettings=true \
		-dPreserveHalftoneInfo=true \
		-dPreserveOPIComments=true \
		-dPreserveDeviceN=true \
		-dMaxInlineImageSize=0 \
		-sOutputFile="report_optimized.pdf" \
		"report.pdf"
		mv "report_optimized.pdf" "report.pdf"
