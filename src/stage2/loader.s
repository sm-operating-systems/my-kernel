; Allocating space for the stack
;

global loader                   ; the entry symbol of elf

MAGIC_NUMBER  equ 0x1BADB002    ; define the magic number constant
FLAGS         equ 0x0           ; multiboot flags
CHECKSUM      equ -MAGIC_NUMBER ; calculate the checksum
KERNEL_STACK_SIZE equ 4096      ; size of the stack in bytes

section .bss
align 4
kernel_stack:                   		; label points to the beginning of memory
	resb KERNEL_STACK_SIZE  		; reserve memory for stack
mov esp, kernel_stack + KERNEL_STACK_SIZE  	; point esp to the start of the stack
    

section .text:                  ; start of the code section
align 4                         ; the code must be 4 bytes aligned
	dd MAGIC_NUMBER         ; write the magic number to the machine code
    	dd FLAGS
    	dd CHECKSUM                 

loader:                         ; the loader symbol defined as the entry point to the linker script
	mov eax, 0xCAFEBABE     ; place the special number in the eax register
.loop:
jmp .loop                    	; now loop forever
