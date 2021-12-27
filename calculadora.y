%{
      #include <math.h>    
      #include <stdio.h>
      #include <string.h>
      #include "lista.h"
      #include "variable.h"

      int yylex();
      int yyerror();
      Lista tabla_simbolos;
      
%}

%union{
      double entero;
      char *nombre;
      int tipo;
}

%token <entero> ENTERO;
%token <nombre> VAR_NOMBRE;
%token POTENCIA;
%token VARIABLE_INT;
%token VARIABLE_DOUBLE;
%token VARIABLE_STRING;
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
            | VARIABLE_INT var '\n'{
                  if ($2 == 1) {
                        printf("Se creo la variable de tipo int %s\n", yylval.nombre);
                  } else {
                        printf("Ya ha sido creada una variable con el mismo nombre, intenta con otro\n");
                  }
            }
            | VARIABLE_DOUBLE var '\n'{
                  if ($2 == 1) {
                        printf("Se creo la variable de tipo double %s\n", yylval.nombre);
                  } else {
                        printf("Ya ha sido creada una variable con el mismo nombre, intenta con otro\n");
                  }
            }
            | VARIABLE_STRING var '\n'{
                  if ($2 == 1) {
                        printf("Se creo la variable de tipo string %s\n", yylval.nombre);
                  } else {
                        printf("Ya ha sido creada una variable con el mismo nombre, intenta con otro\n");
                  }
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
            VAR_NOMBRE { 
                  struct Variable var;
                  strncpy(var.nombre, $1, 50);
                  int valor = insertarNodo(&tabla_simbolos, &var);
                  $$ = valor; 
            }
            | VAR_NOMBRE '=' exp { 
                  struct Variable var;
                  strncpy(var.nombre, $1, 50);
                  var.valor_int = $3;
                  int valor = insertarNodo(&tabla_simbolos, &var);
                  $$ = valor; 
            }
      ;


%%

int main() {
      tabla_simbolos.inicio = NULL;
      yyparse();
}

yyerror(char *s) {
      printf("Error: %s\n", s);
}

int yywrap() {
      return 1;
}
        