all: parser parser_push

scanner.c: scanner.l
	flex -o scanner.c scanner.l

parser.h parser.c: parser.y
	bison -d -o parser.c parser.y

parser: parser.c scanner.c hash.o
	gcc --std=c99 parser.c scanner.c hash.o -o parser

scanner_push.c: scanner_push.l
	flex -o scanner_push.c scanner_push.l

parser_push.h parser_push.c: parser_push.y
	bison -d -o parser_push.c parser_push.y

parser_push: parser_push.c scanner_push.c hash.o
	gcc --std=c99 parser_push.c scanner_push.c hash.o -o parser_push

hash.o: hash.c hash.h
	gcc --std=c99 hash.c -c -o hash.o

clean:
	rm -f parser scanner.c parser.c parser.h *.o
	rm -f parser_push scanner_push.c parser_push.c parser_push.h *.o
