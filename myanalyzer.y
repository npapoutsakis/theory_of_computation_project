/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

%{
    #include <stdio.h>
    #include <math.h>
    #include "lambdalib.h"
    #include "cgen.h"

    extern int yylex(void);
    int line_num;
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
%token <string> TK_DOUBLE
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
%type <string> comp_structure
%type <string> comp_variables_declaration
/* %type <string> comp_function_declaration */
%type <string> comp_var_list

/* variable declaration */
%type <string> variable_declaration
%type <string> var_body
%type <string> var_list
%type <string> var_type

%type <string> const_declaration
%type <string> const_var_list
%type <string> const_value
%type <string> const_var_body

%type <string> declaration

%%
/* grammar expressions */
program:
    program_body {  FILE* fp = fopen("c_file.c", "w");

                    fputs("/* Computation Theory Project 2024  */\n", fp);
                    fputs("/*      Nikolaos Papoutsakis        */\n", fp);
                    fputs("/*           2019030206             */\n", fp);
                    
                    fputs("\n#include <stdio.h>\n", fp);
                    fputs("#include <stdlib.h>\n", fp);
                    fputs("#include <math.h>\n", fp);
                    fputs(c_prologue, fp);         

                    // here add the rest of the code
                    $$ = template("%s", $1);
                    fprintf(fp, "%s", $1);

                    fclose(fp);
                }   
;

program_body:
    program_body declaration {$$ = template("%s\n%s", $1, $2);}
|   declaration
;

declaration:
    variable_declaration { $$ = template("%s", $1); }
|   const_declaration { $$ = template("%s", $1); }
|   comp_declaration { $$ = template("%s", $1); }
;



/* Constant Variables */
const_declaration:
    const_var_body { $$ = template("%s", $1); }
|   const_var_body const_declaration { $$ = template("%s\n%s", $1, $2); }
;

const_var_body:
    KW_CONST const_var_list ':' var_type ';' { $$ = template("const %s %s;", $4, $2); }
;

const_var_list:
    TK_ID ASSIGN const_value { $$ = template("%s = %s", $1, $3); }
;

const_value:
    TK_DOUBLE { $$ = $1; }
|   TK_INT { $$ = $1; }
|   TK_STRING { $$ = $1; }
|   KW_TRUE { $$ = "1"; }
|   KW_FALSE { $$ = "0"; }
;





/* General Variables */
variable_declaration:
    var_body {$$ = template("%s", $1);}
|   var_body variable_declaration {$$ = template("%s\n%s", $1, $2);}
;

var_body:
    var_list ':' var_type ';' {$$ = template("%s %s;", $3, $1);}
;

var_list:
    TK_ID {$$ = template("%s", $1);}
|   TK_ID ',' var_list {$$ = template("%s, %s", $1, $3);}
|   TK_ID '[' TK_INT ']' {$$ = template("%s[%s]", $1, $3);}
|   TK_ID '[' TK_INT ']' ',' var_list {$$ = template("%s[%s], %s", $1, $3, $6);}
;

var_type:
    KW_INTEGER {$$ = template("int");}
|   KW_SCALAR {$$ = template("double");}
|   KW_STR {$$ = template("char*");}
|   KW_BOOL {$$ = template("int");}
;








/* Complex Variables Declaration */
comp_declaration:
    comp_structure   {$$=template("%s\n", $1);}
|   comp_declaration comp_structure {$$=template("%s\n%s", $1,$2);}
;

comp_structure:
    KW_COMP TK_ID ':' comp_body KW_ENDCOMP ';' {$$ = template("typedef struct %s {\n\t%s\n} %s;", $2, $4, $2); }
;

comp_body:
    %empty {$$ = "";}
|   comp_variables_declaration comp_body {$$ = template("%s\n\t%s", $1, $2);}
;


comp_variables_declaration:
    comp_var_list ':' var_type ';' {$$ = template("%s %s;", $3, $1);}
;

comp_var_list:
    '#' TK_ID {$$ = template("%s", $2);}
|   '#' TK_ID ',' comp_var_list {$$ = template("%s, %s", $2, $4);}
|   '#' TK_ID '[' TK_INT ']' {$$ = template("%s[%s]", $2, $4);}
|   '#' TK_ID '[' TK_INT ']' ',' comp_var_list {$$ = template("%s[%s], %s", $2, $4, $7);}
;





%%
int main() {
    if(!yyparse()){
        printf("\x1b[32m""Accepted!\n""\x1b[0m");
        return -1;
    }
    printf("\x1b[31m""Rejected!\n""\x1b[0m");
}