/* 
      Autor: Gerardo Gonzalez Garzon
      Compiladores 3CV18

      Practica 6: Interprete

      Cabeceras para crear la lista
*/

#ifndef lista_h
#define lista_h

#include <stdio.h>
#include "variable.h"

/*
      Nodo destinado a guardar la informacion de cada variable creada
      y ser almacenada en una lista simplemente ligada
*/
typedef struct Nodo{
      Variable variable;
      struct Nodo* siguiente;
} Nodo;

/*
      Estructura destinada para almacenar el inicio de la lista
*/
typedef struct Lista{
      Nodo* inicio;
} Lista;

Nodo* crearNodo( Variable* variable );

void destruirNodo( Nodo* nodo );

int insertarNodo( Lista* lista, Variable* variable );

int varExiste( Variable* variable , Lista* lista );

#endif