%{
// #include "scanner.h" 
#include<stdio.h> 
#include "y.tab.h"
#include <stdlib.h>
void yyerror(char *);   
%}
%%
int                             return INTEGER;
float                           return FLOAT;
char                            return CHAR;
string                          return STRING;
[1-9][0-9]*                     {    
                                        yylval.iValue = atoi(yytext);
                                        return INT_VALUE;
                                }
[0-9]*(.[0-9]+)                 {  
                                   yylval.fValue = strtof(yytext,NULL);
                                  return FLOAT_VALUE;
                                } 
['][a-zA-Z][']                      {  
                                   strncpy(&yylval.cValue, &yytext[1], 1) ;
                                    return CHAR_VALUE;
                                } 
["][a-zA-Z0-9]*["]              {   
                                    yylval.sValue = strdup(yytext);
                                    return STRING_VALUE;
                                } 
[a-zA-Z][a-zA-Z0-9]*            {   
                                    yylval.sValue = strdup(yytext);
                                    return IDENTIFIER;
                                } 
[;]                               {return SEMICOLON;}
[=]                               {  return EQUAL;}
[+]                             { return PLUS;}
[-]                             { return MINUS;}                               
[ \n\t\r]+                       ;
.                               {printf("unexpected character");}

%%


int yywrap(void)
{
    return 1;
}
