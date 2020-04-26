%{
#include "scanner.h"    
%}
%option nounput yylineno

%%

if                              return IF;
else                            return ELSE; 
while                           return WHILE; 
do                              return DO;
for                             return FOR;
switch                          return SWICH; 
case                            return CASE;
default                         return DEFAULT;  
print                           return PRINT;
int                             return INTEGER;
float                           return FLOAT;
char                            return CHAR;
string                          return STRING;

[1-9][0-9]*                     return INT_VALUE;
[0-9]*(.[0-9]+)                 return FLOAT_VALUE;
'[a-zA-Z]'                      return CHAR_VALUE;
"[a-zA-Z][_a-zA-Z0-9]*"         return STRING_VALUE;
[a-zA-Z][_a-zA-Z0-9]*           return IDENTIFIER;
;                               return SEMICOLON;

[ \t\n]+                        ;
.                               {printf("unexpected character\n");return OTHER;}


%%

int yywrap(void)
{
    return 1;
}