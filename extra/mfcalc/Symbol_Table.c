#include "Symbol_Table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char const *s){
	printf ("\n\t***************************\n");
	printf ("\t**      ¡¡¡ERROR!!!      **\n");
	fprintf (stderr, "\t**      %s     **\n", s);
	printf ("\t***************************\n\n> ");
	
}

//Implementacion para ingresar simbolos en la tabla
symrec *putsym (char const *sym_name, int sym_type){
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->type = sym_type;
  ptr->value.var = 0;
  //ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

//Implementacion para consultar simbolos en la tabla
symrec *getsym (char const *sym_name){
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name, sym_name) == 0)
      return ptr;
  return 0;
}
