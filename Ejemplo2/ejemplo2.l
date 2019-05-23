%{
#include <stdio.h>
int cc=0, cl=0;
%}

%%
\n	{cl++; cc++;}
.	{cc++;}
%%

int main(void){
yylex();
printf("#car=%d \n#lin=%d \n",cc,cl);
return 0;
}
