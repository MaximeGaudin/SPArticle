# Makefile for Nation Template
# DigitalGuru
BIN_DIRECTORY=bin/
TMP_DIRECTORY=tmp/
SRC_DIRECTORY=src/

INPUT_FILENAME=main

#####################
## CHANGE FILENAME ##
OUTPUT_FILENAME=MAIN
#####################

all: check_directory ${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf 

${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf: ${SRC_DIRECTORY}${INPUT_FILENAME}.tex
	cd ${SRC_DIRECTORY} && pdflatex -output-directory ../tmp/ ${INPUT_FILENAME}.tex && mv ../tmp/${INPUT_FILENAME}.pdf ../bin/${OUTPUT_FILENAME}.pdf

check_directory:
	[ ! -d ${BIN_DIRECTORY} ] && mkdir ${BIN_DIRECTORY}
	[ ! -d ${TMP_DIRECTORY} ] && mkdir ${TMP_DIRECTORY}

clean:
	rm -f tmp/*

mrproper: clean
	rm -f bin/*
