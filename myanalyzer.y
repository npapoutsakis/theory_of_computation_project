/* Computation Theory Project 2024  */
/*      Nikolaos Papoutsakis        */
/*           2019030206             */

%{
    #include <stdio.h>
    #include "lambdalib.h"
%}

%union{
    char * str;
}

%token KW_INTEGER

%type <str> expr


%%

expr:
    KW_INTEGER
|   '(' expr ')'
|   expr '+' expr
|   expr '-' expr
|   expr '*' expr
|   expr '/' expr
;