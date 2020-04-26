%{
    #include<map>
    #include<stdarg.h>
    #include<vector>
    #include "header.h"
    using namespace std;
    int yylex(void);
    void yyerror(char *);
    template <typename T>
    map<string,data> symbol_table;
    void set_id (string type, T id) { 
        if(m[id] != NULL)
        {
            // should do something here to show an error!
        }
        data new_id;
        new_id.type = type;
        new_id.assigned = false;
        m[id] = new_id;    
    }
    void assign_id (string type, T id,T expr) {
        //should do something here to indicate type mismatch.
        data new_id;
        new_id.type = type;
        new_id.assigned = false;   
        switch (type)
        {
            case "int":
                new_id.int_value = expr;
                break;
            case "float":
                new_id.float_value = expr;
                break;
            case "string":
                new_id.string_value = expr;
                break;
            case "char":
                new_id.char_value = expr;
                break;
        }
        m[id] = new_id;
    }
    T get_id (T a, T b) { 
        
    }
    struct data
    {
        string string_value;
        int int_value;
        float float_value;
        char char_value;
        bool assigned;  
    }
%}


%start program 

/* this like saying both have same type*/
%union {
    int iValue;        /* integer value */
    float fValue;        /* float value */
    char cValue;       /* character value */
    string sValue;
    string sIndex;       /* symbol table index, this is very likly to be changed*/

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
%type <nPtr> statement expr dclr_stmt TYPE

%%
program:
    program statement '\n'
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
          TYPE IDENTIFIER ';'             { s_table.set_id($1,$2);  }
        | TYPE IDENTIFIER '=' expr ';'    { 
                                            if(typeid(TYPE).name() == typeid(expr).name())
                                            s_table.set_id($1,$2,$4);
                                            else
                                            yyerror('type mismatch');
                                            }  
        ;
expr:
    TYPE
    | IDENTIFIER              { $$ = s_table.get_id($1); }
    | expr '+' expr         { $$ = $1 + $3; } 
    | expr '-' expr         { $$ = $1 - $3; }
    | expr '*' expr         { $$ = $1 * $3; }
    | expr '/' expr         { $$ = $1 / $3; }
    | '(' expr ')'          { $$ = $2; } 
    ;
%%
void yyerror(char *s) {
fprintf(stderr, "%s\n", s);
return 0;
}
int main(void) {
    yyparse();
    return 0;
}

