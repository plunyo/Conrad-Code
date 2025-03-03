exec = pcl.out
sources = $(wildcard src/*.c)
objects = $(sources:.c=.o)
flags = -g

$(exec): $(objects)
	gcc $(flags) $(objects) -o $(exec)

%.o: %.c
	gcc -c $(flags) $< -o $@

install:
	make
	cp ./pcl.out /usr/local/bin/hello

clean:
	-rm -f *.out
	-rm -f *.o 
	-rm -f src/*.o
