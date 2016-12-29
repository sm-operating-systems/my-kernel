ENTRY(loader)                    /* The root name of the entry label. */

SECTIONS {
    . = 0x00100000;              /* the code should be loaded at 1Mg, anything below is used by the GRUB itself. */
   
   .text ALIGN (0x1000) :       /* align at 4kb */
   {
       *(.text)                 /* all text sections from all files. */
   }
  
  .rodata ALIGN (0x1000) : /* align at 4 KB */
    {
        *(.rodata*)          /* all read-only data sections from all files */
    }

    .data ALIGN (0x1000) :   /* align at 4 KB */
    {
        *(.data)             /* all data sections from all files */
    }

    .bss ALIGN (0x1000) :    /* align at 4 KB */
    {
        *(COMMON)            /* all COMMON sections from all files */
        *(.bss)              /* all bss sections from all files */
    }
}
