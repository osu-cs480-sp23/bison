%{
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"

struct hash* hash = hash_create();

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
    : IDENTIFIER EQUALS expression SEMICOLON
    ;

expression
    : IDENTIFIER
    | NUMBER { $$ = $1; }
    | LPAREN expression RPAREN { $$ = $2; }
    | expression PLUS expression { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression TIMES expression { $$ = $1 * $3; }
    | expression DIVIDEDBY expression { $$ = $1 / $3; }
    ;

%%
