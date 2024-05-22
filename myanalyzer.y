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
%type <string> basic_var_types
%type <string> general_declarations


%type <string> var_declarations
%type <string> var_identifiers

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




/* -------------------------------------------- Data types ---------------------------------------------*/

/* basic data types double, int, char *, int(boolean) */
basic_var_types:
    KW_SCALAR       {$$ = template("double ");}
|   KW_INTEGER      {$$ = template("int ");}
|   KW_STR          {$$ = template("char *");}
|   KW_BOOL         {$$ = template("int ");}
;

/* we also have arrays and comp data types with Identifiers and variabl */
var_identifiers:
    TK_ID   {$$ = $1;}
|   var_identifiers ',' TK_ID {$$ = template("%s, %s", $1, $3);}
;



/* declaration body is responsible for variable declaration (of any type) above main, that include functions and comps */
declaration_body:
    general_declarations                  {$$ = $1;}
|   declaration_body general_declarations {$$ = template("%s\n%s", $1, $2);}
;

/* Any type of declaration above main function */
general_declarations:
    var_declarations {$$ = $1;}
    /* add consts, comps and functions */
;

/* simple variables */
var_declarations:
    var_identifiers ':' basic_var_types ';' {
        if(!strcmp($3, "char *"))
            $$ = template("char %s;", apply_char_star($1));
        else
            $$ = template("%s %s;", $3, $1);
    }
;



function_body:
    %empty {$$ = template("");}
;


%%
int main() {
    if(!yyparse()){
        printf("\x1b[32m""Accepted!\n""\x1b[0m");
        return -1;
    }
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