apl_core.so: apl.c
	cc -shared apl.c -l lapack -o apl_core.so

# --------------------------------------------------------------------
#
# Relevant to distribution

PACKAGE = apl.c apl.lua help.lua test.lua finnaplidiom.lua apl385.ttf lua-apl.xmodmap lua-apl.c lua-apl.html prog-guide.html README.md Makefile

zip: $(PACKAGE)
	zip lua-apl.zip $(PACKAGE)

#--------------------------------------------------------------------------
#
#  What follows below is relevant to the GitHub repository


all: apl_core.so lua-src/lua lua-apl.html prog-guide.html README.md

GITFILES = apl.c apl.lua help.lua test.lua finnaplidiom.lua apl385.ttf lua-apl.xmodmap lua-apl.c lua-apl.txt lua-apl.html prog-guide.html README.txt README.md Makefile

lua-src/lua: lua-apl.c
	cp lua-apl.c lua-src/lua.c
	make -C lua-src linux

README.md: README.txt Makefile
	pandoc -t markdown_github README.txt -o README.md

lua-apl.html: lua-apl.txt Makefile
	pandoc -s lua-apl.txt -o lua-apl.html

prog-guide.html: prog-guide.txt Makefile
	pandoc -s prog-guide.txt -o prog-guide.html

commit: $(GITFILES)
	git add $(GITFILES)

