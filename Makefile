#
# Makefile
# Makefile to systematically compile the john_slides.tex to produce 
# john_slides.pdf (and clean up temporary files).
#
# In order to create the PDF file, just type
#
# make 
#
# This and other associated files are distributed in the hope that it will 
# be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For questions, comments and/or concerns about this template, please contact
#
# Dr. Gowtham, PhD 
# Director of Research Computing, IT
# Adj. Asst. Professor, Physics/ECE
# Michigan Technological University
# Email: g@mtu.edu

# File suffixes
.SUFFIXES: .tex .dvi .eps .ps .pdf .jpg .gif

# Basic variables
SHELL    = /bin/sh
CP       = cp
RM       = rm
MV       = mv
AWK      = awk
SED      = sed
ZIP      = zip
MKDIR    = mkdir
SLEEP    = sleep
LATEX    = latex
PDFLATEX = pdflatex
BIBTEX   = bibtex
DVIPS    = dvips
DVIPDF   = dvipdf
PS2PDF   = ps2pdf
MAINFILE = $(shell ls *_*.tex | awk -F '.' '{ print $$1}')
DATETIME = $(shell date +"%Y%m%d_%H%M%S")

# List of class and style files
# CLASSFILE  = MichiganTechBeamer.cls
STYLEFILES = MichiganTechBeamer.sty

# List of temporary file types
TMPFILES = acr \
           alg \
           aux \
           bbl \
           bcf \
           blg \
           blx \
           brf \
           dvi \
           fdb_latexmk \
           fls \
           glg \
           glo \
           gls \
           idx \
           ilg \
           ind \
           ist \
           loa \
           lof \
           log \
           lol \
           lot \
           maf \
           mtc \
           mtc0 \
           nav \
           nlo \
           out \
           pdfsync  \
           ps \
           pyg \
           run.xml \
           sagetex.py \
           sagetex.sage \
           sagetex.scmd \
           snm \
           sout \
           sympy \
           synctex.gz \
           tdo \
           thm \
           toc \
           vrb \
           xdy

# Default target
all:
	make clean
	make presentation
	make distribution
	make clean

presentation:
	@echo
	@echo "  Slides for presentation (with animation/transition)"
	@echo
	pdflatex --shell-escape $(MAINFILE).tex
	pdflatex --shell-escape $(MAINFILE).tex
	@echo
	@echo

distribution:
	@echo
	@echo "  Slides for distribution (without animation/transition)"
	@echo
	sed 's/aspectratio=43/handout,aspectratio=43/g' $(MAINFILE).tex > $(MAINFILE)_distribution.tex
	pdflatex --shell-escape $(MAINFILE)_distribution.tex
	pdflatex --shell-escape $(MAINFILE)_distribution.tex
	mv $(MAINFILE)_distribution.pdf distribution.pdf
	rm -f $(MAINFILE)_distribution.*
	mv distribution.pdf $(MAINFILE)_distribution.pdf
	@echo
	@echo

snapshot:
	@echo
	@echo "  Making a snapshot of all files and folders"
	@echo
	$(MKDIR) -p Snapshots/$(DATETIME)
	rsync -a --exclude '*.swp' --exclude '.git' --exclude 'Snapshots' ./ Snapshots/$(DATETIME)/
	cd Snapshots/ ; $(ZIP) -qr $(DATETIME).zip $(DATETIME)
	cd Snapshots/ ; $(RM) -rf $(DATETIME)
	@echo
	@echo

clean:
	@echo
	@echo "  Removing temporary files"
	@echo
	for tmpfile in $(TMPFILES); do ( $(RM) -f $(MAINFILE).$$tmpfile* ); done
	rm -f *.gnuplot *.table
	@echo
	@echo
