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
%type <iValue> INT_EXPR
%type <fValue> FLOAT_EXPR
%type <cValue> CHAR_EXPR
%type <sValue> STRING_EXPR
%type <iValue> VALUE
%nonassoc REDUCE
%%
program:
    program statement
    | 
    ;
statement:
    DCLR
    | ASSIGN
    ;
VALUE:
    INT_VALUE
    | FLOAT_VALUE
    | CHAR_VALUE
    | STRING_VALUE
    ;
TYPE:
    INTEGER
    | CHAR
    | FLOAT
    | STRING 
    ;
DCLR:
    TYPE IDENTIFIER SEMICOLON  
    | TYPE IDENTIFIER EQUAL INT_EXPR SEMICOLON
    | TYPE IDENTIFIER EQUAL FLOAT_EXPR SEMICOLON
    | TYPE IDENTIFIER EQUAL CHAR_EXPR SEMICOLON
    | TYPE IDENTIFIER EQUAL STRING_EXPR SEMICOLON
    ;
ASSIGN:
    IDENTIFIER EQUAL INT_EXPR SEMICOLON
    ;
INT_EXPR:
    VALUE PLUS VALUE
    | IDENTIFIER PLUS IDENTIFIER
    | INT_EXPR MINUS INT_EXPR
    ;
FLOAT_EXPR:
    VALUE               
    | FLOAT_EXPR PLUS FLOAT_EXPR
    | FLOAT_EXPR MINUS FLOAT_EXPR
    ;
CHAR_EXPR:
    VALUE               
    | CHAR_EXPR PLUS CHAR_EXPR
    | CHAR_EXPR MINUS CHAR_EXPR
    ;
STRING_EXPR:
    VALUE               
    | STRING_EXPR PLUS STRING_EXPR
    | STRING_EXPR MINUS STRING_EXPR
    ;
%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", "INVAL");
}
int main(void) {
    yyparse();
    return 0;
}