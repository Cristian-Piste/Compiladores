LETRAS   [a-zA-Z_]
ALFA   [a-zA-Z_0-9]
DIGITIO   [0-9]
DIGITIO_0  [1-9]
UNDER (_)

WS  [ \t\v\n\f]
/* Declaraciones */
%{
/* Librerias en c a usar asi como nuestra tabla de simbolos */
#include <stdio.h>
#include "Proyecto.tab.h"
#include <stdlib.h>
#include "Symbol_Table.h"
/* Metodo externo decladaro en Analizado para mostrar errores */

extern void yyerror(const char *);  
/* Metodo que analiza los comentarios en el codigo */
static void comment(void);
int yylineno ;


%}
/* Reglas */
%%

"/*"		{ comment(); }
"//".*		{ /* consume //-comment */ }
			/*Dicionario de las variables que leera del archivo entrante */
{DIGITIO_0}{DIGITIO}*	{ yylval.intval = strdup(yytext); return(NUMBER); }
"int"		{ yylval.intval = strdup(yytext);return(INT); }
"char"		{ yylval.intval = strdup(yytext);return(CHAR); }
"if"		{ return(IF); }
"else"		{ return(ELSE); }
"while"		{ return WHILE;}
"return"	{ return RETURN; }
"("			{ return PAR_OPEN; }
")"			{ return PAR_CLOSE; }
";"			{ return SEMICOLON; }
"{"			{ return CB_OPEN; }
"}"			{ return CB_CLOSE; }
"+"			{ return PLUS; }
"-"			{ return MINUS; }
"*"			{ return ASTERISK; }
"/"			{ return SLASH; }
"="			{ return ASSIGNMENT; }
"<="		{ return LESS_EQUAL; }
"<"			{ return LESS; }
">="		{ return MORE_EQUAL; }
">"			{ return MORE; }
"=="		{ return EQUAL; }
"!="		{ return NOT_EQUAL; }
{UNDER}{LETRAS}	{ yylval.charval = yytext[1]; return LITERAL_C ; }
{LETRAS}{ALFA}*		{ yylval.symp = putsym(yytext); return(ID); }
{WS}		{ if( *yytext == '\n' ){yylineno++;} }
.			{ yyerror("Simbolo no definido"); }


%%
int yywrap(void){        /* Este metodo se llama cuando se termina la entrada de datos */
	return 1;           /* Terminar programa */
}

static void comment(void){
	int c;

	while ((c = input()) != 0)
		if (c == '*'){
			while ((c = input()) == '*');
				if (c == '/') return;
				if (c == 0) break;
		}
	yyerror("El comentario no fue cerrado");
}

