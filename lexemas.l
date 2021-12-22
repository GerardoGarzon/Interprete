%{
      #include <stdio.h>
      #include "calculadora.tab.h"
%}

DIGITOS     [0-9]
NUMEROS     (-?{DIGITOS}+)
DECIMALES   {NUMEROS}[.]{DIGITOS}+
SIGNOS      [+]|[-]|[*]|[\/]|[,]|[%]
POT         Pow|pow
VARIABLES   (int|double|string)
NOMBRE      ([a-z]+[_a-zA-Z0-9]*)

OPERACIONES {SIGNOS}{1}

%%

{OPERACIONES}     {
                        return(yytext[0]);
                  }

{NUMEROS}         {
                        yylval.entero = atoi(yytext);
                        return ENTERO;
                  }

{POT}             {
                        return POTENCIA;
                  }

{DECIMALES}       {
                        yylval.entero = atof(yytext);
                        return ENTERO;
                  }

{VARIABLES}       {
                        yylval.tipo = strdup(yytext);
                        return VARIABLE;
                  }

{NOMBRE}          {
                        yylval.nombre = strdup(yytext);
                        return VAR_NOMBRE;
                  }

.                 {}

"\n"  {
            return(yytext[0]);
      }

%%