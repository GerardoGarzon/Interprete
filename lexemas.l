%{
      #include <stdio.h>
      #include <string.h>
      #include "calculadora.tab.h"
%}

DIGITOS     [0-9]
NUMEROS     (-?{DIGITOS}+)
DECIMALES   {NUMEROS}[.]{DIGITOS}+
SIGNOS      [+]|[-]|[*]|[\/]|[,]|[%]
POT         Pow|pow
VARIABLES   (int|double|string)
NOMBRE      ([a-z]+[_a-zA-Z0-9]*)
SALIDA      exit|finish|end

OPERACIONES {SIGNOS}{1}

%%

{SALIDA}        {
                    exit(0);
                }

{OPERACIONES}   {
                    return(yytext[0]);
                }

{NUMEROS}       {
                    yylval.entero = atoi(yytext);
                    return ENTERO;
                }

{POT}           {
                    return POTENCIA;
                }

{DECIMALES}     {
                    yylval.entero = atof(yytext);
                    return ENTERO;
                }

{VARIABLES}     {
                    if(strcmp(yytext, "int") == 0) {
                        return VARIABLE_INT;
                    } else if(strcmp(yytext, "double") == 0) {
                        return VARIABLE_DOUBLE;
                    } else if(strcmp(yytext, "string") == 0) {
                        return VARIABLE_STRING;
                    }
                }

{NOMBRE}        {
                    yylval.nombre = strdup(yytext);
                    return VAR_NOMBRE;
                }

.               {}

"\n"  {
            return(yytext[0]);
      }

%%