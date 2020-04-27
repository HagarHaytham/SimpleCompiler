%{
    #include <stdio.h>
    #include "symbol_table.h"
    int yylex(void);
    void yyerror(char *);
%}
%start program
%union {
    int iValue;        /* integer value */
    float fValue;        /* float value */
    char cValue;       /* character value */
    char* sValue;
};
%left '+' '-'
%left '*' '/'
%token  INTEGER
%token  FLOAT
%token  CHAR
%token  STRING
%token  SEMICOLON
%token EQUAL
%token PLUS
%token MINUS
%token <iValue> INT_VALUE
%token <fValue> FLOAT_VALUE
%token <cValue> CHAR_VALUE
%token <sValue> IDENTIFIER
%token <sValue> STRING_VALUE
%type <iValue> int_expr
%type <fValue> float_expr
%nonassoc REDUCE
%%
program:
        program stmt   '\n'
        | 
        ;
stmt:  
    INTEGER IDENTIFIER SEMICOLON               { printf("%s\n", $2); create_int($2,0,0); }             
    | INTEGER IDENTIFIER EQUAL int_expr SEMICOLON  

    | FLOAT IDENTIFIER SEMICOLON
    | FLOAT IDENTIFIER EQUAL float_expr SEMICOLON

    | CHAR IDENTIFIER SEMICOLON
    | CHAR IDENTIFIER EQUAL CHAR_VALUE SEMICOLON  

    | STRING IDENTIFIER SEMICOLON
    | STRING IDENTIFIER EQUAL STRING_VALUE SEMICOLON

    | IDENTIFIER EQUAL int_expr SEMICOLON                   

    | IDENTIFIER EQUAL float_expr SEMICOLON

    | IDENTIFIER EQUAL CHAR_VALUE SEMICOLON      

    | IDENTIFIER EQUAL STRING_VALUE SEMICOLON    
    ; 

int_expr:
        INT_VALUE                           { $$ = $1;      }
        | int_expr PLUS int_expr            { $$ = $1 + $3; }
        | int_expr MINUS int_expr           { $$ = $1 - $3; }
        ;
float_expr: 
        FLOAT_VALUE                         { $$ = $1;      }
        | float_expr PLUS float_expr        { $$ = $1 + $3; }
        | float_expr MINUS float_expr       { $$ = $1 - $3; }

        | int_expr PLUS float_expr          { $$ = $1 + $3; }
        | int_expr MINUS float_expr         { $$ = $1 - $3; }

        | float_expr MINUS int_expr         { $$ = $1 - $3; }
        | float_expr PLUS int_expr          { $$ = $1 + $3; }
        ;
%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", "aaaaaa");
}
int main(void) {
    yyparse();
    return 0;
}