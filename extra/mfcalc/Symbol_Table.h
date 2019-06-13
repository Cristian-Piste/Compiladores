#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TYP_VAR 0 //Bandera para los tipo VARIABLE
#define TYP_ARIT_FNCT 1 //Bandera para los tipo FUNCION_ARITMETICA

typedef double (*func_t) (double);
typedef struct symrec{
  char *name;
  int type;
  union{
    double var;
    func_t fnctptr;
  } value;
  struct symrec *next;
} symrec;

//Declaracion de la tabla de simbolos
symrec *sym_table;

symrec *putsym (char const *, int);//Prototipo para ingresar simbolo en la tabla
symrec *getsym (char const *); //Prototipo para consultar un simbolo de la tabla

#endif
