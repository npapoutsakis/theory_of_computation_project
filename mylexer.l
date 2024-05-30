/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

/* Below code is copied to lex.yy.c directly */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "cgen.h"
    #include "myanalyzer.tab.h"

    int error();
    void saveMacro(char ***);
    void freeMacrosList(char ***, char ***);

    int line_num = 1, macro_counter = 0;
    
    // for saving macros
    char **defmacro_values = NULL, **defmacro_ids = NULL;
%}

/*definitions*/
DIGIT [0-9]
IDENTIFIER [a-zA-Z][0-9a-zA-Z_]*
INTEGER_CONSTANT {DIGIT}{DIGIT}*
DOUBLE_CONSTANT ([+-]?{DIGIT}+\.{DIGIT}+([Ee][+-]?{DIGIT}+)?)
CONST_STRING \"[^\n]*\"
LINE_COMMENT "--"[^\n]*
NEW_LINE \n
WHITE_SPACE [ \t\r]+

%x defmacro

/*rules*/
%%

"integer"            {printf("Line %d\t Token KEYWORD_INTEGER:             \t\t%s\n", line_num, yytext); return KW_INTEGER;}
"scalar"             {printf("Line %d\t Token KEYWORD_SCALAR:              \t\t%s\n", line_num, yytext); return KW_SCALAR;}
"str"                {printf("Line %d\t Token KEYWORD_STR:                 \t\t%s\n", line_num, yytext); return KW_STR;}
"bool"               {printf("Line %d\t Token KEYWORD_BOOL:                \t\t%s\n", line_num, yytext); return KW_BOOL;}
"True"               {printf("Line %d\t Token KEYWORD_TRUE:                \t\t%s\n", line_num, yytext); return KW_TRUE;}
"False"              {printf("Line %d\t Token KEYWORD_FALSE:               \t\t%s\n", line_num, yytext); return KW_FALSE;}
"const"              {printf("Line %d\t Token KEYWORD_CONST:               \t\t%s\n", line_num, yytext); return KW_CONST;}
"if"                 {printf("Line %d\t Token KEYWORD_IF:                  \t\t%s\n", line_num, yytext); return KW_IF;}
"else"               {printf("Line %d\t Token KEYWORD_ELSE:                \t\t%s\n", line_num, yytext); return KW_ELSE;}
"endif"              {printf("Line %d\t Token KEYWORD_ENDIF:               \t\t%s\n", line_num, yytext); return KW_ENDIF;}
"for"                {printf("Line %d\t Token KEYWORD_FOR:                 \t\t%s\n", line_num, yytext); return KW_FOR;}
"in"                 {printf("Line %d\t Token KEYWORD_IN:                  \t\t%s\n", line_num, yytext); return KW_IN;}
"endfor"             {printf("Line %d\t Token KEYWORD_ENDFOR:              \t\t%s\n", line_num, yytext); return KW_ENDFOR;}
"while"              {printf("Line %d\t Token KEYWORD_WHILE:               \t\t%s\n", line_num, yytext); return KW_WHILE;}
"endwhile"           {printf("Line %d\t Token KEYWORD_ENDWHILE:            \t\t%s\n", line_num, yytext); return KW_ENDWHILE;}
"break"              {printf("Line %d\t Token KEYWORD_BREAK:               \t\t%s\n", line_num, yytext); return KW_BREAK;}
"continue"           {printf("Line %d\t Token KEYWORD_CONTINUE:            \t\t%s\n", line_num, yytext); return KW_CONTINUE;}
"not"                {printf("Line %d\t Token KEYWORD_NOT:                 \t\t%s\n", line_num, yytext); return KW_NOT;}
"and"                {printf("Line %d\t Token KEYWORD_AND:                 \t\t%s\n", line_num, yytext); return KW_AND;}
"or"                 {printf("Line %d\t Token KEYWORD_OR:                  \t\t%s\n", line_num, yytext); return KW_OR;}
"def"                {printf("Line %d\t Token KEYWORD_DEF:                 \t\t%s\n", line_num, yytext); return KW_DEF;}
"enddef"             {printf("Line %d\t Token KEYWORD_ENDDEF:              \t\t%s\n", line_num, yytext); return KW_ENDDEF;}
"main"               {printf("Line %d\t Token KEYWORD_BEGIN:               \t\t%s\n", line_num, yytext); return KW_BEGIN;}
"return"             {printf("Line %d\t Token KEYWORD_RETURN:              \t\t%s\n", line_num, yytext); return KW_RETURN;}
"comp"               {printf("Line %d\t Token KEYWORD_COMP:                \t\t%s\n", line_num, yytext); return KW_COMP;}
"endcomp"            {printf("Line %d\t Token KEYWORD_ENDCOMP:             \t\t%s\n", line_num, yytext); return KW_ENDCOMP;}
"of"                 {printf("Line %d\t Token KEYWORD_OF:                  \t\t%s\n", line_num, yytext); return KW_OF;}


{IDENTIFIER}         {
    int isMacro = 0;
    /* need to check macros */
    for (int i = macro_counter - 1; i >= 0; i--){
        if(!strcmp(yytext, defmacro_ids[i])){
            yylval.string = strdup(defmacro_values[i]);
            printf("Line %d\t Token CONST_STRING:                \t\t%s\n", line_num, defmacro_values[i]);
            isMacro = 1;
            return TK_STRING;
        }
    }

    if(!isMacro){
        yylval.string = strdup(yytext);
        printf("Line %d\t Token IDENTIFIER:                \t\t%s\n", line_num, yytext);
        return TK_ID;
    }
}


{INTEGER_CONSTANT}   { yylval.string = strdup(yytext); printf("Line %d\t Token INTEGER_CONSTANT:            \t\t%s\n", line_num, yytext); return TK_INT;}
{DOUBLE_CONSTANT}    { yylval.string = strdup(yytext); printf("Line %d\t Token DOUBLE_CONSTANT:            \t\t%s\n", line_num, yytext); return TK_DOUBLE;}
{CONST_STRING}       { yylval.string = strdup(yytext); printf("Line %d\t Token CONST_STRING:                \t\t%s\n", line_num, yytext); return TK_STRING;}
{LINE_COMMENT}       {/*Skip line until you find \n character*/}
{WHITE_SPACE}        {/*Skipping white space*/}
{NEW_LINE}           {line_num++;}


"+"                  {printf("Line %d\t Token ARITHMETIC_OP_PLUS:          \t\t%s\n", line_num, yytext); return '+';}
"-"                  {printf("Line %d\t Token ARITHMETIC_OP_MINUS:         \t\t%s\n", line_num, yytext); return '-';}
"*"                  {printf("Line %d\t Token ARITHMETIC_OP_MULT:          \t\t%s\n", line_num, yytext); return '*';}
"/"                  {printf("Line %d\t Token ARITHMETIC_OP_DIV:           \t\t%s\n", line_num, yytext); return '/';}
"%"                  {printf("Line %d\t Token ARITHMETIC_OP_MOD:           \t\t%s\n", line_num, yytext); return '%';}
"**"                 {printf("Line %d\t Token ARITHMETIC_OP_POW:           \t\t%s\n", line_num, yytext); return FN_POW;}

"=="                 {printf("Line %d\t Token RELATIONAL_OP_EQUAL:         \t\t%s\n", line_num, yytext); return RP_EQUAL;}
"!="                 {printf("Line %d\t Token RELATIONAL_OP_NOT_EQUAL:     \t\t%s\n", line_num, yytext); return RP_NOT_EQUAL;}
"<"                  {printf("Line %d\t Token RELATIONAL_OP_LESS:          \t\t%s\n", line_num, yytext); return RP_LESS;}
"<="                 {printf("Line %d\t Token RELATIONAL_OP_LESS_OR_EQUAL: \t\t%s\n", line_num, yytext); return RP_LESS_EQUAL;}
">"                  {printf("Line %d\t Token RELATIONAL_OP_GREATER:       \t\t%s\n", line_num, yytext); return RP_GREATER;}
">="                 {printf("Line %d\t Token RELATIONAL_OP_GREATER_OR_EQUAL: \t\t%s\n", line_num, yytext); return RP_GREARER_EQUAL;}

"="                  {printf("Line %d\t Token ASSIGNMENT_OP_ASSIGN:       \t\t%s\n", line_num, yytext); return ASSIGN;}
"+="                 {printf("Line %d\t Token ASSIGNMENT_OP_ADD_ASSIGN:   \t\t%s\n", line_num, yytext); return SELF_ADD;}
"-="                 {printf("Line %d\t Token ASSIGNMENT_OP_SUB_ASSIGN:   \t\t%s\n", line_num, yytext); return SELF_SUB;}
"*="                 {printf("Line %d\t Token ASSIGNMENT_OP_MULT_ASSIGN:  \t\t%s\n", line_num, yytext); return SELF_MULT;}
"/="                 {printf("Line %d\t Token ASSIGNMENT_OP_DIV_ASSIGN:   \t\t%s\n", line_num, yytext); return SELF_DIV;}
"%="                 {printf("Line %d\t Token ASSIGNMENT_OP_MOD_ASSIGN:   \t\t%s\n", line_num, yytext); return SELF_MOD;}
":="                 {printf("Line %d\t Token ASSIGNMENT_OP_COLON_ASSIGN: \t\t%s\n", line_num, yytext); return SELF_CLN_ASSIGN;}

";"                  {printf("Line %d\t Token SEMICOLON:                  \t\t%s\n", line_num, yytext); return ';';}
"("                  {printf("Line %d\t Token LEFT_PARENTHESIS:           \t\t%s\n", line_num, yytext); return '(';}
")"                  {printf("Line %d\t Token RIGHT_PARENTHESIS:          \t\t%s\n", line_num, yytext); return ')';}
","                  {printf("Line %d\t Token COMMA:                      \t\t%s\n", line_num, yytext); return ',';}
"["                  {printf("Line %d\t Token LEFT_BRACKET:               \t\t%s\n", line_num, yytext); return '[';}
"]"                  {printf("Line %d\t Token RIGHT_BRACKET:              \t\t%s\n", line_num, yytext); return ']';}
":"                  {printf("Line %d\t Token COLON:                      \t\t%s\n", line_num, yytext); return ':';}
"."                  {printf("Line %d\t Token DOT:                        \t\t%s\n", line_num, yytext); return '.';}

"#"                  {printf("Line %d\t Token MEMBER_VARIABLE_OP:         \t\t%s\n", line_num, yytext); return '#';}
"->"                 {printf("Line %d\t Token FUNCTION_RETURN_OP:         \t\t%s\n", line_num, yytext); return FN_RETURN;}



"@defmacro"                                      { macro_counter++; BEGIN(defmacro); }
<defmacro>{WHITE_SPACE}                          { /* Do nothing*/ }
<defmacro>{IDENTIFIER}                           { saveMacro(&defmacro_ids); }
<defmacro>{CONST_STRING}                         { saveMacro(&defmacro_values); }
<defmacro>{INTEGER_CONSTANT}|{DOUBLE_CONSTANT}   { saveMacro(&defmacro_values); }
<defmacro>{NEW_LINE}                             { line_num++; BEGIN(INITIAL); }


<<EOF>>                                          { freeMacrosList(&defmacro_ids, &defmacro_values); return EOF; }

. {
    /*If unrecognized character appears*/
    error();
}


%%
/* user-defined code*/
int error(){
    printf("Unknown character on line %d: %s\n", line_num, yytext);
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