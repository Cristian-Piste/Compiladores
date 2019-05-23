D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*
RESERVADAS              break|using|namespace|case|const|continue|default|do|else|extern|for|goto|if|return|register|sizeof|static|switch
TIPOS                   auto|char|double|enum|float|int|long|short|signed|struct|typedef|union|unsigned|void
OPERADORES              <|>|&&|%|==|"="|"+"|"-"|"/"|"||"|<=|>=|"++"|"--"
SIMBOLOS                "("|")"|"{"|"}"|";"|","

%{
#include<stdio.h>
%}
%%

#include		{ printf("<p class = \"libreria\">%s</p>",yytext); }
"/*"			{ printf("<p class = \"comentario\">%s</p>",yytext); }
"*/"			{ printf("<p class = \"comentario\">%s</p>",yytext); }

{TIPOS}			{ printf("<p class = \"tipodato\">%s</p>",yytext); }
{RESERVADAS}            { printf("<p class = \"reservada\">%s</p>",yytext); }
{OPERADORES}            { printf("<p class = \"operador\">%s</p>",yytext); }
{SIMBOLOS}              { printf("<p class = \"simbolo\">%s</p>",yytext); }



"main"			{ printf("<p class = \"main\">%s</p>",yytext); }
{L}({L}|{D})*	        { printf("<p class = \"ids\">%s</p>",yytext);}
0{D}+{IS}?		{ printf("<p class = \"numero\">%s</p>",yytext);}
{D}+{IS}?		{ printf("<p class = \"numero\">%s</p>",yytext);}
0[xX]{H}+{IS}?		{ printf("<p class = \"sinClass\">%s</p>",yytext);}
{D}+{E}{FS}?		{ printf("<p class = \"sinClass\">%s</p>",yytext);}
{D}*"."{D}+({E})?{FS}?	{ printf("<p class = \"sinClass\">%s</p>",yytext);}
{D}+"."{D}*({E})?{FS}?	{ printf("<p class = \"sinClass\">%s</p>",yytext);}
[\f]			{ printf("<p class = \"sinClass\">%s</p>",yytext);}
L?'(\\.|[^\\'])+'	{ printf("<p class = \"constantechar\">%s</p>",yytext);}
L?\"(\\.|[^\\"])*\"	{ printf("<p class = \"constantechar\">%s</p>",yytext);}
[\t]			{ printf("<p class = \"tab\">Tab</p>");}
[\v]			{ printf("<p class = \"tab\">TabV<br></p>");}
[\n]			{ printf("<br/>");}
"\\n"			{ printf("<p class = \"escape\">%s</p>",yytext);}
" "			{ printf(" ");}
.			{ printf("<p class = \"sinClass\">%s</p>",yytext);}
%%
int main(){
 printf("\n <!DOCTYPE html>");
 printf("\n <html>");
 printf("\n   <head>");
 printf("\n     <title>Sample page</title>");
 printf("\n    <link rel=\"stylesheet\" type=\"text/css\" href=\"ejemplo.css\">");
 printf("\n   </head>");
 printf("\n   <body>");
	yylex();
 printf("\n   </body>");
 printf("\n </html>");
 return 0;
}
