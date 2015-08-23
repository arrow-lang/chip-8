all: ch8

index.o: index.as
	../arrow/build/arrow --compile $^ | llc -filetype=obj -o $@

ch8: index.o
	gcc -o $@ $^ -lc
