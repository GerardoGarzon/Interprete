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

      if( lista -> inicio == NULL ) {
            lista -> inicio = nodo;
            return 1;
      } else {
            if (varExiste(variable, lista) == 1) {
                  return 0;
            } else {
                  Nodo* nodoTmp = lista -> inicio;
                  
                  while(nodoTmp -> siguiente != NULL) {
                        nodoTmp = nodoTmp -> siguiente;
                  }
                  nodoTmp -> siguiente = nodo;
                  return 1;
            }      
      }
}

int varExiste( Variable* variable , Lista* lista ) {
      if(lista -> inicio != NULL) {
            Nodo* nodoTmp = lista -> inicio;

            while( nodoTmp != NULL ) {
                  if ( strcmp(nodoTmp -> variable.nombre, variable -> nombre) == 0 ) {
                        return 1;
                  } else {
                        nodoTmp = nodoTmp -> siguiente;
                  }
            }
      } else {
            return 0;
      }

      return 0;
}

Variable obtenerVariable(Variable* variable, Lista* lista) {
      if(lista -> inicio != NULL) {
            Nodo* nodoTmp = lista -> inicio;

            while( nodoTmp != NULL ) {
                  if ( strcmp(nodoTmp -> variable.nombre, variable -> nombre) == 0 ) {
                        return nodoTmp -> variable;
                  } else {
                        nodoTmp = nodoTmp -> siguiente;
                  }
            }
      }
}

void modificarVariable(Variable* destino, Variable* modificacion, Lista* lista) {
      if(lista -> inicio != NULL) {
            Nodo* nodoTmp = lista -> inicio;

            while( nodoTmp != NULL ) {
                  if ( strcmp(nodoTmp -> variable.nombre, destino -> nombre) == 0 ) {
                        switch( destino -> tipo ) {
                              case 0:
                                    nodoTmp -> variable.valor_int = modificacion -> valor_double;
                                    printf("Nuevo valor %s = %d\n", destino -> nombre, nodoTmp -> variable.valor_int);
                                    break;
                              case 1:
                                    nodoTmp -> variable.valor_double = modificacion -> valor_double;
                                    printf("Nuevo valor %s = %f\n", destino -> nombre, nodoTmp -> variable.valor_double);
                                    break;
                              case 2:
                                    strncpy(nodoTmp -> variable.valor_string, modificacion -> valor_string, 100);
                                    printf("Nuevo valor %s = %s\n", destino -> nombre, nodoTmp -> variable.valor_string);
                                    break;
                        }
                        break;
                  } else {
                        nodoTmp = nodoTmp -> siguiente;
                  }
            }
      }
}