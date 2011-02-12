#!/bin/bash
# Makefile for Nation Template
# Designed by DigitalGuru
VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

COMPILE=""

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
	cd ${SRC_DIRECTORY} && pdflatex -output-directory ../${TMP_DIRECTORY} ${INPUT_FILENAME}.tex || ${COMPILE}=1
	
	if [[ -z ${COMPILE} ]]; then \
		echo ${VERT} "Compilation effectuée avec succès !" ${NORMAL}; \
		mv ${TMP_DIRECTORY}${INPUT_FILENAME}.pdf ${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf; \
	else \
		echo ${ROUGE} "Echec de la compilation !" ${NORMAL}; \
	fi

check_directory:
	if [ ! -d ${BIN_DIRECTORY} ]; then mkdir ${BIN_DIRECTORY}; fi
	if [ ! -d ${TMP_DIRECTORY} ]; then mkdir ${TMP_DIRECTORY}; fi

clean:
	rm -f tmp/*

mrproper: clean
	rm -f bin/*
