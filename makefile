.PHONY : publish


publish : 
	git checkout gh-pages
	make gh-pages
	git push gh-pages
	git checkout master
