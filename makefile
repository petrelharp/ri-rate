.PHONY : clean gh-pages

## TO-DO:
# rejigger things so that the gh-pages branch does not have the primary files in
# i.e. the first step in make gh-pages is to checkout the relevant files from the master branch
# ideally parsing the .tex files to figure out what the prerequisites are (does latexml do this?)

clean : 
	rm -f *.aux *.log *.bbl *.blg
	rm -f ri-rates-notes.xml ri-rates-notes.pdf 
	rm -f LaTeXML.cache

%.tex : clean
	git show master:$@ > $@

gh-pages : ri-rates-notes.xhtml
	git show master:ri-rates-notes.tex > ri-rates-notes.tex
	rm ri-rates-notes.xhtml
	make ri-rates-notes.xhtml

%.html : %.tex
	rm -f LaTeXML.cache
	latexmlc --format=html5 --javascript=LaTeXML-maybeMathjax.js --css=plr-style.css --stylesheet=xsl/LaTeXML-all-xhtml.xsl --javascript=adjust-svg.js --destination=$@ $<

%.xhtml : %.xml
	latexmlpost --css=plr-style.css --javascript=LaTeXML-maybeMathjax.js --javascript=adjust-svg.js --stylesheet=xsl/LaTeXML-all-xhtml.xsl --destination=$@ $<

%.xml : %.tex
	rm -f LaTeXML.cache
	latexml --destination=$@ $<

%.pdf : %.tex
	rm -f $(patsubst %.tex,%.aux,$<)
	# pdflatex ri-rates-notes.tex
	# bibtex ri-rates-notes.aux
	pdflatex $<
	pdflatex $<

%.svg : %.pdf
	inkscape $< --export-plain-svg=$@

%.png : %.pdf
	convert -density 300 $< -flatten $@
