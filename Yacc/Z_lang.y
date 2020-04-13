%{
    #include <stdio.h>
        #include <stdlib.h>
        #include <stdarg.h>
        #include "header.h"
        /* prototypes */
        nodeType *opr(int oper, int nops, ...);     /* nodes holds operator*/
        nodeType *id(int i);        /* nodes holds constant*/
        nodeType *con(int value); /* nodes holds constant*/
        void freeNode(nodeType *p);
        int ex(nodeType *p);
    int yylex(void);
    void yyerror(char *);

    int sym[26];   /* Symbol table allows  for  single-character  variable  names */
%}

%start program /*start symbol*/

/* this like saying both have same type*/
%union {
    int iValue;        /* integer value */
    int fValue;        /* float value */
    char cValue;       /* character value */
    bool bValue;       /* boolean value */
    char sIndex;       /* symbol table index, this is very likly to be changed*/
    nodeType *nPtr;    /* node pointer */
};

%token <iValue> INTEGER
%token <fValue> FLOAT
%token <cValue> CHAR
%token <bValue> BOOL
%token <sIndex> VARIABLE

%token WHILE DO FOR SWICH CASE DEFAULT IF PRINT 
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%left AND OR XOR
%nonassoc UMINUS NOT

/* "If precedences are equal, then associativity is used. Left associative implies reduce; right associative implies shift; nonassociating implies error" or let's say less precedence. */
%nonassoc REDUCE

/* for non-terminal */
%type <nPtr> stmt expr stmt_list dclr_stmt
%%

/*default action $$ = $1 */
program:
        block                { exit(0); }
        ;

block:
          block stmt         { ex($2); freeNode($2); }
        |
        ;
        
stmt:
          ';'                               { $$ = opr(';', 2, NULL, NULL); }
        | expr ';'                          { $$ = $1; }
        | PRINT expr ';'                    { $$ = opr(PRINT, 1, $2); }
        | dclr_stmt
        | VARIABLE '=' expr ';' %prec REDUCE{ $$ = opr('=', 2, set_id($1), $3); }
        | WHILE '(' expr ')' stmt           { $$ = opr(WHILE, 2, $3, $5); }
        | DO stmt WHILE '(' expr ')'';'     { $$ = opr(DO, 2, $2, $5); }
        | FOR '(' expr ';' expr ';' expr ')' stmt
        | SWICH CASE DEFAULT

        | IF '(' expr ')' stmt %prec IFX    { $$ = opr(IF, 2, $3, $5); }
        | IF '(' expr ')' stmt ELSE stmt    { $$ = opr(IF, 3, $3, $5, $7); }
        | '{' stmt_list '}'                 { $$ = $2; }
        ;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;

dclr_stmt: /*** should allocate nodes for variables here ****/
          TYPE VARIABLE;                { $$ = id($4); }   /* %prec REDUCE */
        | TYPE VARIABLE '=' expr ';'    { $$ = id($4); }  
        ;

TYPE:
         INTEGER | FLOAT | CHAR| BOOL ;
        
expr:
          INTEGER               { $$ = con($1); } /* should add type here i think*/
        | FLOAT                 { $$ = con($1); }
        | CHAR                  { $$ = con($1); }
        | BOOL                  { $$ = con($1); }
        | VARIABLE              { $$ = get_id($1); } /* should get value here; get_id not implemented yet */
        | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2); }
        | expr '+' expr         { $$ = opr('+', 2, $1, $3); }
        | expr '-' expr         { $$ = opr('-', 2, $1, $3); }
        | expr '*' expr         { $$ = opr('*', 2, $1, $3); }
        | expr '/' expr         { $$ = opr('/', 2, $1, $3); }
        | expr '<' expr         { $$ = opr('<', 2, $1, $3); }
        | expr '>' expr         { $$ = opr('>', 2, $1, $3); }
        | expr GE expr          { $$ = opr(GE, 2, $1, $3); }
        | expr LE expr          { $$ = opr(LE, 2, $1, $3); }
        | expr NE expr          { $$ = opr(NE, 2, $1, $3); }
        | expr EQ expr          { $$ = opr(EQ, 2, $1, $3); }
        | NOT expr              { $$ = opr(NOT, 1, $2); }
        | expr OR expr          { $$ = opr(OR, 2, $1, $3); }
        | expr AND expr         { $$ = opr(AND, 2, $1, $3); }   
        | expr XOR expr         { $$ = opr(XOR, 2, $1, $3); }
        | '(' expr ')'          { $$ = $2; }
        ;
        
%%

/* symbol table implementation */

nodeType *con(int value) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.value = value;

    return p;
}

nodeType *id(int i) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

    return p;
}

void get_id(int i) {
    nodeType *p;

    /* retrieve node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

    return p;
}

void set_id(int i) {
    nodeType *p;

    /* retrieve node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

    return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;

    /* allocate node, extending op array */
    if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}

/* add any functions here that should be executed corresponding to rule*/

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
