%{
    // #include <stdio.h>
    #include<iostream>
    // #include<map>
    // #include<string>
    // #include<vector>
    using namespace std;
    int yylex(void);
    void yyerror(char *);
%}
%union {
    int iValue;        /* integer value */
    float fValue;        /* float value */
    char cValue;       /* character value */
    char* sValue;
    int sIndex;       /* symbol table index, this is very likly to be changed*/
};
%token  INTEGER
%token  FLOAT
%token  CHAR
%token  STRING
%token  SEMICOLON
%token <iValue> INT_VALUE
%token <fValue> FLOAT_VALUE
%token <cValue> CHAR_VALUE
%token <sIndex> IDENTIFIER
%token <sValue> STRING_VALUE
%type <iValue> int_expr
%type <fValue> float_expr
%%
program:
        program statement '\n'       
        | 
        ;
statement:
    int_expr { printf("%d\n", $1); }
    | float_expr
    | int_dclr_stmt
    | float_dclr_stmt
    | char_dclr_stmt
    | string_dclr_stmt
    ;
int_dclr_stmt:
    INTEGER IDENTIFIER SEMICOLON           {  printf("%d\n", $2);  }        
    | INTEGER IDENTIFIER '=' int_expr SEMICOLON
    ;
float_dclr_stmt:
    FLOAT IDENTIFIER ;
    | FLOAT IDENTIFIER '=' float_expr SEMICOLON
    ;  
char_dclr_stmt:
    CHAR IDENTIFIER ;
    | CHAR IDENTIFIER '=' CHAR_VALUE SEMICOLON  
    ;  
string_dclr_stmt:
    STRING IDENTIFIER ;
    | STRING IDENTIFIER '=' STRING_VALUE SEMICOLON
    ; 
int_expr:
        INT_VALUE                         { $$ = $1;      }
        | int_expr '+' int_expr           { $$ = $1 + $3; }
        | int_expr '-' int_expr           { $$ = $1 - $3; }
        ;
float_expr: 
        FLOAT_VALUE                         { $$ = $1;      }

        | float_expr '+' float_expr         { $$ = $1 + $3; }
        | float_expr '-' float_expr         { $$ = $1 - $3; }

        | int_expr '+' float_expr           { $$ = $1 + $3; }
        | int_expr '-' float_expr           { $$ = $1 - $3; }

        | float_expr '-' int_expr           { $$ = $1 - $3; }
        | float_expr '+' int_expr           { $$ = $1 + $3; }
        ;
%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}
int main(void) {
    yyparse();
    return 0;
}