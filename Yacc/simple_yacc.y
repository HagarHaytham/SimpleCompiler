%{
    #include<map>
    #include<stdarg.h>
    #include<vector>
    #include "header.h"
    using namespace std;
    int yylex(void);
    void yyerror(char *);
    struct data
    {
        int int_value;
        float float_value;
        char char_value;
        string string_value;
        string type;
        bool assigned;
    }
	class symbol_table
	{
        map<string,data> symbol_table;

        public symbol_table()
        {}
        void assign_id_int(string type,string id,int value)
        {
            data new_id;
            new_id.type=type;
            new_id.assigned = true;
            if(type == INTEGER)
                new_id.int_value = value; 
            elif(type == STRING)
                new_id.string =  value;
            elif(type == FLOAT)
                new_id.float_value =  value;
            if(type == CHAR)
                new_id.char_value =  value;

            symbol_table.insert(id,new_id)
        }
        void set_id(string type,string id)
        {
            data new_id;
            new_id.id=id;
            new_id.type=type;
            new_id.assigned = false;
            symbol_table.insert(id,new_id)
        } 
        void get_id(string id)
        {
            data id = symbol_table.find(id);
            
        }
	} 
symbol_table s_table=new symbol_table();
%}


%start program /*start symbol*/

/* this like saying both have same type*/
%union {
    int iValue;        /* integer value */
    float fValue;        /* float value */
    char cValue;       /* character value */
    string sValue;
};

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

program:
    program statement '\n'
    |;
statement:
    expr { printf("%d\n", $1); }
    | dclr_stmt
    ;
dclr_stmt: /*** should allocate nodes for variables here ****/
          TYPE IDENTIFIER;                { s_table.set_id($1,$2);  }
        | TYPE IDENTIFIER '=' expr ';'    { 
                                            if(typeid(TYPE).name() == typeid(expr).name())
                                            s_table.set_id($1,$2,$4);
                                            else
                                            yyerror('type mismatch');
                                            }  
        ;
TYPE:
      INTEGER               { $$ = $1; }
    | FLOAT                 { $$ = $1; }
    | CHAR                  { $$ = $1; }
    | BOOL                  { $$ = $1; }
expr:
    TYPE
    | VARIABLE              { $$ = s_table.get_id($1); }
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

