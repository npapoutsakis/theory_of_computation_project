/* lexer file /

/ Below code is copied to lex.yy.c directly /
%{
    int lineCount = 1;
%}

/*definitions*/

IDENTIFIER [a-zA-Z]

%%

{IDENTIFIER} {printf("%s\n", yytext);}


. {/*Skiping all other character*/}

%%
