shell_cc_meow:
    call get_rand_16bit ; rand into AX

    xor dx, dx  ; reset dx
    mov cx, 4   ; divisor (4 possible outcome)
    div cx

    cmp dx, 0
    je .m0 
    cmp dx, 1
    je .m1
    cmp dx, 2
    je .m2 
    cmp dx, 3
    je .m3

.m0:
    mov si, meow_face1
    jmp .print
.m1:
    mov si, meow_face2
    jmp .print
.m2:
    mov si, meow_face3
    jmp .print
.m3:
    mov si, meow_face4

.print:
    call print_tty
    call newline_tty
    ret

meow_face1 db ">_<", 0
meow_face2 db "OwO", 0
meow_face3 db ">^<", 0
meow_face4 db ">:3", 0