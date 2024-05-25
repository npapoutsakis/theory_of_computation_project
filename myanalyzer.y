/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

%{
    #include "lambdalib.h"
    #include "cgen.h"

    int yylex(void);
    int line_num;
    char* apply_char_star(const char*);
    char* fix_multiple_char_stars(char *, char *, int);
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
%type <string> general_declarations
%type <string> general_var_types
%type <string> basic_var_types

%type <string> var_declarations
%type <string> var_identifiers
%type <string> array_declaration

%type <string> const_declarations
%type <string> assinged_values

%type <string> comp_declarations
%type <string> comp_body_check
%type <string> comp_body
%type <string> comp_var_declarations
%type <string> comp_var_identifiers
%type <string> comp_array_var_declaration
%type <string> comp_func_declarations


%type <string> function
%type <string> parameters
/* %type <string> return */


%type <string> general_expression
%type <string> arithmetic_expressions
%type <string> relational_expressions
%type <string> assigning_expressions
%type <string> identifier_expressions


%type <string> general_statements
%type <string> assign_statement
%type <string> if_statement
%type <string> for_loop_statement
%type <string> while_statement
%type <string> break_statement
%type <string> continue_statement
%type <string> return_statement
%type <string> function_statement
%type <string> empty_statement
/* %type <string> array_comprehension */

%type <string> function_arguments


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




/* -------------------------------------------- Variables -------------------------------------------- */
/* Any type of declaration above main function */
general_declarations:
    var_declarations
|   const_declarations
|   comp_declarations
|   function
;



/* -------------------------------------------- Data Types ---------------------------------------------*/
/* int, double, bool, string and complex types */
general_var_types:
    basic_var_types
|   TK_ID
;

/* basic data types double, int, char *, int(boolean) */
basic_var_types:
    KW_SCALAR       {$$ = template("double");}
|   KW_INTEGER      {$$ = template("int");}
|   KW_STR          {$$ = template("char *");}
|   KW_BOOL         {$$ = template("int");}
;




/* -------------------------------------------- Simple Variables Declaration ---------------------------------------------*/
var_declarations:
    var_identifiers ':' general_var_types ';'   {$$ = fix_multiple_char_stars($1, $3, 1);}
|   array_declaration ':' general_var_types ';' {$$ = fix_multiple_char_stars($1, $3, 1);}
;

/* we also have arrays and comp data types with Identifiers and variable */
var_identifiers:
    TK_ID                                          
|   var_identifiers ',' TK_ID {$$ = template("%s, %s", $1, $3);}
;

array_declaration:
    TK_ID '[' TK_INT ']'                       {$$ = template("%s[%s]", $1, $3);}
|   array_declaration ',' TK_ID '[' TK_INT ']' {$$ = template("%s, %s[%s]", $1, $3, $5);}
;




/* -------------------------------------------- Constant Variables Declaration ---------------------------------------------*/
const_declarations:
    KW_CONST var_identifiers ASSIGN assinged_values ':' general_var_types ';' {$$ = template("const %s %s = %s;", $6, $2, $4);}
;
assinged_values:
    TK_INT
|   TK_DOUBLE
|   TK_STRING
;



/* -------------------------------------------- Complex type declarations ---------------------------------------------*/
comp_declarations:
    KW_COMP TK_ID ':' comp_body_check KW_ENDCOMP ';' {
        $$ = template("\n#define SELF struct %s *self\n"
                        "typedef struct %s {\n%s\n} %s;\n"
                        "\n\n%s\n\n"
                        "const %s ctor_%s = { %s };\n"
                        "#undef SELF;", $2, $2, $4, $2, "", $2, $2, "", "");}
;

/* check if comp body is empty */
comp_body_check:
    %empty {$$ = "";}
|   comp_body
;

comp_body:
    comp_var_declarations 
|   comp_var_declarations comp_body  {$$ = template("%s\n%s", $1, $2);}
|   comp_func_declarations
|   comp_func_declarations comp_body {$$ = template("%s\n%s", $1, $2);}
;

comp_var_declarations:
    comp_var_identifiers ':' general_var_types ';'        {$$ = fix_multiple_char_stars($1, $3, 0);}
|   comp_array_var_declaration ':' general_var_types ';'  {$$ = fix_multiple_char_stars($1, $3, 0);}
;

comp_var_identifiers:
    '#' TK_ID                          {$$ = $2;}
|   '#' TK_ID ',' comp_var_identifiers {$$ = template("%s, %s", $2, $4);}
;

comp_array_var_declaration:
    '#' TK_ID '[' TK_INT ']'                                {$$ = template("%s[%s]", $2, $4);}
|   comp_array_var_declaration ',' '#' TK_ID '[' TK_INT ']' {$$ = template("%s, %s[%s]", $1, $4, $6);}
;

comp_func_declarations:
    KW_DEF TK_ID '(' parameters ')' ':' function_body KW_ENDDEF ';' {
        if(!strcmp($4, ""))
            $$ = template("\tvoid (*%s)(SELF);", $2);
        else
            $$ = template("\tvoid (*%s)(SELF, %s);", $2, $4);
    }
|   KW_DEF TK_ID '(' parameters ')' FN_RETURN general_var_types ':' function_body KW_ENDDEF ';' {
        if (!strcmp($4, ""))
            $$ = template("\t%s (*%s)(SELF);", $7, $2);
        else 
            $$ = template("\t%s (*%s)(SELF, %s);", $7, $2, $4);
    }
;



/* -------------------------------------------- Functions & Parameters Declaration ---------------------------------------------*/
function:
    KW_DEF TK_ID '(' parameters ')' ':' function_body KW_ENDDEF ';'                             {$$ = template("void %s(%s) {\n%s\n}\n", $2, $4, $7);}
|   KW_DEF TK_ID '(' parameters ')' FN_RETURN general_var_types ':' function_body KW_ENDDEF ';' {$$ = template("%s %s(%s) {\n%s\n}\n", $7, $2, $4, $9);}
;

parameters:
    %empty                                             {$$ = "";}
|   TK_ID ':' general_var_types                        {$$ = template("%s %s", $3, $1);}
|   TK_ID ':' general_var_types ',' parameters         {$$ = template("%s %s, %s", $3, $1, $5);}
|   TK_ID '[' ']' ':' general_var_types                {$$ = template("%s *%s", $5, $1);}
|   TK_ID '[' ']' ':' general_var_types ',' parameters {$$ = template("%s *%s, %s", $5, $1, $7);}
;

function_arguments:
    general_expression                        {$$ = template("%s", $1);}
|   general_expression ',' function_arguments {$$ = template("%s, %s", $1, $3);}
;

/* general function body */
function_body:
    general_statements
|   general_declarations
|   function_body general_statements    {$$ = template("%s\n%s", $1, $2);}
|   function_body general_declarations  {$$ = template("%s\n%s", $1, $2);}
;




/* -------------------------------------------- Expressions ---------------------------------------------*/
general_expression:
   '(' general_expression ')'                     {$$ = template("(%s)", $2);}
|   general_expression KW_AND general_expression  {$$ = template("%s && %s", $1, $3);}
|   general_expression KW_OR general_expression   {$$ = template("%s || %s", $1, $3);}
|   KW_NOT general_expression                     {$$ = template("!%s", $2);}
|   KW_TRUE                                       {$$ = "1";}
|   KW_FALSE                                      {$$ = "0";}
|   TK_STRING                                     {$$ = $1;}
|   arithmetic_expressions                        {$$ = $1;}
|   relational_expressions                        {$$ = $1;}
|   assigning_expressions                         {$$ = $1;}
|   identifier_expressions                        {$$ = $1;}
|   function_statement                            {$$ = $1;}
;

arithmetic_expressions:
    TK_INT
|   TK_DOUBLE
|   '+' general_expression                         {$$ = template("+%s", $2);}
|   '-' general_expression                         {$$ = template("-%s", $2);}
|   general_expression '-' general_expression      {$$ = template("%s - %s", $1, $3);}
|   general_expression '+' general_expression      {$$ = template("%s + %s", $1, $3);}
|   general_expression '*' general_expression      {$$ = template("%s * %s", $1, $3);}
|   general_expression '/' general_expression      {$$ = template("%s / %s", $1, $3);}
|   general_expression '%' general_expression      {$$ = template("%s %% %s", $1, $3);}
|   general_expression FN_POW general_expression   {$$ = template("pow(%s, %s)", $1, $3);}
;

relational_expressions:
    general_expression RP_EQUAL general_expression         {$$ = template("%s == %s", $1, $3);}
|   general_expression RP_NOT_EQUAL general_expression     {$$ = template("%s != %s", $1, $3);}
|   general_expression RP_LESS_EQUAL general_expression    {$$ = template("%s <= %s", $1, $3);}
|   general_expression RP_GREARER_EQUAL general_expression {$$ = template("%s >= %s", $1, $3);}
|   general_expression RP_LESS general_expression          {$$ = template("%s < %s", $1, $3);}
|   general_expression RP_GREATER general_expression       {$$ = template("%s > %s", $1, $3);}
;

assigning_expressions:
    identifier_expressions ASSIGN general_expression    {$$ = template("%s = %s", $1, $3);}
|   identifier_expressions SELF_ADD general_expression  {$$ = template("%s += %s", $1, $3);}
|   identifier_expressions SELF_SUB general_expression  {$$ = template("%s -= %s" , $1, $3);}
|   identifier_expressions SELF_MULT general_expression {$$ = template("%s *= %s", $1, $3);}
|   identifier_expressions SELF_DIV general_expression  {$$ = template("%s /= %s", $1, $3);}
|   identifier_expressions SELF_MOD general_expression  {$$ = template("%s %= %s", $1, $3);};
;

identifier_expressions:
    TK_ID
|   TK_ID '[' TK_ID ']' { $$ = template("%s[%s]", $1, $3); }
;



/* -------------------------------------------- Statements ---------------------------------------------*/
general_statements:
    assign_statement
|   if_statement
|   for_loop_statement
|   while_statement
|   break_statement
|   continue_statement
|   return_statement
|   function_statement
|   empty_statement
;

assign_statement:
    assigning_expressions ';' {$$ = template("%s;", $1);}
;

if_statement:
    KW_IF '(' general_expression ')' ':' general_statements KW_ENDIF ';'                                {$$ = template("if (%s) {\n\t\t%s\n\t}", $3, $6);}
|   KW_IF '(' general_expression ')' ':' general_statements KW_ELSE ':' general_statements KW_ENDIF ';' {$$ = template("if (%s) {\n\t\t%s\n\t} else {\n\t\t%s\n\t}", $3, $6, $9);}
;

for_loop_statement:
    KW_FOR TK_ID KW_IN '[' arithmetic_expressions ':' arithmetic_expressions ']' ':' general_statements KW_ENDFOR ';'                            {$$ = template("for (int %s = %s; %s < %s; %s++) {\n\t\t%s\n\t}", $2, $5, $2, $7, $2, $10);}
|   KW_FOR TK_ID KW_IN '[' arithmetic_expressions ':' arithmetic_expressions ':' arithmetic_expressions ']' ':' general_statements KW_ENDFOR ';' {$$ = template("for (int %s = %s; %s < %s; %s = %s + %s) {\n\t\t%s\n\t}", $2, $5, $2, $7, $2, $2, $9, $12);}
;

while_statement:
    KW_WHILE '(' general_expression ')' ':' general_statements KW_ENDWHILE ';' {$$ = template("while (%s) {\n\t\t%s\n\t}", $3, $6);}
;

break_statement:
    KW_BREAK ';' {$$ = template("break;");}
;

continue_statement:
    KW_CONTINUE ';' {$$ = template("continue;");}
;

return_statement:
    KW_RETURN ';'                    {$$ = template("return;");}
|   KW_RETURN general_expression ';' {$$ = template("return %s;", $2);}
;

function_statement:
    TK_ID '(' ')' ';' {$$ = template("%s();", $1);}
|   TK_ID '(' function_arguments ')' ';' {$$ = template("%s(%s);", $1, $3);}
;

empty_statement:
    ';' {$$ = ";";}
;




%%
int main() {
    if(!yyparse()) {
        printf("\x1b[32m""Accepted!\n""\x1b[0m"); 
        return -1;
    }
    printf("\x1b[31m""Rejected!\n""\x1b[0m");
}

char *fix_multiple_char_stars(char *id, char* type, int global){
    
    if(global){
        if(!strcmp(type, "char *"))
            return template("char %s;", apply_char_star(id));

        return template("%s %s;", type, id);
    }
    
    if(!strcmp(type, "char *"))
        return template("\tchar %s;", apply_char_star(id));

    return template("\t%s %s;", type, id);
}

char *apply_char_star(const char* var_list) {
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