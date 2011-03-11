#!/bin/zsh
#####################
## CHANGE FILENAME ##
OUTPUT_FILENAME=BLOCH_GAUDIN_Datamining
#####################
# Makefile for Nation Template
# Designed by DigitalGuru

CMD_PDFLATEX=pdflatex
CMD_DOT=dot
CMD_IMAGEMAGICK=convert
CMD_RM=rm
CMD_MKDIR=mkdir
CMD_MAKEGLOS=makeglossaries
CMD_MAKEBIB=bibtex
CMD_MV=mv

VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"
CYAN="\\033[1;36m"

COMPILE_SUCCESS=0
COMPILE_FAIL=1
COMPILE=${COMPILE_SUCCESS}

STDOUT_LOG_FILENAME=output.log
STDOUT_ERROR_FILENAME=errors.log

BIN_DIRECTORY=bin/
TMP_DIRECTORY=tmp/
SRC_DIRECTORY=src/
IMG_DIRECTORY=img/

INPUT_FILENAME=main

all: clean check_directory check_git convert_images ${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf 

${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf: ${SRC_DIRECTORY}${INPUT_FILENAME}.tex
	@COMPILE=0; \
	echo ${CYAN} "Compilation ..." ${NORMAL}; \
	cd src && latexmk -r ../latexmk/latexmkrc -f- -pdf -silent main.tex > /dev/null || COMPILE=1; \
	echo ${CYAN} "Cleanup latexmk mess..." ${NORMAL}; \
	cd ../; \
	EXT=aux && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=glo && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=ist && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=maf && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=mtc && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=mtc0 && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=log && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=acn && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=idx && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=out && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=ilg && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=ind && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=toc && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;		\
	EXT=fdb_latexmk && if [ -e ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ]; then ${CMD_MV} ${SRC_DIRECTORY}${INPUT_FILENAME}.$${EXT} ${TMP_DIRECTORY}; fi;	\
	if [ -e ${SRC_DIRECTORY}*.bak ]; then rm ${SRC_DIRECTORY}*.bak; fi; \
	if [ $${COMPILE} = 1 ]; then \
		echo ${ROUGE} "La compilation a échouée ! " ${NORMAL}; \
		grep -E -A6 "^\!" ${TMP_DIRECTORY}${INPUT_FILENAME}.log; \
	else \
		echo ${VERT} "Compilation effectuée avec succès !" ${NORMAL}; \
		mv ${SRC_DIRECTORY}${INPUT_FILENAME}.pdf ${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf; \
	fi; 


convert_images:
	@cd ${IMG_DIRECTORY} && \
	for i in `ls`; do \
		fn=$${i%%.*}; \
		ext=`echo $${i#*.} | tr '[A-Z]' '[a-z]'`; \
		if [ "$$ext" = 'dot' ]; then \
			echo "Export...";\
			${CMD_DOT} -Tpng -o $$fn.png $$i; \
		else \
			if [ "$$ext" != "png" ] && [ "$$ext" != "jpg" ] && [ "$$ext" != "pdf" ]; then \
				if [ ! -e $$fn.png ]; then \
					echo "Conversion..."; \
					${CMD_IMAGEMAGICK} $$i $$fn.png; \
				fi; \
			fi; \
		fi; \
	done

check_git:
	@if [ -d .git ]; then cp versioning/pre-commit .git/hooks/; chmod 774 .git/hooks/pre-commit; fi

check_directory:
	@if [ ! -d ${BIN_DIRECTORY} ]; then ${CMD_MKDIR} ${BIN_DIRECTORY}; fi
	@if [ ! -d ${TMP_DIRECTORY} ]; then ${CMD_MKDIR} ${TMP_DIRECTORY}; fi

clean:
	@${CMD_RM} -f bin/*

mrproper: clean
	@${CMD_RM} -rf tmp
	@${CMD_RM} -rf bin
