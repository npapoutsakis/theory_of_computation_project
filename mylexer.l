/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

/* Below code is copied to lex.yy.c directly */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "cgen.h"
    // #include "myanalyzer.tab.h"

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
WHITE_SPACE [ \t\r]+

%x defmacro

/*rules*/
%%

"integer"            {printf("Line %d\t Token KEYWORD_INTEGER:             \t\t%s\n", lineCount, yytext); }
"scalar"             {printf("Line %d\t Token KEYWORD_SCALAR:              \t\t%s\n", lineCount, yytext); }
"str"                {printf("Line %d\t Token KEYWORD_STR:                 \t\t%s\n", lineCount, yytext); }
"bool"               {printf("Line %d\t Token KEYWORD_BOOL:                \t\t%s\n", lineCount, yytext); }
"True"               {printf("Line %d\t Token KEYWORD_TRUE:                \t\t%s\n", lineCount, yytext); }
"False"              {printf("Line %d\t Token KEYWORD_FALSE:               \t\t%s\n", lineCount, yytext); }
"const"              {printf("Line %d\t Token KEYWORD_CONST:               \t\t%s\n", lineCount, yytext); }
"if"                 {printf("Line %d\t Token KEYWORD_IF:                  \t\t%s\n", lineCount, yytext); }
"else"               {printf("Line %d\t Token KEYWORD_ELSE:                \t\t%s\n", lineCount, yytext); }
"endif"              {printf("Line %d\t Token KEYWORD_ENDIF:               \t\t%s\n", lineCount, yytext); }
"for"                {printf("Line %d\t Token KEYWORD_FOR:                 \t\t%s\n", lineCount, yytext); }
"in"                 {printf("Line %d\t Token KEYWORD_IN:                  \t\t%s\n", lineCount, yytext); }
"endfor"             {printf("Line %d\t Token KEYWORD_ENDFOR:              \t\t%s\n", lineCount, yytext); }
"while"              {printf("Line %d\t Token KEYWORD_WHILE:               \t\t%s\n", lineCount, yytext); }
"endwhile"           {printf("Line %d\t Token KEYWORD_ENDWHILE:            \t\t%s\n", lineCount, yytext); }
"break"              {printf("Line %d\t Token KEYWORD_BREAK:               \t\t%s\n", lineCount, yytext); }
"continue"           {printf("Line %d\t Token KEYWORD_CONTINUE:            \t\t%s\n", lineCount, yytext); }
"not"                {printf("Line %d\t Token KEYWORD_NOT:                 \t\t%s\n", lineCount, yytext); }
"and"                {printf("Line %d\t Token KEYWORD_AND:                 \t\t%s\n", lineCount, yytext); }
"or"                 {printf("Line %d\t Token KEYWORD_OR:                  \t\t%s\n", lineCount, yytext); }
"def"                {printf("Line %d\t Token KEYWORD_DEF:                 \t\t%s\n", lineCount, yytext); }
"enddef"             {printf("Line %d\t Token KEYWORD_ENDDEF:              \t\t%s\n", lineCount, yytext); }
"main"               {printf("Line %d\t Token KEYWORD_BEGIN:               \t\t%s\n", lineCount, yytext); }
"return"             {printf("Line %d\t Token KEYWORD_RETURN:              \t\t%s\n", lineCount, yytext); }
"comp"               {printf("Line %d\t Token KEYWORD_COMP:                \t\t%s\n", lineCount, yytext); }
"endcomp"            {printf("Line %d\t Token KEYWORD_ENDCOMP:             \t\t%s\n", lineCount, yytext); }
"of"                 {printf("Line %d\t Token KEYWORD_OF:                  \t\t%s\n", lineCount, yytext); }


{IDENTIFIER}         {
    int isMacro = 0;
    /* need to check macros */
    for (int i = macro_counter - 1; i >= 0; i--){
        if(!strcmp(yytext, defmacro_ids[i])){
            printf("Line %d\t Token CONST_STRING:                \t\t%s\n", lineCount, defmacro_values[i]);
            isMacro = 1;
            break;
        }
    }

    if(!isMacro)
        printf("Line %d\t Token IDENTIFIER:                \t\t%s\n", lineCount, yytext);
}


{INTEGER_CONSTANT}   {printf("Line %d\t Token INTEGER_CONSTANT:            \t\t%s\n", lineCount, yytext);}
{FLOAT_CONSTANT}     {printf("Line %d\t Token FLOAT_CONSTANT:              \t\t%s\n", lineCount, yytext);}
{CONST_STRING}       {printf("Line %d\t Token CONST_STRING:                \t\t%s\n", lineCount, yytext);}
{LINE_COMMENT}       {/*Skip line until you find \n character*/}
{WHITE_SPACE}        {/*Skipping white space*/}
{NEW_LINE}           {lineCount++;}


"+"                  {printf("Line %d\t Token ARITHMETIC_OP_PLUS:          \t\t%s\n", lineCount, yytext); return '+';}
"-"                  {printf("Line %d\t Token ARITHMETIC_OP_MINUS:         \t\t%s\n", lineCount, yytext); return '-';}
"*"                  {printf("Line %d\t Token ARITHMETIC_OP_MULT:          \t\t%s\n", lineCount, yytext); return '*';}
"/"                  {printf("Line %d\t Token ARITHMETIC_OP_DIV:           \t\t%s\n", lineCount, yytext); return '/';}
"%"                  {printf("Line %d\t Token ARITHMETIC_OP_MOD:           \t\t%s\n", lineCount, yytext); return '%';}
"**"                 {printf("Line %d\t Token ARITHMETIC_OP_POW:           \t\t%s\n", lineCount, yytext);}

"=="                 {printf("Line %d\t Token RELATIONAL_OP_EQUAL:         \t\t%s\n", lineCount, yytext);}
"!="                 {printf("Line %d\t Token RELATIONAL_OP_NOT_EQUAL:     \t\t%s\n", lineCount, yytext);}
"<"                  {printf("Line %d\t Token RELATIONAL_OP_LESS:          \t\t%s\n", lineCount, yytext);}
"<="                 {printf("Line %d\t Token RELATIONAL_OP_LESS_OR_EQUAL: \t\t%s\n", lineCount, yytext);}
">"                  {printf("Line %d\t Token RELATIONAL_OP_GREATER:       \t\t%s\n", lineCount, yytext);}
">="                 {printf("Line %d\t Token RELATIONAL_OP_GREATER_OR_EQUAL: \t\t%s\n", lineCount, yytext);}

"="                  {printf("Line %d\t Token ASSIGNMENT_OP_ASSIGN:       \t\t%s\n", lineCount, yytext);}
"+="                 {printf("Line %d\t Token ASSIGNMENT_OP_ADD_ASSIGN:   \t\t%s\n", lineCount, yytext);}
"-="                 {printf("Line %d\t Token ASSIGNMENT_OP_SUB_ASSIGN:   \t\t%s\n", lineCount, yytext);}
"*="                 {printf("Line %d\t Token ASSIGNMENT_OP_MULT_ASSIGN:  \t\t%s\n", lineCount, yytext);}
"/="                 {printf("Line %d\t Token ASSIGNMENT_OP_DIV_ASSIGN:   \t\t%s\n", lineCount, yytext);}
"%="                 {printf("Line %d\t Token ASSIGNMENT_OP_MOD_ASSIGN:   \t\t%s\n", lineCount, yytext);}
":="                 {printf("Line %d\t Token ASSIGNMENT_OP_COLON_ASSIGN: \t\t%s\n", lineCount, yytext);}

";"                  {printf("Line %d\t Token SEMICOLON:                  \t\t%s\n", lineCount, yytext); return ';';}
"("                  {printf("Line %d\t Token LEFT_PARENTHESIS:           \t\t%s\n", lineCount, yytext); return '(';}
")"                  {printf("Line %d\t Token RIGHT_PARENTHESIS:          \t\t%s\n", lineCount, yytext); return ')';}
","                  {printf("Line %d\t Token COMMA:                      \t\t%s\n", lineCount, yytext); return ',';}
"["                  {printf("Line %d\t Token LEFT_BRACKET:               \t\t%s\n", lineCount, yytext); return '[';}
"]"                  {printf("Line %d\t Token RIGHT_BRACKET:              \t\t%s\n", lineCount, yytext); return ']';}
":"                  {printf("Line %d\t Token COLON:                      \t\t%s\n", lineCount, yytext); return ':';}
"."                  {printf("Line %d\t Token DOT:                        \t\t%s\n", lineCount, yytext); return '.';}

"#"                  {printf("Line %d\t Token MEMBER_VARIABLE_OP:         \t\t%s\n", lineCount, yytext);}
"->"                 {printf("Line %d\t Token FUNCTION_RETURN_OP:         \t\t%s\n", lineCount, yytext);}



"@defmacro"                                      { macro_counter++; BEGIN(defmacro); }
<defmacro>{WHITE_SPACE}                          { /* Do nothing*/ }
<defmacro>{IDENTIFIER}                           { saveMacro(&defmacro_ids); }
<defmacro>{CONST_STRING}                         { saveMacro(&defmacro_values); }
<defmacro>{INTEGER_CONSTANT}|{FLOAT_CONSTANT}    { saveMacro(&defmacro_values); }
<defmacro>{NEW_LINE}                             { lineCount++; BEGIN(INITIAL); }


<<EOF>>                                          { return EOF; }

. {
    /*If unrecognized character appears*/
    error();
}


%%
/* user-defined code*/
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