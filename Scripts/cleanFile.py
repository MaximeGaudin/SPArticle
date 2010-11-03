# -*- coding: utf-8 -*-
import unicodedata
import sys
import os

def unaccent(str):
	unicode_str = unicode(str, 'utf8')
	return unicodedata.normalize('NFKD', unicode_str).encode('ascii','ignore')

def readFile(filename):
	f=open(filename)
	buffer=f.read()
	f.close()

	return buffer

def writeFile(filename, text):
	if(os.path.exists(filename)): os.remove(filename)
	f=open(filename, 'w')
	f.write(text)
	f.close()


def printMan():
	print "MAN"

def main():
	if(len(sys.argv) <= 1): printMan()

	if(len(sys.argv) == 2):
		writeFile(sys.argv[1], unaccent(readFile(sys.argv[1])))

	if(len(sys.argv) == 3):
		writeFile(sys.argv[2], unaccent(readFile(sys.argv[1])))

main()
