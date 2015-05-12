/* The bootloader will start execution at the symbol set as entry point */
ENTRY(_start)

/* Tell where each section of the object files should be put in the
 final kernel image */
SECTIONS
{
    /* Set current position to 1MiB, a conventional place for kernels */
    . = 1M;

    /* First of all is the multiboot header followed by the text
      section. Aligned with the page size (4KiB) */
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }

    /* Then comes the read-only data */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* Read-write data (initialized) */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* Read-write data (unintialized) and stack */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
        *(.bootstrap_stack)
    }

    /* Add here others if needed  */
}
