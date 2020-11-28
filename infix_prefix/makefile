program: lex.yy.o parse.tab.o
	gcc -o program $^

parse.tab.h: parse.y
	bison -d parse.y

parse.tab.c: parse.y
	bison -d parse.y

lex.yy.c: lex.flex parse.tab.h
	flex  lex.flex
