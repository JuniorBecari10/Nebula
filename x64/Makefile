all: assemble clean

assemble:
	nasm -f elf64 main.asm -o main.o && \
	ld -m elf_x86_64 main.o -o main

clean:
	rm -f main.o
