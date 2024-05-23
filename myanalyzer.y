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
    char* apply_char_star(const char* var_list);
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
%type <string> c_file

%type <string> main_function
%type <string> declaration_body

%type <string> function_body
%type <string> general_var_types
%type <string> basic_var_types
%type <string> general_declarations


%type <string> var_declarations
%type <string> var_identifiers
%type <string> array_declaration

%type <string> const_declarations
%type <string> tokens

%type <string> comp_declarations
%type <string> comp_body
%type <string> comp_var_declarations
%type <string> comp_var_identifiers
%type <string> comp_array_var_declaration

%%

/* grammar expressions */
program:
    c_file { FILE* fp = fopen("c_file.c", "w");
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

/*------------------------------------- general structure - vars & main() ------------------------------*/
c_file:
    main_function                   {$$ = $1;}
|   declaration_body main_function  {$$ = template("%s\n%s\n", $1, $2);}
;


/*------------------------------------------ main function in c ----------------------------------------*/
main_function:
    KW_DEF KW_BEGIN '(' ')' ':' function_body KW_ENDDEF ';' {$$ = template("\nint main() {\n\t%s\n}", $6);}
;



/* declaration body is responsible for variable declaration (of any type) above main, that include functions and comps */
declaration_body:
    general_declarations                  {$$ = $1;}
|   declaration_body general_declarations {$$ = template("%s\n%s", $1, $2);}
;


/* -------------------------------------------- Data types ---------------------------------------------*/

/* Any type of declaration above main function */
general_declarations:
    var_declarations
|   const_declarations
|   comp_declarations
/* functions */
;

general_var_types:
    basic_var_types
|   TK_ID
;

/* simple variables */
var_declarations:
    var_identifiers ':' basic_var_types ';' {
        if(!strcmp($3, "char *"))
            $$ = template("char %s;", apply_char_star($1));
        else
            $$ = template("%s %s;", $3, $1);
    }
|   array_declaration ':' basic_var_types ';' {$$ = template("%s %s;", $3, $1);}
;

/* we also have arrays and comp data types with Identifiers and variable */
var_identifiers:
    TK_ID   {$$ = $1;}
|   var_identifiers ',' TK_ID {$$ = template("%s, %s", $1, $3);}
;

array_declaration:
    TK_ID '[' TK_INT ']'    {$$ = template("%s[%s]", $1, $3);}
|   array_declaration ',' TK_ID '[' TK_INT ']' {$$ = template("%s, %s[%s]", $1, $3, $5);}
;

/* basic data types double, int, char *, int(boolean) */
basic_var_types:
    KW_SCALAR       {$$ = template("double");}
|   KW_INTEGER      {$$ = template("int");}
|   KW_STR          {$$ = template("char *");}
|   KW_BOOL         {$$ = template("int");}
;

tokens:
    TK_INT
|   TK_DOUBLE
|   TK_STRING
;

/* constant variable grammar rules */
const_declarations:
    KW_CONST var_identifiers ASSIGN tokens ':' basic_var_types ';' {$$ = template("const %s %s = %s;", $6, $2, $4);}
;



/* -------------------------------------------- Complex type declarations ---------------------------------------------*/
comp_declarations:
    KW_COMP TK_ID ':' comp_body KW_ENDCOMP ';' {$$ = template("\ntypedef struct %s {\n%s\n} %s;", $2, $4, $2);}
;

comp_body:
    comp_var_declarations 
|   comp_var_declarations comp_body {$$ = template("%s\n%s", $1, $2);}
;

comp_var_declarations:
    comp_var_identifiers ':' general_var_types ';' {$$ = template("\t%s %s;", $3, $1);}
|   comp_array_var_declaration ':' general_var_types ';'  {$$ = template("\t%s %s;", $3, $1);}
;

comp_var_identifiers:
    '#' TK_ID {$$ = $2;}
|   '#' TK_ID ',' comp_var_identifiers {$$ = template("%s, %s", $2, $4);}
;

comp_array_var_declaration:
    '#' TK_ID '[' TK_INT ']' {$$ = template("%s[%s]", $2, $4);}
|   comp_array_var_declaration ',' '#' TK_ID '[' TK_INT ']' {$$ = template("%s, %s[%s]", $1, $4, $6);}
;

/* to do 
    1. comps 
    2. functions
    3. expressions
 */














function_body:
    %empty {$$ = template("");}
;


%%
int main() {
    if(!yyparse())
        printf("\x1b[32m""Accepted!\n""\x1b[0m"); return -1;

    printf("\x1b[31m""Rejected!\n""\x1b[0m");
}

char* apply_char_star(const char* var_list) {
    char* result = (char*)malloc(strlen(var_list) * 2 + 1); // allocate sufficient memory
    result[0] = '\0';
    const char* delim = ", ";
    char* token;
    char* input_copy = strdup(var_list); // duplicate var_list for safe tokenizing
    token = strtok(input_copy, delim);
    while (token != NULL) {
        strcat(result, "*");
        strcat(result, token);
        token = strtok(NULL, delim);
        if (token != NULL) {
            strcat(result, ", ");
        }
    }
    free(input_copy); // free the duplicated string
    return result;
}