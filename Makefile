OUTPUT=main

all:
	/usr/local/texlive/2010/bin/x86_64-darwin/pdflatex -output-directory ./tmp/ ${OUTPUT}.tex 
	@mv ./tmp/${OUTPUT}.pdf ./bin/

clean:
	@rm -f ./tmp/*
	@rm -f ./bin/*
