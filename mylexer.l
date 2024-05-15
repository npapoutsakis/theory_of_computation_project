/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

/* Below code is copied to lex.yy.c directly */
%{
    #include <stdio.h>
    #include "cgen.h"
    
    int printError();
    int lineCount = 1;
%}

/*definitions*/
DIGIT [0-9]
IDENTIFIER [a-zA-Z][0-9a-zA-Z_]*
INTEGER_CONSTANT {DIGIT}{DIGIT}*
FLOAT_CONSTANT ([+-]?{DIGIT}+\.{DIGIT}+([Ee][+-]?{DIGIT}+)?)
CONST_STRING \"[^\n]*\"
LINE_COMMENT "--"[^\n]*
NEW_LINE \n
WHITE_SPACE [ \t\r]

%x defmacro

/*rules*/
%%

"integer"            {printf("Token KEYWORD_INTEGER: %s\n", yytext); }
"scalar"             {printf("Token KEYWORD_SCALAR: %s\n", yytext); }
"str"                {printf("Token KEYWORD_STR: %s\n", yytext); }
"bool"               {printf("Token KEYWORD_BOOL: %s\n", yytext); }
"True"               {printf("Token KEYWORD_TRUE: %s\n", yytext); }
"False"              {printf("Token KEYWORD_FALSE: %s\n", yytext); }
"const"              {printf("Token KEYWORD_CONST: %s\n", yytext); }
"if"                 {printf("Token KEYWORD_IF: %s\n", yytext); }
"else"               {printf("Token KEYWORD_ELSE: %s\n", yytext); }
"endif"              {printf("Token KEYWORD_ENDIF: %s\n", yytext); }
"for"                {printf("Token KEYWORD_FOR: %s\n", yytext); }
"in"                 {printf("Token KEYWORD_IN: %s\n", yytext); }
"endfor"             {printf("Token KEYWORD_ENDFOR: %s\n", yytext); }
"while"              {printf("Token KEYWORD_WHILE: %s\n", yytext); }
"endwhile"           {printf("Token KEYWORD_ENDWHILE: %s\n", yytext); }
"break"              {printf("Token KEYWORD_BREAK: %s\n", yytext); }
"continue"           {printf("Token KEYWORD_CONTINUE: %s\n", yytext); }
"not"                {printf("Token KEYWORD_NOT: %s\n", yytext); }
"and"                {printf("Token KEYWORD_AND: %s\n", yytext); }
"or"                 {printf("Token KEYWORD_OR: %s\n", yytext); }
"def"                {printf("Token KEYWORD_DEF: %s\n", yytext); }
"enddef"             {printf("Token KEYWORD_ENDDEF: %s\n", yytext); }
"main"               {printf("Token KEYWORD_BEGIN: %s\n", yytext); }
"return"             {printf("Token KEYWORD_RETURN: %s\n", yytext); }
"comp"               {printf("Token KEYWORD_COMP: %s\n", yytext); }
"endcomp"            {printf("Token KEYWORD_ENDCOMP: %s\n", yytext); }
"of"                 {printf("Token KEYWORD_OF: %s\n", yytext); }


{IDENTIFIER}         {printf("Token INDENTIFIER: %s\n", yytext);}
{INTEGER_CONSTANT}   {printf("Token INTEGER_CONSTANT: %s\n", yytext);}
{FLOAT_CONSTANT}     {printf("Token FLOAT_CONSTANT: %s\n", yytext);}
{CONST_STRING}       {printf("Token CONST_STRING: %s\n", yytext);}
{LINE_COMMENT}       {/*Skip line until you find \n character*/}
{WHITE_SPACE}        {/*Skipping white space*/}
{NEW_LINE}           {lineCount++;}


"+"                  {printf("Token ARITHMETIC_OP_PLUS: %s\n", yytext);}
"-"                  {printf("Token ARITHMETIC_OP_MINUS: %s\n", yytext);}
"*"                  {printf("Token ARITHMETIC_OP_MULT: %s\n", yytext);}
"/"                  {printf("Token ARITHMETIC_OP_DIV: %s\n", yytext);}
"%"                  {printf("Token ARITHMETIC_OP_MOD: %s\n", yytext);}
"**"                 {printf("Token ARITHMETIC_OP_POW: %s\n", yytext);}

"=="                 {printf("Token RELATIONAL_OP_EQUAL: %s\n", yytext);}
"!="                 {printf("Token RELATIONAL_OP_NOT_EQUAL: %s\n", yytext);}
"<"                  {printf("Token RELATIONAL_OP_LESS: %s\n", yytext);}
"<="                 {printf("Token RELATIONAL_OP_LESS_OR_EQUAL: %s\n", yytext);}
">"                  {printf("Token RELATIONAL_OP_GREATER: %s\n", yytext);}
">="                 {printf("Token RELATIONAL_OP_GREATER_OR_EQUAL: %s\n", yytext);}

"="                  {printf("Token ASSIGNMENT_OP_ASSIGN: %s\n", yytext);}
"+="                 {printf("Token ASSIGNMENT_OP_ADD_ASSIGN: %s\n", yytext);}
"-="                 {printf("Token ASSIGNMENT_OP_SUB_ASSIGN: %s\n", yytext);}
"*="                 {printf("Token ASSIGNMENT_OP_MULT_ASSIGN: %s\n", yytext);}
"/="                 {printf("Token ASSIGNMENT_OP_DIV_ASSIGN: %s\n", yytext);}
"%="                 {printf("Token ASSIGNMENT_OP_MOD_ASSIGN: %s\n", yytext);}
":="                 {printf("Token ASSIGNMENT_OP_COLON_ASSIGN: %s\n", yytext);}

";"                  {printf("Token SEMICOLON: %s\n", yytext);}
"("                  {printf("Token LEFT_PARENTHESIS: %s\n", yytext);}
")"                  {printf("Token RIGHT_PARENTHESIS: %s\n", yytext);}
","                  {printf("Token COMMA: %s\n", yytext);}
"["                  {printf("Token LEFT_BRACKET: %s\n", yytext);}
"]"                  {printf("Token RIGHT_BRACKET: %s\n", yytext);}
":"                  {printf("Token COLON: %s\n", yytext);}
"."                  {printf("Token DOT: %s\n", yytext);}

"#"                  {printf("Token MEMBER_VARIABLE_OP:%s\n", yytext);}
"->"                 {printf("Token FUNCTION_RETURN_OP: %s\n", yytext);}

"@defmacro"                      {BEGIN(defmacro);}
<defmacro>{WHITE_SPACE}          {/* Do nothing*/}
<defmacro>{IDENTIFIER}           {printf("Token INDENTIFIER: %s\n", yytext);}
<defmacro>{CONST_STRING}         {printf("Token CONST_STRING: %s\n", yytext);}
<defmacro>{NEW_LINE}             {BEGIN(INITIAL);}


. { 
    /*If unrecognized character appears*/
    printError();
}


%%
/* user code section */
int printError(){
    printf("Unknown character on line %d: %s\n", lineCount, yytext);
    return -1;
}