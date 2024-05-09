/* lexer file /

/ Below code is copied to lex.yy.c directly /
%{
    int lineCount = 1;
%}

/definitions/

ID      [a-zA-Z][0-9a-zA-Z]
DIGIT   [0-9]
NUMBER  {DIGIT}{DIGIT}*
DECIMAL ("0""."{NUMBER})|({NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
CONSSTRING "[^'\n]"
SYMBOL  [-+/:$%!#@&~^()]*


%%


%%