%{
   #include "y.tab.h"
   extern char yyval;
%}

NUMBER [0-9]+
LETTER [a-zA-Z]
WHILE (while)
IF (if)
FOR (for)
INT (int)[ ]
UNARY_p (\+\+)
UNARY_m (--)



%%
{NUMBER} {yylval.sym=(char)yytext[0]; return NUMBER;}
{LETTER} {yylval.sym=(char)yytext[0];return LETTER;}
{WHILE}  {return WHILE;}
{IF} {return IF;}
{FOR} {return FOR;}
{INT} {return INT;}
{UNARY_m} {return UNARY_m;}
{UNARY_p} {return UNARY_p;}



.  {return yytext[0];}

%%
