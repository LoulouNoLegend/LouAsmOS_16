bits 16
org 0x7C00

start:
    ; STACK SETUP
    cli ; disable interrupts
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0xFFFF
    sti ; enable interrupts


; magic formula for 512 bits
times 510 - ($ - $$) db 0
dw 0xAA55