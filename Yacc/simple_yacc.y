%{
    
    #include<stdarg.h>
    #include<iostream>
    using namespace std;
    int yylex(void);
    void yyerror(char *);

    // template <typename T>
    // void set_id (std::string type, T id) { 
       
    //      data new_id;
    //     new_id.type = type;
    //     new_id.assigned = false;
    //     //m[id] = new_id;    
    // }
    // void assign_id (std::string type, T id,T expr) {
    //     //should do something here to indicate type mismatch.
    //     data new_id;
    //     new_id.type = type;
    //     new_id.assigned = false;   
    //     switch (type)
    //     {
    //         case "int":
    //             new_id.int_value = expr;
    //             break;
    //         case "float":
    //             new_id.float_value = expr;
    //             break;
    //         case "std::string":
    //             new_id.std::string_value = expr;
    //             break;
    //         case "char":
    //             new_id.char_value = expr;
    //             break;
    //     }
    //     //m[id] = new_id;
    // }
    // T get_id (T a, T b) { 
        
    // }
    // struct data
    // {
    //     std::string std::string_value;
    //     int int_value;
    //     float float_value;
    //     char char_value;
    //     bool assigned;  
    // }
%}


%start program 

/* this like saying both have same type*/
%union {
    int iValue;        /* integer value */
    float fValue;        /* float value */
    char cValue;       /* character value */
    char* sValue;
    int sIndex;       /* symbol table index, this is very likly to be changed*/

};

%token <iValue> INTEGER
%token <fValue> FLOAT
%token <cValue> CHAR
%token <sIndex> IDENTIFIER
%token <sValue> STRING
%token WHILE DO FOR SWICH CASE DEFAULT IF PRINT 
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
/*   to be reviewed  */
%left AND OR XOR
%nonassoc UMINUS NOT

/* "If precedences are equal, then associativity is used. Left associative implies reduce; right associative implies shift; nonassociating implies error" or let's say less precedence. */
%nonassoc REDUCE

/*
bison -d -o simple_yacc.cpp simple_yacc.y
lex -o scanner.cpp scanner.l
g++ -o myparser scanner.cpp simple_yacc.cpp -lfl
*/
%%
program:
    program statement '\n'      { exit(0);}
    |;
statement:
    expr { printf("%d\n", $1); }
    | dclr_stmt
    ;
TYPE:
      INTEGER               { $$ = $1; }
    | FLOAT                 { $$ = $1; }
    | CHAR                  { $$ = $1; }
    | STRING                { $$ = $1; }
    ;
dclr_stmt: /*** should allocate nodes for variables here ****/
          TYPE IDENTIFIER ';'             { /**s_table.set_id($1,$2);**/ cout<<$1<<$2<<endl;  }
        | TYPE IDENTIFIER '=' expr ';'    { 
                                            cout<<$1<<$2<<$4<<endl;
                                            /**
                                            if(typeid(TYPE).name() == typeid(expr).name())
                                            s_table.set_id($1,$2,$4);
                                            else
                                            yyerror("type mismatch");
                                            **/
                                            }  
        ;
expr:
      INTEGER               { $$ = $1; }
    | FLOAT                 { $$ = $1; }
    | CHAR                  { $$ = $1; }
    | STRING                { $$ = $1; }
    | IDENTIFIER              { cout<<$1<<endl; }
    | expr '+' expr         { $$ = $1 + $3; } 
    | expr '-' expr         { $$ = $1 - $3; }
    | expr '*' expr         { $$ = $1 * $3; }
    | expr '/' expr         { $$ = $1 / $3; }
    | '(' expr ')'          { $$ = $2; } 
    ;
%%
void yyerror(char* s) {
cout<<s;
return 0;
}
int main(void) {
    yyparse();
    return 0;
}

