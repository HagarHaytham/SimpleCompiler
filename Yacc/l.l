%{
// #include "scanner.h" 
#include <stdio.h>
#include "y.tab.h"
#include <stdlib.h>
void yyerror(char *);   
%}
%%
int                             return INTEGER;
float                           return FLOAT;
char                            return CHAR;
string                          return STRING;
[1-9][0-9]*                     {       printf("NUMBER\n");
                                        yylval.iValue = atoi(yytext);
                                        return INT_VALUE;
                                }
[0-9]*(.[0-9]+)                 {  printf("NUMBER\n");
                                   yylval.fValue = strtof(yytext,NULL);
                                  return FLOAT_VALUE;
                                } 
'[a-zA-Z]'                      {  printf("CHAR_VALUE\n");
                                    yylval.cValue = yytext[0];
                                    return CHAR_VALUE;
                                } 
["][a-zA-Z0-9]*["]              {   printf(yytext);
                                    return STRING_VALUE;
                                } 
[a-zA-Z][a-zA-Z0-9]*            {   printf("IDENTIFIER\n");
                                    yylval.sValue = yytext;
                                    return IDENTIFIER;  
                                } 
;                               {  return SEMICOLON;}
=                               { printf("EQUAL\n"); return EQUAL;}
[+]                             {printf("plus\n"); return PLUS;}
[-]                             {printf("minus\n"); return MINUS;}                               
[ \t\n]+                        ;
.                               {printf("unexpected character\n");}

%%
int yywrap(void)
{
    return 1;
}