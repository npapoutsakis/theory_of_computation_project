/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

%{
    #include <stdio.h>
    #include <math.h>
    #include "lambdalib.h"

    extern int yylex(void);
    void yyerror(const char *s);

    int line_num;
%}

%union{
    char *string;
    double value;
}


/*  Keywords */
%token KW_INTEGER
%token KW_SCALAR
%token KW_STR
%token KW_BOOL
%token KW_TRUE
%token KW_FALSE
%token KW_CONST
%token KW_IF
%token KW_ELSE
%token KW_ENDIF
%token KW_FOR
%token KW_IN
%token KW_ENDFOR
%token KW_WHILE
%token KW_ENDWHILE
%token KW_BREAK
%token KW_CONTINUE
%token KW_NOT
%token KW_AND
%token KW_OR
%token KW_DEF
%token KW_ENDDEF
%token KW_BEGIN
%token KW_RETURN
%token KW_COMP
%token KW_ENDCOMP
%token KW_OF

/* Regular Expressions */
%token TK_ID
%token <value> TK_INT
%token <value> TK_FLOAT
%token TK_STRING

%token FN_RETURN

/* Symbols with priorities*/
%right ASSIGN SELF_ADD SELF_SUB SELF_MULT SELF_DIV SELF_MOD SELF_CLN_ASSIGN
%left KW_OR
%left KW_AND
%right KW_NOT
%left RP_EQUAL RP_NOT_EQUAL
%left RP_LESS RP_LESS_EQUAL RP_GREATER RP_GREARER_EQUAL
%left '+' '-'
%left '*' '/' '%'
%right FN_POW
%left '.' '(' ')' '[' ']'



%type <value> expr


%%
/* grammar expressions */

expr:
    TK_FLOAT
|    TK_INT
|   expr '+' expr {$$ = $1 + $3;}
|   expr '-' expr {$$ = $1 - $3;}
|   expr '*' expr {$$ = $1 * $3;}
|   expr '/' expr {$$ = $1 / $3;}
;


















%%
int main(){
    if( yyparse() == 0 ){
        printf("\x1b[31m""Rejected!\n""\x1b[0m");
        return -1;
    }

    printf("\x1b[32m""Accepted!\n""\x1b[0m");
}