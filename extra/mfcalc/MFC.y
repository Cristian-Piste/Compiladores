%{
	#include <stdio.h>
	#include <math.h>  
	#include "Symbol_Table.h"
	int yylex (void);
	void yyerror(char const *);
%}

%union {
  double dval;
  struct symrec *sval;
}

%token <dval>  NUM      
%token <sval> VAR ARIT_FNCT
%token <char*> DEF;
%type  <dval>  exp

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^'     
%%

input: %empty
	| input line;

line: '\n'
	| exp '\n'   	{ printf ("	-> %.10g\n> ", $1); }
	| error '\n' 	{ yyerrok; };

exp: NUM                	{ $$ = $1;                         	}
	| VAR                	{ $$ = $1->value.var;              	}
	| VAR '=' exp        	{ $$ = $3; $1->value.var = $3;     	}
	| ARIT_FNCT '(' exp ')'	{ $$ = (*($1->value.fnctptr))($3);	}
	| exp '+' exp        	{ $$ = $1 + $3;                    	}
	| exp '-' exp        	{ $$ = $1 - $3;                    	}
	| exp '*' exp        	{ $$ = $1 * $3;                    	}
	| exp '/' exp        	{ $$ = $1 / $3;                    	}
	| '-' exp  %prec NEG 	{ $$ = -$2;                        	}
	| exp '^' exp        	{ $$ = pow ($1, $3);               	}
	| '(' exp ')'        	{ $$ = $2;                         	};

%%

//Declaracion de la tabla de simbolos
//symrec *sym_table;
//Apuntadores a los elementos de la tabla de simbolos para funciones aritmeticas [nombre][valor]
struct funciones{
  char const *fname;
  double (*fnct) (double);
};

//Tabla con funciones aritmeticas
struct funciones const f_arith[] ={
	{ "SEN"	,	sin   },
	{ "COS"	,	cos   },
	{ "TAN"	,	tan   },
	{ "ATAN",	atan  },
	{ "LN"	,	log   },
	{ "LOG"	,	log10 },
	{ "SQRT",	sqrt  },
	{ "SENH",	sinh  },
	{ "COSH",	cosh  },
	{ "TANH",	tanh  },
	{ "EXP"	,	exp   },
	{ 0		,	0     },
};

//Inicializacion de la tabla de simbolos con las funciones aritmeticas
static void putsym_FUN_f_arith(){
	int i;
	for (i = 0; f_arith[i].fname != 0; i++){
		symrec *ptr = putsym (f_arith[i].fname, TYP_ARIT_FNCT);
		ptr->value.fnctptr = f_arith[i].fnct;
    }
}

int yywrap(){ return 1; }

int main (int argc, char const* argv[]){
  printf("> ");
  putsym_FUN_f_arith();
  return yyparse();
}
