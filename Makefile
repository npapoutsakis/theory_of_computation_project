
all:	
	flex mylexer.l  
	gcc -o mylexer lex.yy.c -lfl  
	./mylexer < example.la

clean:
	rm -rf mylexer lex.yy.c