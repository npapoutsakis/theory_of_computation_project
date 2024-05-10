/* lexer file */

/* Below code is copied to lex.yy.c directly */
%{
    #include <stdio.h>
    int printError();
    int lineCount = 1;
%}

/*definitions*/

IDENTIFIER [a-zA-Z_][0-9a-zA-Z_]*
DIGIT [0-9]
SYMBOL  [-+*/:_$%!#@&~^()]*

%%

"integer"   {printf("Token KEYWORD_INTEGER: %s\n", yytext); }
"scalar"    {printf("Token KEYWORD_SCALAR: %s\n", yytext); }
"str"       {printf("Token KEYWORD_STR: %s\n", yytext); }
"bool"      {printf("Token KEYWORD_BOOL: %s\n", yytext); }
"True"      {printf("Token KEYWORD_TRUE: %s\n", yytext); }
"False"     {printf("Token KEYWORD_FALSE: %s\n", yytext); }
"const"     {printf("Token KEYWORD_CONST: %s\n", yytext); }
"if"        {printf("Token KEYWORD_IF: %s\n", yytext); }
"else"      {printf("Token KEYWORD_ELSE: %s\n", yytext); }
"endif"     {printf("Token KEYWORD_ENDIF: %s\n", yytext); }
"for"       {printf("Token KEYWORD_FOR: %s\n", yytext); }
"in"        {printf("Token KEYWORD_IN: %s\n", yytext); }
"endfor"    {printf("Token KEYWORD_ENDFOR: %s\n", yytext); }
"while"     {printf("Token KEYWORD_WHILE: %s\n", yytext); }
"endwhile"  {printf("Token KEYWORD_ENDWHILE: %s\n", yytext); }
"break"     {printf("Token KEYWORD_BREAK: %s\n", yytext); }
"continue"  {printf("Token KEYWORD_CONTINUE: %s\n", yytext); }
"not"       {printf("Token KEYWORD_NOT: %s\n", yytext); }
"and"       {printf("Token KEYWORD_AND: %s\n", yytext); }
"or"        {printf("Token KEYWORD_OR: %s\n", yytext); }
"def"       {printf("Token KEYWORD_DEF: %s\n", yytext); }
"enddef"    {printf("Token KEYWORD_ENDDEF: %s\n", yytext); }
"main"      {printf("Token KEYWORD_BEGIN: %s\n", yytext); }
"return"    {printf("Token KEYWORD_RETURN: %s\n", yytext); }
"comp"      {printf("Token KEYWORD_COMP: %s\n", yytext); }
"endcomp"   {printf("Token KEYWORD_ENDCOMP: %s\n", yytext); }
"of"        {printf("Token KEYWORD_OF: %s\n", yytext); }


{IDENTIFIER} {printf("Token INDENTIFIER: %s\n", yytext);}
{DIGIT}      {printf("Token DIGIT: %s\n", yytext);}


";" {printf("Token SEMICOLON: %s\n", yytext);}


"--"[^\n]*  {/*Skip comments*/}

\n           ++lineCount;

. { /*Skipping all other character*/ printError();}

%%
int printError(){
    printf("Unkown character on line %d -> %s\n", lineCount, yytext);
    return -1;
}