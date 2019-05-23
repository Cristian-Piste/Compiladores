%{
#include <stdio.h>
#include <math.h>
int yylex (void);
void yyerror(char const*);
%}

%define api.value.type {double}
%token NUM

%%
/*empty---cadena vacia
    El arbol se analiza de los hijos hacia los padres (Button up)

La gramatca tiene 4 elementos : Producciones, Simbolo inical, simblo trminales y no terminales 
las gamaticas se derivan, empzado con el simbolo inicial
*/
input: %empty
|input line
;

line: '\n'
| exp '\n'  {printf("%.10g\n", $1);}
;

exp: NUM	{$$ =$1;}
| exp exp '+'   {$$ =$1+$2;}
| exp exp '-'   {$$ =$1-$2;}
| exp exp '*'   {$$ =$1*$2;}
| exp exp '/'   {$$ =$1/$2;}
| exp exp '^'   {$$ =pow($1,$2);}
| exp 'n'       {$$ =-$1;}
;
%%
void yyerror(char const* s){
    fprintf(stderr,"Error de sintaxis: %s\n",s);
}
int main (void){
    return yyparse();
}
