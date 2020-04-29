%{
    
    #include <stdio.h>
    #include "symbol_table.h"
    int yylex(void);
    void yyerror(char *);
    void prep_file(char * file_name);
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

    INTEGER IDENTIFIER SEMICOLON                    {   
                                                        int res=create_int($2,0,0,0); 
                                                      if(res == 0)
                                                      yyerror("Identifier already exists");
                                                      print_table();
                                                    }           
    | INTEGER IDENTIFIER EQUAL int_expr SEMICOLON   { 
                                                        int res=create_int($2,1,$4,0);
                                                      if(res == 0)
                                                      yyerror("Identifier already exists");
                                                      print_table();
                                                     }
    | INTEGER IDENTIFIER EQUAL id_expr SEMICOLON    { 
                                                      int res=create_int($2,1,$4,1); 
                                                      print_table();
                                                      if(res == 0)
                                                      yyerror("Identifier already exists");
                                                     }
    ;
float_dclr_stmt:
     FLOAT IDENTIFIER SEMICOLON                    {
                                                     
                                                    float res = create_float($2,0,0,0);
                                                    if (res == 0)
                                                        yyerror("Identifier already exists");
                                                    }
    | FLOAT IDENTIFIER EQUAL float_expr SEMICOLON   {
                                                    int res = create_float($2,1,$4,0);
                                                    if (res == 0)
                                                        yyerror("Identifier already exists");}
    | FLOAT IDENTIFIER EQUAL id_expr SEMICOLON   {  
                                                    int res = create_float($2,1,$4,1);
                                                    if (res == 0)
                                
                                                        yyerror("Identifier already exists");}
    
    ;
char_dclr_stmt:
     CHAR IDENTIFIER SEMICOLON                     { 
                                                        int res =create_char($2,0,'0');
                                                        if (res == 0)
                                                        yyerror("Identifier already exists");}
    | CHAR IDENTIFIER EQUAL CHAR_VALUE SEMICOLON    { 
                                                        
                                                        int res = create_char($2,1,$4);
                                                        if (res == 0)
                                                        yyerror("Identifier already exists");}
    ;
string_dclr_stmt:
     STRING IDENTIFIER SEMICOLON                       {
                                                        int res =create_string($2,0,"0");
                                                        if (res == 0)
                                                        yyerror("Identifier already exists");}
    | STRING IDENTIFIER EQUAL STRING_VALUE SEMICOLON    { int res = create_string($2,1,$4);
                                                        if (res == 0)
                                                        yyerror("Identifier already exists");}

    ;
int_assign_stmt:
     IDENTIFIER EQUAL int_expr SEMICOLON               {
                                                         
                                                        int res = assign_int($1,$3); 
                                                        if (res == 0)
                                                        yyerror("Undeclared identifier");}
    ;
float_assign_stmt:
     IDENTIFIER EQUAL float_expr SEMICOLON             {
                                                         int res = assign_float($1,$3);
                                                        if (res == 0)
                                                        yyerror("Undeclared identifier"); }
    ;
char_assign_stmt:
     IDENTIFIER EQUAL CHAR_VALUE SEMICOLON             {
                                                        
                                                        int res = assign_char($1,$3);  
                                                        if (res == 0)
                                                        yyerror("Undeclared identifier");}
    ;
string_assign_stmt:
     IDENTIFIER EQUAL STRING_VALUE SEMICOLON           {
                                                        
                                                        int res = assign_string($1,$3); 
                                                        if (res == 0)
                                                        yyerror("Undeclared identifier");}
    
    ;
id_assign_stmt:
     IDENTIFIER EQUAL id_expr SEMICOLON                { 
                                                         
                                                        int msg=assign_value($1,$3); 
    ;                                                     if(msg == -1)
                                                            yyerror("UNKNOWN IDENTIFIER");
                                                        else if(msg == -2)
                                                            yyerror("TYPE NOT SUPPORTED");
                                                       }
id_expr:
      IDENTIFIER                    { print_operation("MOVE");
                                      int x = 0; 
                                      float val = get_value($1,x);
                                      if(x == -1)
                                      yyerror("INVALID EXPRESSION");
                                      else
                                      $$ = val;
                                    }
    | IDENTIFIER PLUS IDENTIFIER    {
                                    print_operation("ADD");
                                    int x = 0;
                                    int y = 0;
                                    float val1 = get_value($1,x);
                                    float val2 = get_value($3,y);
                                    if(x != -1 && y != -1)
                                        $$ = val1 + val2 ;
                                    else
                                        yyerror("INVALID EXPRESSION");
                                   }
    | IDENTIFIER MINUS IDENTIFIER { print_operation("SUB");
                                    int x = 0;
                                    int y = 0;
                                    float val1 = get_value($1,x);
                                    float val2 = get_value($3,y);
                                    if(x != -1 && y != -1)
                                        $$ = val1 - val2 ;
                                    else
                                        yyerror("INVALID EXPRESSION");
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
    //removing the quadruples file in case of a syntax error.
    //remove("./quad.txt");
    exit(0);
}
void prep_file(char* file_name)
{
    FILE * FP = fopen(file_name,"r");
    FILE * TMP = fopen("tmp.txt","w");
    char c;
	int count = 0;
	while((c = fgetc(FP)) != EOF)
	{
		if(c == ' ' || c == '\n')
		{
			fprintf(TMP,"\n");
			++count;
		}
		else
		{
			fprintf(TMP,"%c", c);
		}
	}
	fclose(FP);
    fclose(TMP);
}
int main(void) {
    //remove("./quad.txt");
    extern FILE *yyin;
    extern FILE *yyout;
    prep_file("./test3.txt");
    FILE * FP = fopen("./tmp.txt","r");
    yyin = FP;
    yyparse();
    fclose(FP);
    remove("./tmp.txt");
    return 0;
}