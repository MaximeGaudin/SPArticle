#####################
## CHANGE FILENAME ##
OUTPUT_FILENAME=MAIN
#####################
# Makefile for Nation Template
# Designed by DigitalGuru

VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

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

all: clean check_directory convert_images ${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf 

${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf: ${SRC_DIRECTORY}${INPUT_FILENAME}.tex
	@compile=${COMPILE_SUCCESS}; \
	cd ${SRC_DIRECTORY} && \
	pdflatex -output-directory ../${TMP_DIRECTORY} -halt-on-error ${INPUT_FILENAME}.tex 2>&1 !>/dev/null || compile=${COMPILE_FAIL}; \
	pdflatex -output-directory ../${TMP_DIRECTORY} -halt-on-error ${INPUT_FILENAME}.tex 2>&1 !>/dev/null || compile=${COMPILE_FAIL}; \
	if [[ $${compile} -eq ${COMPILE_SUCCESS} ]]; then \
		echo ${VERT} "Compilation effectuée avec succès !" ${NORMAL}; \
		mv ../${TMP_DIRECTORY}${INPUT_FILENAME}.pdf ../${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf; \
	else \
		echo ${ROUGE} "Echec de la compilation !" ${NORMAL}; \
		cat ../${TMP_DIRECTORY}${INPUT_FILENAME}.log; \
	fi

convert_images:
	@cd ${IMG_DIRECTORY} && \
	for i in `ls`; do \
		fn=$${i%%.*}; \
		ext=`echo $${i#*.} | tr '[A-Z]' '[a-z]'`; \
		if [[ "$$ext" != "png" && "$$ext" != "jpg" && "$$ext" != "pdf" ]]; then \
			if [[ ! -e $$fn.png ]]; then \
				echo "Conversion..."; \
				convert $$i $$fn.png; \
			fi; \
		fi; \
	done

check_directory:
	@if [ ! -d ${BIN_DIRECTORY} ]; then mkdir ${BIN_DIRECTORY}; fi
	@if [ ! -d ${TMP_DIRECTORY} ]; then mkdir ${TMP_DIRECTORY}; fi

clean:
	@rm -f bin/*

mrproper: clean
	@rm -rf tmp
	@rm -rf bin
