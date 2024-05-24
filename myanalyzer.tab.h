/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_MYANALYZER_TAB_H_INCLUDED
# define YY_YY_MYANALYZER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    KW_INTEGER = 258,              /* KW_INTEGER  */
    KW_SCALAR = 259,               /* KW_SCALAR  */
    KW_STR = 260,                  /* KW_STR  */
    KW_BOOL = 261,                 /* KW_BOOL  */
    KW_TRUE = 262,                 /* KW_TRUE  */
    KW_FALSE = 263,                /* KW_FALSE  */
    KW_CONST = 264,                /* KW_CONST  */
    KW_IF = 265,                   /* KW_IF  */
    KW_ELSE = 266,                 /* KW_ELSE  */
    KW_ENDIF = 267,                /* KW_ENDIF  */
    KW_FOR = 268,                  /* KW_FOR  */
    KW_IN = 269,                   /* KW_IN  */
    KW_ENDFOR = 270,               /* KW_ENDFOR  */
    KW_WHILE = 271,                /* KW_WHILE  */
    KW_ENDWHILE = 272,             /* KW_ENDWHILE  */
    KW_BREAK = 273,                /* KW_BREAK  */
    KW_CONTINUE = 274,             /* KW_CONTINUE  */
    KW_NOT = 275,                  /* KW_NOT  */
    KW_AND = 276,                  /* KW_AND  */
    KW_OR = 277,                   /* KW_OR  */
    KW_DEF = 278,                  /* KW_DEF  */
    KW_ENDDEF = 279,               /* KW_ENDDEF  */
    KW_BEGIN = 280,                /* KW_BEGIN  */
    KW_RETURN = 281,               /* KW_RETURN  */
    KW_COMP = 282,                 /* KW_COMP  */
    KW_ENDCOMP = 283,              /* KW_ENDCOMP  */
    KW_OF = 284,                   /* KW_OF  */
    TK_ID = 285,                   /* TK_ID  */
    TK_INT = 286,                  /* TK_INT  */
    TK_DOUBLE = 287,               /* TK_DOUBLE  */
    TK_STRING = 288,               /* TK_STRING  */
    ASSIGN = 289,                  /* ASSIGN  */
    SELF_ADD = 290,                /* SELF_ADD  */
    SELF_SUB = 291,                /* SELF_SUB  */
    SELF_MULT = 292,               /* SELF_MULT  */
    SELF_DIV = 293,                /* SELF_DIV  */
    SELF_MOD = 294,                /* SELF_MOD  */
    SELF_CLN_ASSIGN = 295,         /* SELF_CLN_ASSIGN  */
    RP_EQUAL = 296,                /* RP_EQUAL  */
    RP_NOT_EQUAL = 297,            /* RP_NOT_EQUAL  */
    RP_LESS = 298,                 /* RP_LESS  */
    RP_LESS_EQUAL = 299,           /* RP_LESS_EQUAL  */
    RP_GREATER = 300,              /* RP_GREATER  */
    RP_GREARER_EQUAL = 301,        /* RP_GREARER_EQUAL  */
    FN_POW = 302,                  /* FN_POW  */
    FN_RETURN = 303                /* FN_RETURN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 15 "myanalyzer.y"

    char *string;

#line 116 "myanalyzer.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_MYANALYZER_TAB_H_INCLUDED  */
