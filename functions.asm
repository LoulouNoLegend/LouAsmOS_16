newline_tty:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

read_key:
    mov ah, 0x00
    int 0x16
    ret

clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

;---------------------------
print_tty:
    mov ah, 0x0E
    .print_loop:
        lodsb
        cmp al, 0
        je done
        int 0x10
        jmp .print_loop

print_attr:
    mov byte [color_x], 0
    .print_attr_loop:
        lodsb
        cmp al, 0
        je done

        mov ah, 0x02
        mov bh, 0
        mov dh, 0
        mov dl, [color_x]
        int 0x10

        mov ah, 0x09
        mov bh, 0
        mov cx, 1
        int 0x10

        inc byte [color_x]

        jmp .print_attr_loop

done:
    ret

;---------------------------
;---------------------------

color_x db 0