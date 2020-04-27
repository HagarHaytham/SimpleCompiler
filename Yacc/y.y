%{
    #include <stdio.h>

    int yylex(void);
    void yyerror(char *);
%}
%start program
%union {
    int iValue;        /* integer value */
    float fValue;        /* float value */
    char cValue;       /* character value */
    char* sValue;
    int sIndex;       /* symbol table index, this is very likly to be changed*/
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
%token <sIndex> IDENTIFIER
%token <sValue> STRING_VALUE
%type <iValue> int_expr
%type <fValue> float_expr
%nonassoc REDUCE
%%
program:
        program statement
        | 
        ;
statement:
    int_expr 
    | float_expr
    | int_dclr_stmt
    | float_dclr_stmt
    | char_dclr_stmt
    | string_dclr_stmt
    | int_assign_stmt
    | float_assign_stmt
    | char_assign_stmt
    | string_assign_stmt
    ;
int_dclr_stmt:
    INTEGER IDENTIFIER SEMICOLON                   
    | INTEGER IDENTIFIER EQUAL int_expr SEMICOLON
    ;
float_dclr_stmt:
    FLOAT IDENTIFIER SEMICOLON
    | FLOAT IDENTIFIER EQUAL float_expr SEMICOLON
    ;  
char_dclr_stmt:
    CHAR IDENTIFIER SEMICOLON
    | CHAR IDENTIFIER EQUAL CHAR_VALUE SEMICOLON  
    ;  
string_dclr_stmt:
    STRING IDENTIFIER SEMICOLON
    | STRING IDENTIFIER EQUAL STRING_VALUE SEMICOLON
    ; 

int_assign_stmt:
     IDENTIFIER EQUAL int_expr SEMICOLON                   
    ;
float_assign_stmt:
    IDENTIFIER EQUAL float_expr SEMICOLON
    ;  
char_assign_stmt:
    IDENTIFIER EQUAL CHAR_VALUE SEMICOLON      
    ;  
string_assign_stmt:
    IDENTIFIER EQUAL STRING_VALUE SEMICOLON    
    ; 

int_expr:
        INT_VALUE                           { $$ = $1;   }
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