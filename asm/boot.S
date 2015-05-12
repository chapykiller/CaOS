# Constants used in multiboot header
.set ALIGN,    1<<0             # align loaded modules on page boundaries
.set MEMINFO,  1<<1             # provide memory map
.set FLAGS,    ALIGN|MEMINFO    # Multiboot 'flag' field
.set MAGIC,    0x1BADB002       # Lets bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS) # checksum of the above

# Multiboot header put into a special section so it can be forced to be
# at the start of the executable (elf)
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# Create symbols to allocate 16384 bytes(16KiB) for the stack
# Flags: a -> allocatable, w -> writeable
# Type: @nobits -> section does not contain data
.section .bootstrap_stack, "aw", @nobits
stack_bottom:
.skip 16384                     # Allocates 16 KiB
stack_top:

# The bootloader will jump to _start position, as specified in the linker
# script.
.section .text
.global _start
.type _start, @function         # Set type of _start as a function name
_start:

    # Set up stack setting the "esp" register to the top of stack (grows
    # downwards.
    movl $stack_top, %esp

    # Call the entry point in the kernel.c
    call kernel_main

    # In case the function returns, we put the processor into an infinite
    # loop
    cli                         # Clear Interrupt
    hlt                         # Stop the CPU until next interrupt
    # If the execution continues, set a loop
.Lhang:
    jmp .Lhang

# Set the size of _start symbol to the current location (.) minus
# its start. This is useful when debugging or implementing call tracing
.size _start, .-_start
