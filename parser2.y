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
%type <fValue> expr
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
    | assign_stmt
    | char_assign_stmt
    | string_assign_stmt
    ;
int_dclr_stmt:

    INTEGER IDENTIFIER SEMICOLON                    {   
                                                        int res=create_int($2,0,0,0); 
                                                      if(res == 0)
                                                      yyerror("IDENTIFIER ALREADY EXISTS");
                                                      
                                                    }           
    | INTEGER IDENTIFIER EQUAL expr SEMICOLON    { 
                                                      int res=create_int($2,1,$4,1); 
                                                      
                                                      if(res == 0)
                                                      yyerror("IDENTIFIER ALREADY EXISTS");
                                                     }
    ;
float_dclr_stmt:
     FLOAT IDENTIFIER SEMICOLON                    {
                                                     
                                                    float res = create_float($2,0,0,0);
                                                    if (res == 0)
                                                        yyerror("IDENTIFIER ALREADY EXISTS");
                                                    }
    | FLOAT IDENTIFIER EQUAL expr SEMICOLON   {  
                                                    int res = create_float($2,1,$4,1);
                                                    if (res == 0)
                                
                                                        yyerror("IDENTIFIER ALREADY EXISTS");}
    
    ;
char_dclr_stmt:
     CHAR IDENTIFIER SEMICOLON                     { 
                                                        int res =create_char($2,0,'0');
                                                        if (res == 0)
                                                        yyerror("IDENTIFIER ALREADY EXISTS");}
    | CHAR IDENTIFIER EQUAL CHAR_VALUE SEMICOLON    { 
                                                        
                                                        int res = create_char($2,1,$4);
                                                        if (res == 0)
                                                        yyerror("IDENTIFIER ALREADY EXISTS");}
    ;
string_dclr_stmt:
     STRING IDENTIFIER SEMICOLON                       {
                                                        int res =create_string($2,0,"0");
                                                        if (res == 0)
                                                        yyerror("IDENTIFIER ALREADY EXISTS");}
    | STRING IDENTIFIER EQUAL STRING_VALUE SEMICOLON    { int res = create_string($2,1,$4);
                                                        if (res == 0)
                                                        yyerror("IDENTIFIER ALREADY EXISTS");}

    ;
assign_stmt:
     IDENTIFIER EQUAL expr SEMICOLON               { 
                                                         
                                                        int msg=assign_value($1,$3); 
                                                        if(msg == -1)
                                                            yyerror("UNKNOWN IDENTIFIER");
                                                        else if(msg == -2)
                                                            yyerror("TYPE NOT SUPPORTED");
                                                       }
    ;

char_assign_stmt:
     IDENTIFIER EQUAL CHAR_VALUE SEMICOLON             {
                                                        
                                                        int res = assign_char($1,$3);  
                                                        if (res == 0)
                                                        yyerror("UNDECLARED IDENTIFIER");
							if(res == 2)
							yyerror("TYPE MISMATCH");}
    ;
string_assign_stmt:
     IDENTIFIER EQUAL STRING_VALUE SEMICOLON           {
                                                        
                                                        int res = assign_string($1,$3); 
                                                        if (res == 0)
                                                        yyerror("UNDECLARED IDENTIFIER");
                                                        if(res == 2)
                                                        yyerror("TYPE MISMATCH");}
    
    ;
expr:
    INT_VALUE                        { $$ = $1;      }
    |  FLOAT_VALUE                   { $$ = $1;      }
    |  IDENTIFIER                    { print_operation("MOV");
                                      int x = 0; 
                                      float val = get_value($1,x);
                                      if(x == -1)
                                      yyerror("INVALID EXPRESSION");
                                      else
                                      $$ = val;
                                    }
    | expr PLUS expr    {
                                    print_operation("ADD");
                                    $$ = $1 + $3 ;
                                   }
    | expr MINUS expr               { 
                                    print_operation("SUB");
                                    $$ = $1 - $3 ;
                                   }
    ;
        


%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n",s);
    //removing the quadruples file in case of a syntax error.
    //reMOV("./quad.txt");
    
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
int main(int argc, char** argv) {
    //remove("./quad.txt");
    extern FILE *yyin;
    extern FILE *yyout;
    prep_file(argv[1]);
    //preprocessing for the file.
    FILE * FP = fopen("./tmp.txt","r");
    yyin = FP;
    yyparse();
    fclose(FP);
	print_table();
    remove("./tmp.txt");
    return 0;
}
