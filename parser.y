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

%%

%%
