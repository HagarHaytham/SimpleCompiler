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
%type <fValue> id_expr
%nonassoc REDUCE
%%
program:    program stmt
          | stmt
          ;

stmt: 
    int_dclr_stmt
    | string_dclr_stmt
    | float_dclr_stmt
    | char_dclr_stmt
    | int_assign_stmt
    | float_assign_stmt
    | char_assign_stmt
    | string_assign_stmt
    | id_assign_stmt
    ;
int_dclr_stmt:

    INTEGER IDENTIFIER SEMICOLON                    { int res=create_int($2,0,0); 
                                                      if(res == 0)
                                                      yyerror("Identifier already exists");
                                                      print_table();
                                                    }           
    | INTEGER IDENTIFIER EQUAL int_expr SEMICOLON   { int res=create_int($2,1,$4);
                                                      if(res == 0)
                                                      yyerror("Identifier already exists");
                                                      print_table();
                                                     }
    | INTEGER IDENTIFIER EQUAL id_expr SEMICOLON    {
                                                      int res=create_int($2,1,$4); 
                                                      print_table();
                                                      if(res == 0)
                                                      yyerror("Identifier already exists");
                                                     }
    ;
float_dclr_stmt:
     FLOAT IDENTIFIER SEMICOLON                    {create_float($2,0,.0);}
    | FLOAT IDENTIFIER EQUAL float_expr SEMICOLON   {create_float($2,1,$4);}
    | FLOAT IDENTIFIER EQUAL id_expr SEMICOLON   {create_float($2,1,$4);}
    
    ;
char_dclr_stmt:
     CHAR IDENTIFIER SEMICOLON                     {create_char($2,0,'0');}
    | CHAR IDENTIFIER EQUAL CHAR_VALUE SEMICOLON    {create_char($2,1,$4);}
    | CHAR IDENTIFIER EQUAL id_VALUE SEMICOLON    {create_char($2,1,$4);}
    ;
string_dclr_stmt:
     STRING IDENTIFIER SEMICOLON                       {create_string($2,0,"0");}
    | STRING IDENTIFIER EQUAL STRING_VALUE SEMICOLON    {create_string($2,1,$4);}
    | STRING IDENTIFIER EQUAL id_VALUE SEMICOLON    {create_string($2,1,$4);}

    ;
int_assign_stmt:
     IDENTIFIER EQUAL int_expr SEMICOLON               { assign_int($1,$3); }
    ;
float_assign_stmt:
     IDENTIFIER EQUAL float_expr SEMICOLON             { assign_float($1,$3); }
    ;
char_assign_stmt:
     IDENTIFIER EQUAL CHAR_VALUE SEMICOLON             { assign_char($1,$3);  }
    ;
string_assign_stmt:
     IDENTIFIER EQUAL STRING_VALUE SEMICOLON           { assign_string($1,$3); }
    ;
id_assign_stmt:
     IDENTIFIER EQUAL id_expr SEMICOLON                { char* msg=assign_value($1,$3); 
    ;                                                     if(msg !="")
                                                          yyerror(msg);
                                                       }

id_expr:
      IDENTIFIER                    { int x = 0; 
                                      float val = get_value($1,x);
                                      if(x == -1)
                                        yyerror("ERROR evaluating expression ");
                                      else
                                      $$ = val;
                                      }
    | IDENTIFIER PLUS IDENTIFIER    {
                                    int x = 0;
                                    int y = 0;
                                     float val1 = get_value($1,x);

                                    float val2 = get_value($3,y);
                                    if(x == -1 || y == -1)
                                        $$ = val1 + val2 ;
                                    else
                                        yyerror("ERROR evaluating expression ");
                                   }
    | IDENTIFIER MINUS IDENTIFIER { 
                                    int x = 0;
                                    int y = 0;
                                    float val1 = get_value($1,x);
                                    float val2 = get_value($3,y);
                                    if(x == -1 || y == -1)
                                        $$ = val1 - val2 ;
                                    else
                                        yyerror("ERROR evaluating expression ");
                                   }
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
    fprintf(stderr, "%s\n",s);
    printf("aaaaaa");
}
int main(void) {
    yyparse();
    return 0;
}