DOCPATH=./
TMPPATH=./tmp/
BINPATH=./bin/

SOURCE=main.tex
SOURCEDEPS=$(wildcard $(DOCPATH)/*.tex)
OUTPUT=main.pdf

all: $(BINPATH)/$(OUTPUT)

$(BINPATH)/$(OUTPUT): $(DOCPATH)/$(SOURCE) $(SOURCEDEPS)
# Processing twice to handle references inside the document
	cd $(DOCPATH) ; \
	for i in 1 2 ; \
	do \
		pdflatex -output-directory $(TMPPATH) $(DOCPATH)/$(SOURCE) || exit 1 ; \
	done
	@mv $(TMPPATH)/$(OUTPUT) $(BINPATH)

open: $(BINPATH)/$(OUTPUT)
	@open $(BINPATH)/$(OUTPUT)

clean:
	@rm -f $(TMPPATH)/*

mrproper: clean
	@rm -f $(BINPATH)/*
