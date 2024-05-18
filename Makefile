
default:
	@echo "No default action. Try 'make flex' or 'make bison'"

flex:
	flex mylexer.l  
	gcc -o mylexer lex.yy.c -lfl  
	./mylexer < example.la

bison:
	bison -d -v -r all myanalyzer.y
	flex mylexer.l
	gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl
	./mycompiler < example.la

clean:
	rm -rf mylexer mycompiler lex.yy.c myanalyzer.tab.c myanalyzer.tab.h myanalyzer.output
	clear