.PHONY : clean gh-pages

## TO-DO:
# rejigger things so that the gh-pages branch does not have the primary files in
# i.e. the first step in make gh-pages is to checkout the relevant files from the master branch
# ideally parsing the .tex files to figure out what the prerequisites are (does latexml do this?)

clean : 
	rm -f *.aux *.log *.bbl *.blg
	rm -f x1.png x2.png x3.png x4.png x5.png x6.png x7.png x8.png x9.png x10.png 
	rm -f ri-rates-notes.xml ri-rates-notes.pdf ri-rates-notes.html
	rm -f LaTeXML.cache

PDFFIGS = $(wildcard fig/*.pdf)
SVGFIGS = $(patsubst %.pdf,%.svg,$(PDFFIGS))
TEXFILES = ri-rates-notes.tex intro.tex methods.tex results.tex demographic-model-appendix.tex 
BIBFILES = 

gh-pages : ri-rates-notes.xhtml
	git show master:ri-rates-notes.tex > ri-rates-notes.tex
	rm ri-rates-notes.xhtml
	make ri-rates-notes.xhtml

ri-rates-notes.html : $(TEXFILES) $(SVGFIGS) $(BIBFILES)
	rm -f LaTeXML.cache
	latexmlc --format=html5 --javascript=LaTeXML-maybeMathjax.js --css=plr-style.css --stylesheet=xsl/LaTeXML-all-xhtml.xsl --javascript=adjust-svg.js --destination=$@ ri-rates-notes.tex

ri-rates-notes.xhtml : $(TEXFILES) $(SVGFIGS) $(BIBFILES)
	rm -f LaTeXML.cache
	latexml --destination=ri-rates-notes.xml $<
	latexmlpost --css=plr-style.css --javascript=LaTeXML-maybeMathjax.js --javascript=adjust-svg.js --stylesheet=xsl/LaTeXML-all-xhtml.xsl --destination=$@ ri-rates-notes.xml

%.xml : %.tex
	latexml --destination=$@ $<

%.xhtml : %.xml
	latexmlpost --css=plr-style.css --javascript=LaTeXML-maybeMathjax.js --javascript=adjust-svg.js --stylesheet=xsl/LaTeXML-all-xhtml.xsl --destination=$@ $<
	-cp plr-style.css $(@D)
	-cp adjust-svg.js $(@D)

ri-rates-notes.pdf : $(TEXFILES) $(PDFFIGS) $(BIBFILES)
	rm -f ri-rates-notes.aux
	# pdflatex ri-rates-notes.tex
	# bibtex ri-rates-notes.aux
	pdflatex ri-rates-notes.tex
	pdflatex ri-rates-notes.tex

%.svg : %.pdf
	inkscape $< --export-plain-svg=$@

%.png : %.pdf
	convert -density 300 $< -flatten $@
