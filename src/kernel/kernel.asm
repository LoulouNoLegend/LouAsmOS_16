bits 16
org 0x0000

start:
    mov ah, 0x0E
    mov al, 'K'
    int 0x10
    hlt
    jmp $