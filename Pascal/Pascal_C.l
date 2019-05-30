DIGITO                     	[0-9]
KEYWORDS        			auto|break|case|const|continue|default|do|else|enum|extern|for|goto|if|register|return|signed|sizeof|static|typedef|union|while|using|namespace|vector
TIPOSDATO                  	char|int|long|short|float|double|void|unsigned|uint32_t|size_t
DIRECTIVAS                 	"#"[a-zA-Z]+
LIBS                       	"<"[a-z]+("."[a-zA-Z]+|"")">"
OPERADORES_ARITMETICOS     	("+"|"-"|"*"|"/"|"%")|"="|("+"|"-"|"*"|"/"|"%")"="|"++"|"--"
OPERADORES_COMPARACION     	<|>|>=|<=|"!="|==|"!"|&&|"||"
OPERADORES_BIT             	>>|>>=|<<|<<=|"~"|"&"|"&="|"|"|"|="|"^"|"^="
OPERADORES_OTROS           	":"|"::"|"?"|"\\"
OPERADORES                 	{OPERADORES_ARITMETICOS}|{OPERADORES_COMPARACION}|{OPERADORES_BIT}|{OPERADORES_OTROS}
SEPARADORES                	".("|")"|"{"|"}"|";"|","
ID                         	([a-zA-Z]|"_")([a-zA-Z0-9]|"_")*
ID_MAL                     	{DIGITO}+([a-zA-Z]|"_")([a-zA-Z0-9]|"_")*
NUMERICOS                  	{DIGITO}+"."{DIGITO}+|{DIGITO}+
SECUENCIAS_ESCAPE          	"\\""\""|"\\""n"
CARACTERES_ESPECIALES      	"."|" "|"'"|"#"|"?"|":"|"\\"|"@"
CHARS                      	"'"({SECUENCIAS_ESCAPE}|[a-zA-Z0-9]|{CARACTERES_ESPECIALES}|{SEPARADORES}|{OPERADORES}|{ID}|{KEYWORDS}|{TIPOSDATO}|{LIBS}|{DIRECTIVAS}|{NUMERICOS})*"'"
STRINGS                    	"\""({SECUENCIAS_ESCAPE}|[a-zA-Z0-9]|{CARACTERES_ESPECIALES}|{SEPARADORES}|{OPERADORES}|{ID}|{KEYWORDS}|{TIPOSDATO}|{LIBS}|{DIRECTIVAS}|{NUMERICOS})*"\""
CADENAS                    	{STRINGS}|{CHARS}
COMENTARIOS_UNALINEA    	"/""*"+([a-zA-Z0-9]|{CARACTERES_ESPECIALES}|{SEPARADORES}|{OPERADORES}|{ID}|{KEYWORDS}|{TIPOSDATO}|{CADENAS}|{LIBS}|{DIRECTIVAS}|{NUMERICOS}|{SECUENCIAS_ESCAPE})*"*"+"/"
COMENTARIOS_CONTINUACION   	("/"|"")"*"([a-zA-Z0-9]|{CARACTERES_ESPECIALES}|{SEPARADORES}|{OPERADORES}|{ID}|{KEYWORDS}|{TIPOSDATO}|{CADENAS}|{LIBS}|{DIRECTIVAS}|{NUMERICOS}|{SECUENCIAS_ESCAPE})*
COMENTARIOS                	{COMENTARIOS_UNALINEA}|{COMENTARIOS_CONTINUACION}

%{
#include<stdio.h>
%}
%%

{KEYWORDS}          		{ printf("<p class = \"KEYWORDS\">%s</p>",yytext); }
{TIPOSDATO}         		{ printf("<p class = \"TIPOSDATO\">%s</p>",yytext); }
{COMENTARIOS}       		{ printf("<p class = \"COMENTARIOS\">%s</p>",yytext); }
{CADENAS}           		{ printf("<p class = \"CADENAS\">%s</p>",yytext); }
{NUMERICOS}         		{ printf("<p class = \"NUMERICOS\">%s</p>",yytext); }
{ID}                		{ printf("<p class = \"ID\">%s</p>",yytext); }
{ID_MAL}            		{ printf("<p class = \"ID_MAL\">%s</p>",yytext); }
{OPERADORES}        		{ printf("<p class = \"OPERADORES\">%s</p>",yytext); }
{LIBS}              		{ printf("<p class = \"LIBS\">%s</p>",yytext); }
{DIRECTIVAS}        		{ printf("<p class = \"DIRECTIVAS\">%s</p>",yytext); }
[\n]                		{ printf("<br/>");}
[\t]                		{ printf("<p class = \"tab\">Tab</p>");}
[\v]                		{ printf("<p class = \"tab\">TabV<br></p>");}
%%
int main(){
 printf("\n <!DOCTYPE html>");
 printf("\n <html>");
 printf("\n   <head>");
 printf("\n     <title>Sample page</title>");
 printf("\n    <link rel=\"stylesheet\" type=\"text/css\" href=\"hoja.css\">");
 printf("\n   </head>");
 printf("\n   <body>");
    yylex();
 printf("\n   </body>");
 printf("\n </html>");
 return 0;
}
