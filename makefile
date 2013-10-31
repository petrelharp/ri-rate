.PHONY : clean gh-pages

.SECONDARY : ri-rates-notes.xhtml ri-rates-notes.html

## TO-DO:
# automatically figure out which things to tex up

clean : 
	rm -f *.aux *.log *.bbl *.blg
	rm -f ri-rates-notes.xml ri-rates-notes.pdf 
	rm -f LaTeXML.cache

%.tex : clean
	git show master:$@ > $@

gh-pages : ri-rates-notes.xhtml ri-rates-notes.html
	echo "making all the pages"
	# git show master:ri-rates-notes.tex > ri-rates-notes.tex
	# rm ri-rates-notes.xhtml
	# make ri-rates-notes.xhtml
	git add ri-rates-notes.xhtml ri-rates-notes.html
	git commit -m "updated html"

%.html : %.tex
	rm -f LaTeXML.cache
	latexmlc --format=html5 --javascript=LaTeXML-maybeMathjax.js --css=plr-style.css --stylesheet=xsl/LaTeXML-all-xhtml.xsl --javascript=adjust-svg.js --destination=$@ $<

%.xhtml : %.xml
	latexmlpost --css=plr-style.css --javascript=LaTeXML-maybeMathjax.js --javascript=adjust-svg.js --stylesheet=xsl/LaTeXML-all-xhtml.xsl --destination=$@ $<

%.xml : %.tex
	rm -f LaTeXML.cache
	latexml --destination=$@ $<

%.svg : %.pdf
	inkscape $< --export-plain-svg=$@

%.png : %.pdf
	convert -density 300 $< -flatten $@
