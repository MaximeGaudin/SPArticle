#####################
## CHANGE FILENAME ##
OUTPUT_FILENAME=MAIN
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
	@compile=${COMPILE_SUCCESS}; \
	cd ${SRC_DIRECTORY} && \
	echo ${CYAN} "Première passe LaTeX..." ${NORMAL}; \
	${CMD_PDFLATEX} -output-directory ../${TMP_DIRECTORY} -interaction=nonstopmode ${INPUT_FILENAME}.tex 2>&1 1>/dev/null || compile=${COMPILE_FAIL}; \
	\
	if [[ $${compile} -eq ${COMPILE_SUCCESS} ]]; then \
		echo ${CYAN} "Construction du glossaire..." ${NORMAL}; \
		cd ../${TMP_DIRECTORY} && ${CMD_MAKEGLOS} ${INPUT_FILENAME} 2>&1 1>/dev/null && cd ../${SRC_DIRECTORY}; \
		\
		echo ${CYAN} "Construction de la bibliographie..." ${NORMAL}; \
		cp *.bib ../${TMP_DIRECTORY}; \
		cd ../${TMP_DIRECTORY} && ${CMD_MAKEBIB} ${INPUT_FILENAME} 2>&1 1>/dev/null && cd ../${SRC_DIRECTORY}; \
		\
		echo ${CYAN} "Deuxième passe LaTeX..." ${NORMAL}; \
		${CMD_PDFLATEX} -output-directory ../${TMP_DIRECTORY} -interaction=nonstopmode ${INPUT_FILENAME}.tex 2>&1 !>/dev/null || compile=${COMPILE_FAIL}; \
		\
		echo ${CYAN} "Troisième passe LaTeX..." ${NORMAL}; \
		${CMD_PDFLATEX} -output-directory ../${TMP_DIRECTORY} -interaction=nonstopmode ${INPUT_FILENAME}.tex 2>&1 !>/dev/null || compile=${COMPILE_FAIL}; \
		\
		echo ${VERT} "Compilation effectuée avec succès !" ${NORMAL}; \
		mv ../${TMP_DIRECTORY}${INPUT_FILENAME}.pdf ../${BIN_DIRECTORY}${OUTPUT_FILENAME}.pdf; \
	else \
		cat ../${TMP_DIRECTORY}${INPUT_FILENAME}.log; \
		echo ${ROUGE} "Echec de la compilation :" ${NORMAL} `grep -E '^!' ../tmp/main.log`;\
	fi

convert_images:
	@cd ${IMG_DIRECTORY} && \
	for i in `ls`; do \
		fn=$${i%%.*}; \
		ext=`echo $${i#*.} | tr '[A-Z]' '[a-z]'`; \
		if [[ "$$ext" == "dot" ]]; then \
			echo "Export...";\
			${CMD_DOT} -Tpng -o $$fn.png $$i; \
		else \
			if [[ "$$ext" != "png" && "$$ext" != "jpg" && "$$ext" != "pdf" ]]; then \
				if [[ ! -e $$fn.png ]]; then \
					echo "Conversion..."; \
					${CMD_IMAGEMAGICK} $$i $$fn.png; \
				fi; \
			fi; \
		fi; \
	done

check_git:
	@if [ -d .git ]; then cp versioning/pre-commit .git/hooks/; fi

check_directory:
	@if [ ! -d ${BIN_DIRECTORY} ]; then ${CMD_MKDIR} ${BIN_DIRECTORY}; fi
	@if [ ! -d ${TMP_DIRECTORY} ]; then ${CMD_MKDIR} ${TMP_DIRECTORY}; fi

clean:
	@${CMD_RM} -f bin/*

mrproper: clean
	@${CMD_RM} -rf tmp
	@${CMD_RM} -rf bin
