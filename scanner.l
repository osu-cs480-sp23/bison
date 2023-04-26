%{
#include <stdio.h>
#include <stdlib.h>

int num_ops = 0;
int num_nums = 0;

#define MAX_IDS 512
char* saved_ids[MAX_IDS];
int num_ids = 0;

void save_id(char*);

int have_err = 0;
%}

%option noyywrap
%option yylineno

%%

[ \t\n]*    /* Ignore whitespace. */

[a-z][0-9]? {
    save_id(yytext);
}

[0-9]+("."[0-9]+)? {
    num_nums++;
}

"="     num_ops++;
"+"     num_ops++;
"-"     num_ops++;
"*"     num_ops++;
"/"     num_ops++;

";"     /* Ignore... */
"("     /* Ignore... */
")"     /* Ignore... */

. {
    have_err = 1;
    fprintf(stderr, "Invalid symbol on line %d: %s\n", yylineno, yytext);
}

<<EOF>> {
    if (have_err) {
        return 1;
    }
    return 0;
}

%%

void save_id(char* id) {
    if (num_ids >= MAX_IDS) {
        fprintf(stderr, "Too many identifiers!!\n");
        return;
    }

    for (int i = 0; i < num_ids; i++) {
        if (strcmp(id, saved_ids[i]) == 0) {
            return;
        }
    }

    int l = strlen(id) + 1;
    saved_ids[num_ids] = malloc(l * sizeof(char));
    strncpy(saved_ids[num_ids], id, l);
    num_ids++;
}

int main() {
    if (!yylex()) {
        printf("Unique identifiers:\n");
        for (int i = 0; i < num_ids; i++) {
            printf("  %s\n", saved_ids[i]);
        }
        printf("Number of operations: %d\n", num_ops);
        printf("Number of numbers: %d\n", num_nums);
    }
}
