rand_seed dw 12345

get_rand_16bit:
    push dx     ; save dx on the stack
    mov ax, [rand_seed] ; copies the seed from memory into AX

    mov dx, 0x6255      ; Put constant multiplier in DX
    mul dx              ; Multiply AX by DX
    add ax, 0x3619      ; AX = AX + increment (mod 65536)

    xor ax, dx          ; mix high word into low word (i saw it was better for LCG)
    mov [rand_seed], ax ; save new value in memory

    pop dx      ; Restore DX
    ret