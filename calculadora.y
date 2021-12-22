%{
      #include <math.h>    
      #include <stdio.h>
      #include "lista.h"

      int yylex();
      int yyerror();
%}

%union{
      double entero;
      char *nombre;
      char *tipo;
}

%token <entero> ENTERO;
%token <nombre> VAR_NOMBRE;
%token POTENCIA;
%token VARIABLE;
%type <entero> exp;
%type <nombre> var;

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
            | VARIABLE var '\n'{
                  printf("Se creo la variable de tipo %s\n", yylval.tipo);
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
      var :
            VAR_NOMBRE { $$ = $1; }
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
        