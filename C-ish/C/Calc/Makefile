# makefile

# compiler
CC = gcc

# flags
CFLAGS = -Wall -Werror

# target name
TARGET = calc

# source files
SRC = main.c

# default target
all: $(TARGET)

# build target
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

# clean target
clean:
	rm -f $(TARGET)
