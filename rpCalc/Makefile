calc: rpcalc.tab.o lex.yy.o
	gcc rpcalc.tab.o lex.yy.o -lm -lfl -o calc
rpcalc.tab.c: rpcalc.y
	bison -d $<
lex.yy.c: rpcalc.l
	flex $<
lex.yy.o: lex.yy.c
	gcc -c $<
rpcalc.tab.o:rpcalc.tab.c
	gcc -c $<
clean:
	rm *.c *.o calc *.h
