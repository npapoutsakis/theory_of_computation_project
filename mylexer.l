/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

/* Below code is copied to lex.yy.c directly */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "cgen.h"
    
    int error();
    void saveMacro(char ***);
    void freeMacrosList(char ***, char ***);

    int lineCount = 1, macro_counter = 0;
    
    // for saving macros
    char **defmacro_values = NULL, **defmacro_ids = NULL;
%}

/*definitions*/
DIGIT [0-9]
IDENTIFIER [a-zA-Z][0-9a-zA-Z_]*
INTEGER_CONSTANT [+-]?{DIGIT}{DIGIT}*
FLOAT_CONSTANT ([+-]?{DIGIT}+\.{DIGIT}+([Ee][+-]?{DIGIT}+)?)
CONST_STRING \"[^\n]*\"
LINE_COMMENT "--"[^\n]*
NEW_LINE \n
WHITE_SPACE [ \t\r]

%x defmacro

/*rules*/
%%

"integer"            {printf("Line %d\t Token KEYWORD_INTEGER: %s\n", lineCount, yytext); }
"scalar"             {printf("Line %d\t Token KEYWORD_SCALAR: %s\n", lineCount, yytext); }
"str"                {printf("Line %d\t Token KEYWORD_STR: %s\n", lineCount, yytext); }
"bool"               {printf("Line %d\t Token KEYWORD_BOOL: %s\n", lineCount, yytext); }
"True"               {printf("Line %d\t Token KEYWORD_TRUE: %s\n", lineCount, yytext); }
"False"              {printf("Line %d\t Token KEYWORD_FALSE: %s\n", lineCount, yytext); }
"const"              {printf("Line %d\t Token KEYWORD_CONST: %s\n", lineCount, yytext); }
"if"                 {printf("Line %d\t Token KEYWORD_IF: %s\n", lineCount, yytext); }
"else"               {printf("Line %d\t Token KEYWORD_ELSE: %s\n", lineCount, yytext); }
"endif"              {printf("Line %d\t Token KEYWORD_ENDIF: %s\n", lineCount, yytext); }
"for"                {printf("Line %d\t Token KEYWORD_FOR: %s\n", lineCount, yytext); }
"in"                 {printf("Line %d\t Token KEYWORD_IN: %s\n", lineCount, yytext); }
"endfor"             {printf("Line %d\t Token KEYWORD_ENDFOR: %s\n", lineCount, yytext); }
"while"              {printf("Line %d\t Token KEYWORD_WHILE: %s\n", lineCount, yytext); }
"endwhile"           {printf("Line %d\t Token KEYWORD_ENDWHILE: %s\n", lineCount, yytext); }
"break"              {printf("Line %d\t Token KEYWORD_BREAK: %s\n", lineCount, yytext); }
"continue"           {printf("Line %d\t Token KEYWORD_CONTINUE: %s\n", lineCount, yytext); }
"not"                {printf("Line %d\t Token KEYWORD_NOT: %s\n", lineCount, yytext); }
"and"                {printf("Line %d\t Token KEYWORD_AND: %s\n", lineCount, yytext); }
"or"                 {printf("Line %d\t Token KEYWORD_OR: %s\n", lineCount, yytext); }
"def"                {printf("Line %d\t Token KEYWORD_DEF: %s\n", lineCount, yytext); }
"enddef"             {printf("Line %d\t Token KEYWORD_ENDDEF: %s\n", lineCount, yytext); freeMacrosList(&defmacro_ids, &defmacro_values); }
"main"               {printf("Line %d\t Token KEYWORD_BEGIN: %s\n", lineCount, yytext); }
"return"             {printf("Line %d\t Token KEYWORD_RETURN: %s\n", lineCount, yytext); }
"comp"               {printf("Line %d\t Token KEYWORD_COMP: %s\n", lineCount, yytext); }
"endcomp"            {printf("Line %d\t Token KEYWORD_ENDCOMP: %s\n", lineCount, yytext); }
"of"                 {printf("Line %d\t Token KEYWORD_OF: %s\n", lineCount, yytext); }


{IDENTIFIER}         {
    int isMacro = 0;
    /* need to check macros */
    for (int i = macro_counter - 1; i >= 0; i--){
        if(!strcmp(yytext, defmacro_ids[i])){
            printf("Line %d\t Token CONST_STRING: %s\n", lineCount, defmacro_values[i]);
            isMacro = 1;
            break;
        }
    }

    if(!isMacro)
        printf("Line %d\t Token IDENTIFIER: %s\n", lineCount, yytext);
}

{INTEGER_CONSTANT}   {printf("Line %d\t Token INTEGER_CONSTANT: %s\n", lineCount, yytext);}
{FLOAT_CONSTANT}     {printf("Line %d\t Token FLOAT_CONSTANT: %s\n", lineCount, yytext);}
{CONST_STRING}       {printf("Line %d\t Token CONST_STRING: %s\n", lineCount, yytext);}
{LINE_COMMENT}       {/*Skip line until you find \n character*/}
{WHITE_SPACE}        {/*Skipping white space*/}
{NEW_LINE}           {lineCount++;}


"+"                  {printf("Line %d\t Token ARITHMETIC_OP_PLUS: %s\n", lineCount, yytext); return '+';}
"-"                  {printf("Line %d\t Token ARITHMETIC_OP_MINUS: %s\n", lineCount, yytext); return '-';}
"*"                  {printf("Line %d\t Token ARITHMETIC_OP_MULT: %s\n", lineCount, yytext); return '*';}
"/"                  {printf("Line %d\t Token ARITHMETIC_OP_DIV: %s\n", lineCount, yytext);}
"%"                  {printf("Line %d\t Token ARITHMETIC_OP_MOD: %s\n", lineCount, yytext);}
"**"                 {printf("Line %d\t Token ARITHMETIC_OP_POW: %s\n", lineCount, yytext);}

"=="                 {printf("Line %d\t Token RELATIONAL_OP_EQUAL: %s\n", lineCount, yytext);}
"!="                 {printf("Line %d\t Token RELATIONAL_OP_NOT_EQUAL: %s\n", lineCount, yytext);}
"<"                  {printf("Line %d\t Token RELATIONAL_OP_LESS: %s\n", lineCount, yytext);}
"<="                 {printf("Line %d\t Token RELATIONAL_OP_LESS_OR_EQUAL: %s\n", lineCount, yytext);}
">"                  {printf("Line %d\t Token RELATIONAL_OP_GREATER: %s\n", lineCount, yytext);}
">="                 {printf("Line %d\t Token RELATIONAL_OP_GREATER_OR_EQUAL: %s\n", lineCount, yytext);}
 
"="                  {printf("Line %d\t Token ASSIGNMENT_OP_ASSIGN: %s\n", lineCount, yytext);}
"+="                 {printf("Line %d\t Token ASSIGNMENT_OP_ADD_ASSIGN: %s\n", lineCount, yytext);}
"-="                 {printf("Line %d\t Token ASSIGNMENT_OP_SUB_ASSIGN: %s\n", lineCount, yytext);}
"*="                 {printf("Line %d\t Token ASSIGNMENT_OP_MULT_ASSIGN: %s\n", lineCount, yytext);}
"/="                 {printf("Line %d\t Token ASSIGNMENT_OP_DIV_ASSIGN: %s\n", lineCount, yytext);}
"%="                 {printf("Line %d\t Token ASSIGNMENT_OP_MOD_ASSIGN: %s\n", lineCount, yytext);}
":="                 {printf("Line %d\t Token ASSIGNMENT_OP_COLON_ASSIGN: %s\n", lineCount, yytext);}

";"                  {printf("Line %d\t Token SEMICOLON: %s\n", lineCount, yytext);}
"("                  {printf("Line %d\t Token LEFT_PARENTHESIS: %s\n", lineCount, yytext);}
")"                  {printf("Line %d\t Token RIGHT_PARENTHESIS: %s\n", lineCount, yytext);}
","                  {printf("Line %d\t Token COMMA: %s\n", lineCount, yytext);}
"["                  {printf("Line %d\t Token LEFT_BRACKET: %s\n", lineCount, yytext);}
"]"                  {printf("Line %d\t Token RIGHT_BRACKET: %s\n", lineCount, yytext);}
":"                  {printf("Line %d\t Token COLON: %s\n", lineCount, yytext);}
"."                  {printf("Line %d\t Token DOT: %s\n", lineCount, yytext);}

"#"                  {printf("Line %d\t Token MEMBER_VARIABLE_OP: %s\n", lineCount, yytext);}
"->"                 {printf("Line %d\t Token FUNCTION_RETURN_OP: %s\n", lineCount, yytext);}


"@defmacro"                                      { macro_counter++; BEGIN(defmacro); }
<defmacro>{WHITE_SPACE}                          { /* Do nothing*/ }
<defmacro>{IDENTIFIER}                           { saveMacro(&defmacro_ids); }
<defmacro>{CONST_STRING}                         { saveMacro(&defmacro_values); }
<defmacro>{INTEGER_CONSTANT}|{FLOAT_CONSTANT}    { saveMacro(&defmacro_values); }
<defmacro>{NEW_LINE}                             { lineCount++; BEGIN(INITIAL); }


. {
    /*If unrecognized character appears*/
    error();
}


%%
/* user code section */
int error(){
    printf("Unknown character on line %d: %s\n", lineCount, yytext);
    return -1;
}

/* calling saveMacro with by reference parameters*/
void saveMacro(char ***macros){
    char **temp = (char **)realloc(*macros,  macro_counter * sizeof(char *));

    *macros = temp;

    /* assign to 0 element first */
    (*macros)[macro_counter - 1] = strdup(yytext);
}

/* free occupied space*/
void freeMacrosList(char ***ids, char ***values){
    for(int i=0; i < macro_counter; i++){
        free((*ids)[i]);
        free((*values)[i]);
    }
    *ids = NULL;
    *values = NULL;
}