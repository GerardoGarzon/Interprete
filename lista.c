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

void insertarNodo( Lista* lista, Variable* variable ) {
      Nodo* nodo = crearNodo(variable);
      
      if( lista -> inicio == NULL ) {
            lista -> inicio = nodo;
      } else {
            Nodo* nodoTmp = lista -> inicio;
            
            while(nodoTmp -> siguiente) {
                  nodoTmp = lista -> inicio;
            }
            nodoTmp -> siguiente = nodo;
      }
}

Variable* varExiste( Variable variable , Lista* lista ) {
      Nodo* nodoTmp = lista -> inicio;

      while( nodoTmp != NULL ) {
            if ( strcmp(nodoTmp -> variable.nombre, variable.nombre) ) {
                  return &nodoTmp -> variable;
            } else {
                  nodoTmp = nodoTmp -> siguiente;
            }
      }

      return NULL;
}