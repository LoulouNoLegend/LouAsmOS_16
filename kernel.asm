; LAOS kernel v0
; Loaded at 0x1000:0000 by bootloader

bits 16
org 0x0000

kernel_start:
    ; Reset the stack and all
    cli
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFF0  ; Simple stack inside the segment
    sti

    call clear_screen

    ; Reset cursor and print text
    mov ah, 0x02
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 0x10

    mov si, msg_is_running
    call print_tty

    jmp $

;---------------------------

%include "functions.asm"

msg_is_running db "LAOS kernel is now running, but there's nothing here yet! x_x", 0

times 512 - ($ - $$) db 0