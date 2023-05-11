%{
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
#include "parser_push.h"

struct hash* symbols;
int _have_err = 0;

void yyerror(YYLTYPE* loc, const char* err);

extern int yylex();
extern yypstate* pstate;
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

%define api.push-pull push
%define api.pure full

%locations
%define parse.error verbose

%%

program
    : program statement
    | statement
    ;

statement
    : IDENTIFIER EQUALS expression SEMICOLON {
        // printf("== assignment statement IDENTIFIER at line %d\n", @1.first_line);
        hash_insert(symbols, $1, $3);
        free($1);
    }
    | error SEMICOLON
    ;

expression
    : IDENTIFIER {
        if (hash_contains(symbols, $1)) {
            $$ = hash_get(symbols, $1);
        } else {
            fprintf(stderr, "Error: unknown symbol (%s) on line %d\n",
                $1, @1.first_line);
            _have_err = 1;
            YYERROR;
        }
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

void yyerror(YYLTYPE* loc, const char* err) {
    _have_err = 1;
    fprintf(stderr, "Error (line %d): %s\n", loc->first_line, err);
}

int main() {
    symbols = hash_create();
    pstate = yypstate_new();
    if (!yylex() && !_have_err) {
        printf("Symbol values:\n");
        struct hash_iter* iter = hash_iter_create(symbols);
        while (hash_iter_has_next(iter)) {
            char* id;
            float val = hash_iter_next(iter, &id);
            printf("  -- %s = %f\n", id, val);
        }
    }
}
