/* lexer file */

/* Below code is copied to lex.yy.c directly */
%top{
    int lineCount = 0;
}


/*definitions*/
DIGIT [a-zA-Z]


/*rules*/
%%

{DIGIT} {printf("%d", yyleng);}

%%
// int main(){
//     yylex();
// }