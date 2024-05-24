all:
	bison -d -v -r all myanalyzer.y
	flex mylexer.l
	gcc -o compiler lex.yy.c myanalyzer.tab.c cgen.c -lfl
	@if [ -f example.la ]; then ./compiler < example.la; echo -n ""; fi

clean:
	rm -rf mylexer compiler lex.yy.c myanalyzer.tab.c myanalyzer.tab.h myanalyzer.output c_file.c
	clear