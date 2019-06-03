run: analizador
	./analizador
analizador: lex.yy.c analizador.tab.c
	gcc lex.yy.c analizador.tab.c -o analizador -ly -lfl -lm
analizador.tab.c:
	bison -d analizador.y
	clear
lex.yy.c:
	flex analizador.l
clean:
	rm lex.yy.c
	rm analizador.tab.c
	rm analizador.tab.h
	rm analizador
	clear
