CC = gcc
CFLAGS = -Wall -std=c11 -g
SOURCES = main.c
TARGET = pcl.exe

all: $(TARGET)

clean:
	del /f /q $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET)


