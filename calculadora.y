%{
    #include <math.h>    
    #include <stdio.h>

    int yylex();
    int yyerror();
%}

%union{
    double entero;
    char *tipo;
}

%token <entero> ENTERO;
%token POTENCIA;
%type <entero> exp;

%left '+' '-'
%left '*' '/'
%left '%'

%%

    input: | input line
    ;

    line:   '\n'
        | POTENCIA exp '\n' {
            printf("Resultado de la potencia es: %f\n", $2);
        }
        | exp '\n' {
            printf("Resultado: %f\n", $1);
        }
    ;

    exp: 
        ENTERO { $$ = $1; }
        | exp '+' exp {
            printf("Operacion: %f + %f\n", $1, $3);
            $$ = $1 + $3;
        }
        | exp '-' exp {
            printf("Operacion: %f - %f\n", $1, $3);
            $$ = $1 - $3;
        }
        | exp '*' exp {
            printf("Operacion: %f * %f\n", $1, $3);
            $$ = $1 * $3;
        }
        | exp '/' exp {
            printf("Operacion: %f / %f\n", $1, $3);
            $$ = $1 / $3;
        }
        | exp ',' exp {
            printf("Operacion: Pow(%f , %f)\n", $1, $3);
            $$ = pow($1,$3);
        }
        | exp '%' exp {
            printf("Operacion: Mod(%f , %f)\n", $1, $3);
            $$ = fmod($1,$3);
        }
    ;

%%

int main() {
    yyparse();
}

yyerror(char *s) {
    printf("Error: %s\n", s);
}

int yywrap() {
    return 1;
}
        