all: boot kernel link
boot:
	i686-elf-as asm/boot.S -o obj/boot.o
kernel:
	i686-elf-gcc -c src/kernel.c -o obj/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
link: obj/boot.o obj/kernel.o
	i686-elf-gcc -T asm/linker.ld -o caos.bin -ffreestanding -O2 -nostdlib obj/boot.o obj/kernel.o -lgcc
clean:
	rm -f ./obj/*.o caos.bin
