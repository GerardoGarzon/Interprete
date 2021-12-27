/* 
      Autor: Gerardo Gonzalez Garzon
      Compiladores 3CV18

      Practica 6: Interprete

      Implementacion de lista simplemente ligada
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lista.h"

Nodo* crearNodo( Variable* variable ) {
      Nodo* nodo = (Nodo *) malloc( sizeof(Nodo) );
      nodo -> variable.tipo = variable -> tipo;
      strncpy(nodo -> variable.nombre, variable -> nombre, 50);
      switch ( variable -> tipo ) {
            case 0:
                  nodo -> variable.valor_int = variable -> valor_int;
                  break;
            case 1:
                  nodo -> variable.valor_double = variable -> valor_double;
                  break;
            case 2:
                  strncpy(nodo -> variable.valor_string, variable -> valor_string, 100);
                  break;
      }
      nodo -> siguiente = NULL;
      return nodo;
}

void destruirNodo( Nodo* nodo ) {
      free(nodo);
}

int insertarNodo( Lista* lista, Variable* variable ) {
      Nodo* nodo = crearNodo(variable);

      if (varExiste(variable, lista) == 1) {
            return 0;
      } else {
            if( lista -> inicio == NULL ) {
                  lista -> inicio = nodo;
            } else {
                  Nodo* nodoTmp = lista -> inicio;
                  
                  while(nodoTmp -> siguiente != NULL) {
                        nodoTmp = nodoTmp -> siguiente;
                  }
                  nodoTmp -> siguiente = nodo;
            }
            return 1;
      }
}

int varExiste( Variable* variable , Lista* lista ) {
      Nodo* nodoTmp = lista -> inicio;

      while( nodoTmp != NULL ) {
            if ( strcmp(nodoTmp -> variable.nombre, variable -> nombre) == 0 ) {
                  return 1;
            } else {
                  nodoTmp = nodoTmp -> siguiente;
            }
      }

      return 0;
}