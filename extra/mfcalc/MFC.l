%{
	#include <stdlib.h>  
	#include "Symbol_Table.h"
	#include "MFC.tab.h"
%}

LETRA	[a-zA-Z]
DIGITO	[0-9]
ID		({LETRA}|"_")({LETRA}|{DIGITO}|"_")*
OP		[+-/*=^)(\n]


%%
{DIGITO}+"."{DIGITO}+	{ yylval.dval = atof(yytext); return NUM;												}
{DIGITO}+ 				{ yylval.dval = atof(yytext); return NUM;												}
"func "{ID}*			{ yylval.sval = getsym(yytext);	return DEF;												}//Consulta de simbolos tipo FUNCION en la tabla
{ID}					{ 
							yylval.sval = getsym(yytext);//Consulta de simbolos identificados con el analizador
							if(!yylval.sval){ yylval.sval = putsym(strdup(yytext), TYP_VAR);  	  return VAR; 	}//Ingresa los tipo VARIABLES en la tabla de simbolos
							if(yylval.sval->type == TYP_VAR) { return VAR;										}
							if(yylval.sval->type == TYP_ARIT_FNCT) { return ARIT_FNCT;							}
																												}
{OP} 					{ return yytext[0];																		}
[\t]+					{																						}
%%
