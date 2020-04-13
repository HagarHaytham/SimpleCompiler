%{
#include "scanner.h"    
%}
%option nounput yylineno

%%


(int|float|char|bool|string)    return TYPE;
[1-9][0-9]*                     return INTEGER;
[0-9]*(.[0-9]+)                 return FLOAT;
true|false                      return BOOLEAN;
'[a-zA-Z]'                      return CHAR;
"[a-zA-Z][_a-zA-Z0-9]*"         return STRING;
[a-zA-Z][_a-zA-Z0-9]*           return IDENTIFIER;
if                              return IF;
else                            return ELSE;
while                           return WHILE;
for                             return FOR;
if                              return IF;
else                            return ELSE; 
while                           return WHILE; 
do                              return DO;
for                             return FOR; 
switch                          return SWICH; 
case                            return CASE;
default                         return DEFAULT;  
print                           return PRINT;
;                               return SEMICOLON;

[ \t\n]+                        ;
.                               {printf("unexpected character\n");return OTHER;}


%%

int yywrap(void)
{
    return 1;
}