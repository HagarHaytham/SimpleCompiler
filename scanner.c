#include <stdio.h>
#include "scanner.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

//char * names [] ={NULL,"type"};
// 1-handle comments in lexer
//2- string needs to be adjuted
int main(void)
{
    int ntoken;
    printf("%s\n", "HELLO");
    ntoken == yylex();
    printf("%s\n",yytext);
    while (ntoken)
    {
        printf("%d\n", ntoken);
        ntoken = yylex();
    }
    return 0;


}