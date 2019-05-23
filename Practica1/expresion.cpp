#include <iostream>
#include <cstring>
#include <list>
#include <stack>

using namespace std;

int exp_Alfabeto(char);//COMPRUEBA QUE LOS CARACTERES ESTEN EN EL RANGO [ a-z ] - [ )(*+| ]
int exp_Validar(string);//VALIDA QUE LA CADENA CUMPLA CON LAS CONDICIONES
int exp_Parentesis(string);//CORROBORA QUE LOS PARENTESIS ESTEN BALANCEADOS
int exp_Bifuracion(string);//COMPROBACION DE |
list<char> arbol(string);//ARBOL DE DERIVACION

int main(){
	list<char> lista;
	int balance, valido, comprobacion;
	string expresion;
	cout << "Cual es la expresion: ";
	cin >> expresion;
	balance = exp_Parentesis(expresion);
	valido = exp_Validar(expresion);
	comprobacion = exp_Bifuracion(expresion);
	if (balance == 1 && valido == 1 && comprobacion == 1){
		cout << "La expresion \"" << expresion << "\" esta bien formada" << endl;
		lista = arbol(expresion);
	}else{
		cout << "La expresion \"" << expresion << "\" no cumple con las condiciones" << endl;
	}
	

	return 0;
}

int exp_Alfabeto(char caracter){
	if ((((int)caracter) >= 97) && ((int)caracter <= 122)){//a-z
		return 1;
	}

	if ((((int)caracter) >= 40) && ((int)caracter <= 43)){//()*+
		return 1;
	}
	if ((((int)caracter) == 124)){//|
		return 1;
	}
	return 0;
}

int exp_Validar(string cadena){
	char c;
	int valido;
	for (int i = 0; i < (int)cadena.length(); ++i){
		c= cadena[i];
		valido= exp_Alfabeto(c);
		if (valido == 0){
			return -1;
		}
	}
	return 1;
}

int exp_Parentesis(string cadena){
	stack<char> pila;
	for (int i = 0; i < (int)cadena.length(); ++i){
		switch(cadena[i]){
			case '(':
			pila.push(cadena[i]);
			break;
			
			case ')' :
			if (pila.empty()){
				return -1;
				break;
			}
			pila.pop();
			break;

			default:
			break;
		}
	}
	cout <<endl;
	if (pila.empty()){
		return 1;
	}else{
		return -1;
	}
}


int exp_Bifuracion(string cadena){
	int comprobacion;
	for(int i = 0; i < (int)cadena.length(); i++){
		if (cadena[i] == '|'){
			if ((cadena[i+1] == '|') || (cadena[i+1]== '(') || (cadena[i+1]== ')')){
				comprobacion = -1;
			}else{
				comprobacion = 1;
			}
		}
	}
	return comprobacion;
}

list<char> arbol(string cadena){
	list<char> lista;
	for(int i = 0; i < (int)cadena.length(); i++){
		lista.push_back(cadena[i]);
	}
	return lista;
}

/*
	cout << "digraph AFD{\n";
	cout << "\tnode [shape=circle];\n";
	cout << "\trankdir=LR;\n";
	cout << "\tZ [style=invis];\n";
	cout << "\tZ -> A [label=\"inicial\"];\n";
	//LOGICA PARA PASAR DE er A afn
	cout << "}";
*/

/*
	*,+ -> tienen la mayor prioridad
	. -> tiene la segunda prioridad
	| -> tiene la menor priorirdad
*/