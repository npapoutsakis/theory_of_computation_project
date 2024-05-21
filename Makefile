
default:
	@echo "No default action. Try 'make flex' or 'make bison'"

bison:
	bison -d -v -r all myanalyzer.y -Wcounterexamples
	flex mylexer.l
	gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl
	./mycompiler < example.la

flex:
	flex mylexer.l  
	gcc -o mylexer lex.yy.c -lfl  
	./mylexer < example.la

clean:
	rm -rf mylexer mycompiler lex.yy.c myanalyzer.tab.c myanalyzer.tab.h myanalyzer.output c_file.c
	clear