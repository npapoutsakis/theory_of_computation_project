all:
	bison -d -v -r all myanalyzer.y -Wcounterexamples
	flex mylexer.l
	gcc -o compiler lex.yy.c myanalyzer.tab.c cgen.c -lfl
	@if [ -f example.la ]; then ./compiler < example.la; echo -n ""; fi


test:
	gcc -o test c_file.c lambdalib.h -I.
	

clean:
	rm -rf mylexer compiler lex.yy.c myanalyzer.tab.c myanalyzer.tab.h myanalyzer.output c_file.c
	clear