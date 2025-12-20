shell_cc_meow:
    mov si, meow_face
    call print_tty
    call newline_tty
    ret

meow_face db ">_<", 0
