/* lexer file /

/ Below code is copied to lex.yy.c directly /
%{
    int lineCount = 1;
%}

/*definitions*/

IDENTIFIER [a-zA-Z][a-zA-Z0-9_]*
DIGIT [0-9]
SYMBOL  [-+*/:_$%!#@&~^()]*

%%

integer
scalar
str
bool
True
False
const
if
else
endif
for
in
endfor
while
endwhile
break
continue
not
and
or
def       {printf("Token KEYWORD_DEF: %s\n", yytext); }
enddef    {printf ("Token KEYWORD_ENDDEF: %s\n", yytext); }
main
return
comp
endcomp
of



{IDENTIFIER} {printf("Token INDENTIFIER: %s\n", yytext);}
{DIGIT}      {printf("Token DIGIT: %s\n", yytext);}


";" {printf("Token SEMICOLON: %s\n", yytext);}


"--"[^\n]*  /*Skip comments*/
[\t\n]


. {/*Skiping all other character*/}


%%
