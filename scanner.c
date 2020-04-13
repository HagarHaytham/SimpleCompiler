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
    printf("%d\n", ntoken);
    ntoken == yylex();
    printf("%d\n", yylex());
    //printf("%s\n",ntoken);
    //ntoken == yylex();
    //printf("%s\n",yytext);
    while (ntoken)
    {
        printf("%d\n", ntoken);
        printf("%d\n", yytext);
        ntoken = yylex();
    }
    return 0;


}