.PHONY: all clean

all: stackclient stackclient_memtrace

memtrace.o: memtrace.c memtrace.h
	${CC} -std=c99 -D MEMTRACE -g -c memtrace.c

stackADT4.o: stackADT.h stackADT4.c memtrace.h 
	${CC} -std=c99 -g -c stackADT4.c

stackADT4_memtrace.o: stackADT.h stackADT4.c memtrace.h 
	${CC} -std=c99 -D MEMTRACE -g -c stackADT4.c -o stackADT4_memtrace.o

stackclient: stackclient.c stackADT.h stackADT4.o memtrace.o memtrace.h
	${CC} -std=c99 -g stackclient.c stackADT4.o memtrace.o -o stackclient

stackclient_memtrace: stackclient.c stackADT.h stackADT4_memtrace.o memtrace.o memtrace.h
	${CC} -std=c99 -D MEMTRACE -g stackclient.c stackADT4_memtrace.o memtrace.o -o stackclient_memtrace

clean:
	-${RM} stackclient stackclient_memtrace *.o
