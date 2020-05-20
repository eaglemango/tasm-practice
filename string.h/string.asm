; =============================================================================
; INPUT:  di - pointer to memory block to fill with value
;         al - value to use as filler (byte)
;         cx - number of bytes to fill
;
; OUTPUT: di - pointer to memory block filled with value
; =============================================================================
memset macro
    nop

    push di
    rep stosb
    pop di

    nop
endm

; =============================================================================
; INPUT:  di - pointer to destination memory block
;         si - pointer to source memory block
;         cx - number of bytes to copy
;
; OUTPUT: di - pointer to destination memory block
; =============================================================================
memcpy macro
    nop

    push di
    rep movsb
    pop di

    nop
endm

; =============================================================================
; INPUT:  si - pointer to source memory block
;         al - value to find (byte)
;         cx - size of memory block
;
; OUTPUT: di - pointer to first value occurence
; =============================================================================
memchr macro
    nop

    mov di, si

    memchr_inner_loop:
        cmp [di], al
        je memchr_success

        inc di

        loop memchr_inner_loop

    memchr_fail:
        xor di, di
    
    memchr_success:
        nop

    nop
endm

; =============================================================================
; INPUT:  si - pointer to first memory block
;         di - pointer to second memory block
;         cx - number of bytes to be compared
;
; OUTPUT: ax - 0 if blocks are equal
; =============================================================================
memcmp macro
    nop

    memcmp_inner_loop:
        mov al, [si]
        cmp [di], al
        jne memcmp_fail

        inc si
        inc di

        loop memcmp_inner_loop
    
    xor ax, ax
    jmp memcmp_success

    memcmp_fail:
        mov ax, 1

    memcmp_success:
        nop

    nop
endm

; =============================================================================
; INPUT: si - pointer to string ending with \0 
;
; OUPUT: ax - lenght of string
; =============================================================================
strlen macro
    nop

    xor ax, ax

    strlen_inner_loop:
        cmpsb [si], 0h
        je strlen_success

        inc si
        inc ax

        jmp strlen_inner_loop

    strlen_success:
        nop

    nop
endm

; =============================================================================
; INPUT:  di - pointer to destination string
;         si - pointer to source string 
;
; OUTPUT: di - pointer to destination string
; =============================================================================
strcpy macro
    nop

    push si
    strlen
    pop si

    mov cx, ax
    inc cx

    memcpy

    nop
endm

; =============================================================================
; INPUT:  si - pointer to string
;         al - value to find (symbol byte)
;
; OUTPUT: di - pointer to first value occurence
; =============================================================================
strchr macro
    nop

    push ax

    push si
    strlen
    pop si

    mov cx, ax

    pop ax

    memchr

    nop
endm

; =============================================================================
; INPUT:  si - pointer to first string
;         di - pointer to second string
;
; OUTPUT: ax - 0 if strings are equal,
;              >0 if first string is greater
;              <0 if second string is greater
; =============================================================================
strcmp macro
    nop

    strcmp_inner_loop:
        mov al, [si]
        cmp [di], al
        jne strcmp_fail

        inc si
        inc di

        cmp al, 0
        je strcmp_success

        loop strcmp_inner_loop
    
    jmp strcmp_success

    strcmp_fail:
        cmp [di], al
        jb strcmp_greater

        mov ax, -1
        jmp strcmp_success

    strcmp_greater:
        mov ax, 1

    strcmp_success:
        nop

    nop
endm
