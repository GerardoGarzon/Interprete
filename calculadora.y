%{
      #include <math.h>    
      #include <stdio.h>
      #include <string.h>
      #include "lista.h"
      #include "variable.h"

      int yylex();
      int yyerror();
      Lista tabla_simbolos;
      Variable var_tmp;
      
      int bandera = 0;
      int es_texto = 0;
      
      double valor_tmp;
      char *string_tmp;


      /*
            0 -> no se ha revisado
            1 -> se reviso
            2 -> es variable
      */
      int var_der = 0;
      Variable derecha;

      int var_izq = 0;
      Variable izquierda;

      void crear_variable( int tipo, char* nombre, int resultado );
      double operacion(double valor_derecha, double valor_izquierda, int tipo_operacion);
      double resultadoOperacion(double valor_izquierda, double valor_derecha, int tipo_operacion);
%}

%union{
      double entero;
      char *nombre;
      int tipo;
}

%token <entero> ENTERO;
%token <nombre> VAR_NOMBRE;
%token POTENCIA;
%token <nombre> TEXTO;
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
            | POTENCIA exp ';' '\n' {
                  printf("Resultado de la potencia es: %f\n", $2);
                  var_izq = 0;
                  var_der = 0;
            }
            | var ';' '\n' { 
                  var_izq = 0;
                  var_der = 0;
            }
            | exp ';' '\n' {
                  printf("Resultado: %f\n", $1);
                  var_izq = 0;
                  var_der = 0;
            }
      ;

      var :
            VAR_NOMBRE {
                  int valor; 
                  struct Variable var;
                  strncpy(var.nombre, $1, 50);
                  if (varExiste(&var, &tabla_simbolos) == 1) {
                        var_tmp = obtenerVariable(&var, &tabla_simbolos);
                        switch( var_tmp.tipo ) {
                              case 0:
                                    printf("%s = %d\n", var_tmp.nombre, var_tmp.valor_int);
                                    break;
                              case 1:
                                    printf("%s = %f\n", var_tmp.nombre, var_tmp.valor_double);
                                    break;
                              case 2: 
                                    printf("%s = %s\n", var_tmp.nombre, var_tmp.valor_string);
                                    break;
                        }

                        if ( var_izq == 0 ) {
                              var_izq = 2;
                              izquierda = var_tmp;
                        } else {
                              var_der = 2;
                              derecha = var_tmp;
                        }

                        valor = 1;
                  } else {
                        valor = 0;
                  }
                  $$ = valor; 
            }
            | TEXTO {
                  es_texto = 1;
                  strncpy(string_tmp, yylval.nombre, 100);
            }
            | VARIABLE_INT exp {
                  crear_variable(0, yylval.nombre, $2);
            }
            | VARIABLE_DOUBLE exp {
                  crear_variable(1, yylval.nombre, $2);
            }
            | VARIABLE_STRING exp {
                  crear_variable(2, yylval.nombre, $2);
            }
      ;

      exp: 
            ENTERO { 
                  if ( var_izq == 0 ) {
                        var_izq = 1;
                  } else {
                        var_der = 1;
                  }
                  $$ = $1; 
            }
            
            | exp '+' exp {
                  $$ = resultadoOperacion($1,$3,0);
            }
            | exp '-' exp {
                  $$ = resultadoOperacion($1,$3,1);
            }
            | exp '*' exp {
                  $$ = resultadoOperacion($1,$3,2);
            }
            | exp '/' exp {
                  $$ = resultadoOperacion($1,$3,3);
            }
            | exp ',' exp {
                  $$ = resultadoOperacion($1,$3,4);
            }
            | exp '%' exp {
                  $$ = resultadoOperacion($1,$3,5);
            }
            | var '=' exp { 
                  if( $1 == 0) {
                        bandera = 1;
                        if(es_texto == 1) {
                              es_texto = 0;
                        } else {
                              valor_tmp = $3;
                        }
                  } else if( $1 == 1) {
                        struct Variable modificada;
                        if(var_tmp.tipo == 2) {
                              strncpy(modificada.valor_string, yylval.nombre, 100);
                        } else {
                              modificada.valor_double = $3;
                        }
                        modificarVariable(&var_tmp, &modificada, &tabla_simbolos);
                  }
            }
            | var {
                  
            }
      ;
      
%%

void crear_variable( int tipo, char* nombre, int resultado ) {
      if (resultado == 0) {
            struct Variable var;
            strncpy(var.nombre, nombre, 50);
            var.tipo = tipo;

            if (bandera == 1) {
                  bandera = 0;
                  switch ( tipo ) {
                        case 0:
                              var.valor_int = valor_tmp;
                              break;
                        case 3:
                              var.valor_double = valor_tmp;
                              break;
                        case 2:
                              strncpy(var.valor_string, string_tmp, 100);
                              break;
                  }
            }

            int valor = insertarNodo(&tabla_simbolos, &var);
            if(valor == 1) {
                  printf("La variable se creo correctamente\n");
            } else {
                  printf("Ya ha sido creada una variable con el mismo nombre, intenta con otro\n");
            }
      } else {
            printf("Ya ha sido creada una variable con el mismo nombre, intenta con otro\n");
      }
}

double resultadoOperacion(double valor_izquierda, double valor_derecha, int tipo_operacion) {
      double resultado;

      if ( var_izq == 2 && var_der == 1) {
            if (izquierda.tipo == 2) {
                  printf("Tipo de dato no permitido para la operacion \n");
                  resultado = -1;
            } else {
                  if (izquierda.tipo == 0) {
                        resultado = operacion(izquierda.valor_int, valor_derecha, tipo_operacion);
                  } else {
                        resultado = operacion(izquierda.valor_double, valor_derecha, tipo_operacion);
                  }
            }
      } else if ( var_izq == 1 && var_der == 2) {
            if (derecha.tipo == 2) {
                  printf("Tipo de dato no permitido para la operacion \n");
                  resultado = -1;
            } else {
                  if (derecha.tipo == 0) {
                        resultado = operacion(valor_izquierda, derecha.valor_int, tipo_operacion);
                  } else {
                        resultado = operacion(valor_izquierda, derecha.valor_double, tipo_operacion);
                  }
            }
      } else if ( var_izq == 2 && var_der == 2) {
            if (izquierda.tipo == 2 || derecha.tipo == 2) {
                  printf("Tipo de dato no permitido para la operacion \n");
                  resultado = -1;
            } else {
                  if (izquierda.tipo == 0) {
                        if (derecha.tipo == 0) {
                              resultado = operacion(izquierda.valor_int, derecha.valor_int, tipo_operacion);
                        } else {
                              resultado = operacion(izquierda.valor_int, derecha.valor_double, tipo_operacion);
                        }
                  } else {
                        if (derecha.tipo == 0) {
                              resultado = operacion(izquierda.valor_double, derecha.valor_int, tipo_operacion);
                        } else {
                              resultado = operacion(izquierda.valor_double, derecha.valor_double, tipo_operacion);
                        }
                  }
            }
      } else {
            resultado = operacion(valor_izquierda, valor_derecha, tipo_operacion);
      }
      var_izq = 0;
      var_der = 0;
      return resultado;
}

double operacion(double valor_izquierda, double valor_derecha, int tipo_operacion) {
      switch( tipo_operacion ) {
            case 0:
                  return valor_izquierda + valor_derecha;
            case 1:
                  return valor_izquierda - valor_derecha;
            case 2:
                  return valor_izquierda * valor_derecha;
            case 3:
                  return valor_izquierda / valor_derecha;
            case 4:
                  return pow(valor_izquierda,valor_derecha);
            case 5:
                  return fmod(valor_izquierda,valor_derecha);
      }

}

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
        