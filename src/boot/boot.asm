bits 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov [boot_drive], dl

    call clear_screen

    mov ah, 0x02
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 0x10

    mov si, boot_msg_title
    call print_tty
    call newline_tty

    mov si, boot_msg_prompt
    call print_tty

.wait_key:
    call read_key
    cmp al, '1'
    jne .wait_key

launch_kernel:
    mov ax, 0x1000
    mov es, ax
    xor bx, bx

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    jmp 0x1000:0x0000

disk_error:
    call clear_screen
    mov si, boot_msg_disk_err
    call print_tty

hang:
    jmp hang

print_tty:
    push ax
.print_loop:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .print_loop
.done:
    pop ax
    ret

newline_tty:
    push ax
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    pop ax
    ret

clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

read_key:
    mov ah, 0x00
    int 0x16
    ret

boot_msg_title    db "LAOS Bootloader", 0
boot_msg_prompt   db "Press 1 to launch kernel...", 0
boot_msg_disk_err db "Disk read error while loading kernel.", 0

boot_drive   db 0

times 510 - ($ - $$) db 0
dw 0xAA55
