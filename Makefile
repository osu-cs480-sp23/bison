all: scanner

scanner.c: scanner.l
	flex -o scanner.c scanner.l

scanner: scanner.c hash.o
	gcc --std=c99 scanner.c hash.o -o scanner

hash.o: hash.c hash.h
	gcc --std=c99 hash.c -c -o hash.o

clean:
	rm -f scanner scanner.c *.o
