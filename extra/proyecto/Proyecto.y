// Declaramos librerias de entrada
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    //Usaremos una tabla de simbolos que permitira el uso del analizador
    #include "Symbol_Table.h"
    #include <string.h>

    
    // Declararamos las funciones que necesitaremos
    //Declaramos funcion por si hay error
    int yyerror(char *);
    //Funcion de compilacion
    int yylex(void);
    int yylineno;
    //Declaramos una funcion para leer el archivo
    extern FILE * yyin;
    extern FILE *fopen(const char *filename, const char *mode);

    static int numeroTemporal;
 
    
    char * NVariableTemporal();
    
    int VerificarTemp(char* c);
    
    void borrarTemporal();
    void escribirLinea(char *s);
    void escribir(char *s);
    static int cadena = 0;
    
    char* EmpezarCadena();
    char* cerrarCadenaM();
    char * cerrarCadena();
    
    //Funciones de pila
    char * contadorS [100]; 
    static int top = 0;
    char * quitar_ultimoP();
    char * contadorUltimoE() ;
    void pushP(char * c);
    
%}
	//Declaramos nuestros tokens para usar
%token	PAR_OPEN  PAR_CLOSE COMMA SEMICOLON  WHILE RETURN  
%token	IF ELSE CB_OPEN CB_CLOSE PLUS MINUS ASTERISK SLASH ASSIGNMENT
%token	OR AND NOT LESS LESS_EQUAL MORE_EQUAL MORE EQUAL NOT_EQUAL QUOT

//Declaramos multiple tipo de datos para nuestros tokens usados

%union { char * intval;
        char  charval;
        struct symtab *symp;
        }

%token <intval> NUMBER
%token <charval> LITERAL_C
%token <symp> ID
%token <intval> CHAR
%token <intval> INT


//No terminales
%type <intval> expression
%type <charval> char_expression   
%type <intval> conditions   
%type <intval> types
       

//operadores asociativos izquierda

%left PLUS MINUS
%left ASTERISK SLASH


%%



program: program funcdef 
    | funcdef
    |;

funcdef: types ID args block_statement;

args:  PAR_OPEN var_def_list PAR_CLOSE;
    
var_def_list: var_def COMMA var_def
    |var_def 
    |;

    
var_def: types ID;

types: INT
    | CHAR;

block_statement: CB_OPEN statements CB_CLOSE;

statements: statements statement 
    | statement 
    |;

statement: block_statement
    | conditional_statement
    | while_st
    | assignment_statement SEMICOLON
    | ret_statement SEMICOLON;
    
conditional_statement: IF PAR_OPEN conditions {borrarTemporal(numeroTemporal);} PAR_CLOSE {char *  myelse = EmpezarCadena(); pushP(myelse);  printf("(IF) Como no es  %s se va a  %s ; \n", $3, myelse );} block_statement {char* myelse = quitar_ultimoP();char* endif = EmpezarCadena();pushP(endif);printf("se va a  %s ; \n%s : \n",contadorUltimoE(), myelse);} elsest {;printf("%s : \n", quitar_ultimoP());} 
     ;

elsest: ELSE block_statement
    |;
    
while_st: WHILE PAR_OPEN conditions {borrarTemporal(numeroTemporal);} PAR_CLOSE {char * startwhile = EmpezarCadena(); char * endwhile = EmpezarCadena();pushP(endwhile); pushP(startwhile) ;printf("%s :\n (IF) no es  %s vamos %s ; \n",startwhile , $3, endwhile);} block_statement {char * startwhile = quitar_ultimoP(); printf("Vamos a %s ;\n%s :\n",startwhile ,quitar_ultimoP());};


conditions: conditions LESS expression { if(VerificarTemp($1)){
                                        if(VerificarTemp($3)){borrarTemporal(1);}
                                        printf("%s = %s < %s ;\n", $$ =  $1 ,$1 , $3 ) ;   
                                   }
                                   else if(VerificarTemp($3)){
                                        if(VerificarTemp($1)){borrarTemporal(1);}
                                        printf("%s = %s < %s ;\n", $$ =  $3 ,$1 , $3 ) ;
                                   }
                                   else{
                                        printf("%s = %s < %s ;\n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | conditions LESS_EQUAL expression { if(VerificarTemp($1)){
                                            if(VerificarTemp($3)){borrarTemporal(1);}
                                            printf("%s = %s <= %s ;\n", $$ =  $1 ,$1 , $3 ) ;  
                                     
                                   }
                                   else if(VerificarTemp($3)){
                                            if(VerificarTemp($1)){borrarTemporal(1);}
                                            printf("%s = %s <= %s ;\n", $$ =  $3 ,$1 , $3 ) ;
                                   }
                                   else{
                                     printf("%s = %s <= %s ;\n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | conditions MORE_EQUAL expression { if(VerificarTemp($1)){
                                            if(VerificarTemp($3)){borrarTemporal(1);}
                                            printf("%s = %s >= %s ;\n", $$ =  $1 ,$1 , $3 ) ;   
                                   }
                                   else if(VerificarTemp($3)){
                                            if(VerificarTemp($1)){borrarTemporal(1);}
                                     printf("%s = %s >= %s ;\n", $$ =  $3 ,$1 , $3 ) ;
                                   }
                                   else{
                                     printf("%s = %s >= %s ;\n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | conditions MORE expression { if(VerificarTemp($1)){
                                            if(VerificarTemp($3)){borrarTemporal(1);}
                                     printf("%s = %s > %s ;\n", $$ =  $1 ,$1 , $3 ) ;   
                                   }
                                   else if(VerificarTemp($3)){
                                            if(VerificarTemp($1)){borrarTemporal(1);}                                   
                                     printf("%s = %s > %s ;\n", $$ =  $3 ,$1 , $3 ) ;
                                   }
                                   else{
                                     printf("%s = %s > %s ;\n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | conditions NOT_EQUAL expression { if(VerificarTemp($1)){
                                            if(VerificarTemp($3)){borrarTemporal(1);}
                                     printf("%s = %s != %s ;\n", $$ =  $1 ,$1 , $3 ) ;   
                                   }
                                   else if(VerificarTemp($3)){
                                            if(VerificarTemp($1)){borrarTemporal(1);}
                                     printf("%s = %s != %s ;\n", $$ =  $3 ,$1 , $3 ) ;
                                   }
                                   else{
                                     printf("%s = %s != %s ;\n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | conditions EQUAL expression { if(VerificarTemp($1)){
                                            if(VerificarTemp($3)){borrarTemporal(1);}
                                    printf("%s = %s == %s ;\n", $$ =  $1 ,$1 , $3 ) ;   
                                   }
                                   else if(VerificarTemp($3)){
                                            if(VerificarTemp($1)){borrarTemporal(1);}
                                     printf("%s = %s == %s ;\n", $$ =  $3 ,$1 , $3 ) ;
                                   }
                                   else{
                                     printf("%s = %s == %s ;\n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | expression   { if(VerificarTemp($1)){
                        printf("%s = %s ;\n",$$ = $1, $1);                    
                     } 
                     else{
                        printf("%s = %s ;\n",$$ = NVariableTemporal(), $1);
                     }
                    }
    ;

    
assignment_statement: types ID ASSIGNMENT expression {if (!strcmp($1, "int")){printf("%s = %s ;\n", $2 -> name, $4 ); $2 -> type = "int";} else{yyerror("Los valores no coinciden se esparaba un entero ");} borrarTemporal(numeroTemporal);  }
    | ID ASSIGNMENT expression { if( !strcmp($1 -> type, "int")){printf("%s = %s ;\n", $1 -> name, $3 );}else{yyerror("Valores no son iguales ");} borrarTemporal(numeroTemporal); }
    | types ID ASSIGNMENT char_expression {if (!strcmp($1, "char")){printf("%s = %s ;\n", $2 -> name, $4 );$2 -> type = "char";} else{yyerror("No son tipos de variables iguales se esperaba un char");} borrarTemporal(numeroTemporal);  }  
    | ID ASSIGNMENT char_expression 
    | types ID ASSIGNMENT {  }
    | error ; 
    ;
    
ret_statement: RETURN expression {  };
    


expression: NUMBER { $$ = $1; }
    | ID { $$ = $1 -> name ;}
    | expression PLUS expression { if(VerificarTemp($1)){
                                     if(VerificarTemp($3)){borrarTemporal(1);}
                                     printf("%s = %s + %s ; \n", $$ =  $1 ,$1 , $3 ) ;   
                                     
                                   }
                                   else if(VerificarTemp($3)){
                                     if(VerificarTemp($1)){borrarTemporal(1);}
                                     printf("%s = %s + %s ; \n", $$ =  $3 ,$1 , $3 ) ;
                                     
                                   }
                                   else{
                                     printf("%s = %s + %s ; \n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } 
                                  }
    | expression MINUS expression { if(VerificarTemp($1)){
                                     if(VerificarTemp($3)){borrarTemporal(1);}
                                     printf("%s = %s - %s ; \n", $$ =  $1 ,$1 , $3 ) ;   
                                   }
                                   else if(VerificarTemp($3)){
                                     if(VerificarTemp($1)){borrarTemporal(1);}
                                     printf("%s = %s - %s ; \n", $$ =  $3 ,$1 , $3 ) ;
                                     
                                   }
                                   else{
                                     printf("%s = %s - %s ; \n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | expression ASTERISK expression { if(VerificarTemp($1)){
                                     if(VerificarTemp($3)){borrarTemporal(1);}
                                     printf("%s = %s * %s ; \n", $$ =  $1 ,$1 , $3 ) ;   
                                    
                                   }
                                   else if(VerificarTemp($3)){
                                     if(VerificarTemp($1)){borrarTemporal(1);}
                                     printf("%s = %s * %s ; \n", $$ =  $3 ,$1 , $3 ) ;
                                     
                                   }
                                   else{
                                     printf("%s = %s * %s ; \n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | expression SLASH expression { if(VerificarTemp($1)){
                                     if(VerificarTemp($3)){borrarTemporal(1);}
                                     printf("%s = %s / %s ; \n", $$ =  $1 ,$1 , $3 ) ;   
                                     
                                   }
                                   else if(VerificarTemp($3)){
                                     if(VerificarTemp($1)){borrarTemporal(1);}
                                     printf("%s = %s / %s ; \n", $$ =  $3 ,$1 , $3 ) ;
                                     
                                   }
                                   else{
                                     printf("%s = %s / %s ; \n", $$ =  NVariableTemporal() ,$1 , $3 ) ;
                                   } }
    | PAR_OPEN expression PAR_CLOSE { if(VerificarTemp($2)){
                                        printf("%s = ( %s ) ; \n",$$ = $2  , $2 ); 
                                        }
                                      else{
                                        printf("%s = ( %s ) ; \n",$$ = NVariableTemporal()  , $2 );
                                      }
                                    }
    ;
      



char_expression: QUOT LITERAL_C QUOT { };
    

%%

struct symtab * putsym(s) 
char *s;
{
    struct symtab *sp;
    for(sp = symtab ; sp < &symtab[NSYMS] ; sp++){
        if (sp -> name && ! strcmp(sp->name, s)){
            return sp;
        }
        if (!sp -> name){
            sp->name = strdup(s);
            return sp;
            
        }
    
    }
    yyerror("Solo se permite un maximo de 100 simbolos en la tabla\n");
    exit(1);
} 

char * EmpezarCadena (){
    cadena = cadena + 1;
    
    char integer_string[4] = "";
    
    sprintf(integer_string, "%d", cadena);
    char * temp ;
    temp = strdup("L");
    return  strcat(temp, integer_string); 

}

char * cerrarCadenaM() {
    
    cadena = cadena -1 ;
    char integer_string[4] = "";
    
    sprintf(integer_string, "%d", cadena);
    char * temp ;
    temp = strdup("L");
    return  strcat(temp, integer_string); 
    
}

char * cerrarCadena() {
    char integer_string[4] = "";
    sprintf(integer_string, "%d", cadena);
    char * temp ;
    temp = strdup("L");
    return  strcat(temp, integer_string); 
    
}

void borrarTemporal(int n){
    numeroTemporal = numeroTemporal - n;
}


void escribirLinea(char *s){
    printf("%s\n", s );
}

void escribir(char *s){
    printf("%s", s );
}

char * NVariableTemporal(){
    char integer_string[4] = "";
    
    sprintf(integer_string, "%d", numeroTemporal);
    char * temp ;
    temp = strdup("T");
    return  strcat(temp, integer_string); 

}

int VerificarTemp(char *s){
 
    char *temp = "T";
    if(s[0] == temp[0]){
        return 1;
    }
    
    else{
        return 0;
    }
    
}

//Funciones Pila
void pushP(char * c){
    contadorS[top++] = c;
}

char * quitar_ultimoP(){
    return contadorS[--top];
    
}

char * contadorUltimoE(){
    return contadorS[top - 1];

}


//Funciones de error
int yyerror(char *s){
    fprintf(stderr , "%s En la linea : %i \n", s, yylineno);
    exit(0);
}


int main(int argc ,char *argv[]){
	if(argc!=2){
		printf("Error en los parametros: ./bin [entrada.c]\n");
		exit(0);
	}else{
		yyin = fopen(argv[1], "r");
		if(yyin == NULL){
			printf("Compurebe que el archivo -%s- exista\n", argv[1]);
			exit(0);
		}
	}
	
    yyparse();
	fclose(yyin);
    
	return 0;
}

    
    
    
