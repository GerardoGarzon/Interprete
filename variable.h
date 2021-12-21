/* 
      Autor: Gerardo Gonzalez Garzon
      Compiladores 3CV18

      Practica 6: Interprete

      Cabeceras para cada tipo de variable
*/

#ifndef variable_h
#define variable_h

#include <stdio.h>

typedef struct Variable{
      char nombre[50];
      /*
            tipo de variable
            0 -> Int
            1 -> Double
            2 -> String
      */
      int tipo;
      /* 
            Variables correspondiente para almacenar 
            la informacion dependiendo del tipo de 
            variable
      */
      int valor_int;
      double valor_double;
      char valor_string[100];
} Variable;

#endif