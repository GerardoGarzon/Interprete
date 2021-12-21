rm -r calculadora.tab.c calculadora.tab.h lex.yy.c salida
flex lexemas.l
bison calculadora.y -d
gcc -o salida calculadora.tab.c lex.yy.c -lm
clear
./salida