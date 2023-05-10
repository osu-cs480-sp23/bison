%{
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"

struct hash* symbols;

void yyerror(const char* err);

extern int yylex();
%}

%union {
    float num;
    char* str;
    int category;
}

/* %define api.value.type { char* } */

%token <str> IDENTIFIER
%token <num> NUMBER
%token <category> EQUALS PLUS MINUS TIMES DIVIDEDBY
%token <category> SEMICOLON LPAREN RPAREN

%type <num> expression

%left PLUS MINUS
%left TIMES DIVIDEDBY

%start program

%%

program
    : program statement
    | statement
    ;

statement
    : IDENTIFIER EQUALS expression SEMICOLON {
        hash_insert(symbols, $1, $3);
        free($1);
    }
    ;

expression
    : IDENTIFIER {
        $$ = hash_get(symbols, $1);
        free($1);
    }
    | NUMBER { $$ = $1; }
    | LPAREN expression RPAREN { $$ = $2; }
    | expression PLUS expression { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression TIMES expression { $$ = $1 * $3; }
    | expression DIVIDEDBY expression { $$ = $1 / $3; }
    ;

%%

void yyerror(const char* err) {
    fprintf(stderr, "Error: %s\n", err);
}

int main() {
    symbols = hash_create();
    if (!yyparse()) {
        printf("Symbol values:\n");
        struct hash_iter* iter = hash_iter_create(symbols);
        while (hash_iter_has_next(iter)) {
            char* id;
            float val = hash_iter_next(iter, &id);
            printf("  -- %s = %f\n", id, val);
        }
    }
}
