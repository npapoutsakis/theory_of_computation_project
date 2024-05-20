/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

%{
    #include <stdio.h>
    #include <math.h>
    #include "lambdalib.h"
    #include "cgen.h"

    extern int yylex(void);

    int line_num = 1;
%}

%union{
    char *string;
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
%token <string> TK_ID
%token <string> TK_INT
%token <string> TK_FLOAT
%token <string> TK_STRING


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

%token ';'
%token FN_RETURN
%token '#'
%token ':'
%token ','


%start program
%type <string> program
%type <string> program_body

/* %type <string> main_function */
%type <string> comp_declaration
%type <string> comp_body
%type <string> comp_variables_declaration
%type <string> comp_function_declaration


%%

/* grammar expressions */
program:
    program_body {  FILE* fp = fopen("c_file.c", "w");
                    main_function
                    fputs("/* Computation Theory Project 2024  */\n", fp);
                    fputs("/*      Nikolaos Papoutsakis        */\n", fp);
                    fputs("/*           2019030206             */\n", fp);
                    
                    fputs("\n#include <stdio.h>\n", fp);
                    fputs("#include <stdlib.h>\n", fp);
                    fputs("#include <math.h>\n", fp);
                    fputs(c_prologue, fp);         

                    $$ = template("%s", $1);
                    // here add the rest of the code
                    fprintf(fp, "%s", $1);

                    fclose(fp);
                }   
;


program_body:
/* declarations in general(comps, variables, functions, globals, consts)*/
/* and the main function */
    comp_declaration {$$ = $1;}
/* simple global variable declaration */
/* constant variables declaration */
;



                    /*  All about complex type variables  */
/* ------------------------------------------------------------------------- */
comp_declaration:
    KW_COMP TK_ID ':' comp_body KW_ENDCOMP ';' {$$ = template("typedef struct %s {\n\t%s\n} %s;", $2, $4, $2);}
;


comp_body:
    %empty {$$ = "";}
|   comp_variables_declaration comp_body {$$ = $1;}
;

comp_variables_declaration:
;

/* ------------------------------------------------------------------------- */


%%
int main() {
    if(!yyparse()){
        printf("\x1b[32m""Accepted!\n""\x1b[0m");
        return -1;
    }

    printf("\x1b[31m""Rejected!\n""\x1b[0m");
}