.model tiny

.code
        org 100h

start:
level1:
        mov dx, offset greetings
        call print_string

        mov dx, offset newline
        call print_string

        ; get string from keyboard
        mov dx, offset buffer
        mov ah, 0ah ; print to buffer
        int 21h
        
        ; get string length
        mov si, offset buffer ; pointer to buffer structure
        inc si ; pointer to buffer length
        xor cx, cx
        mov cl, byte ptr [si] ; put string length in cx

        ; put $ (EOF) in the end of input string
        inc si ; pointer to buffer
        add si, cx ; go to end of buffer
        xor ax, ax
        mov al, '$'
        mov byte ptr [si], al ; put $ symbol

        mov dx, offset newline
        call print_string

        mov di, offset buffer
        add di, 2

        mov si, offset password1

        call strcmp

        cmp ax, 1
        je level2

        jmp babah

level2:
        mov dx, offset rot888888
        call print_string

        mov dx, offset newline
        call print_string

        ; get string from keyboard
        mov dx, offset buffer
        mov ah, 0ah ; print to buffer
        int 21h
        
        ; get string length
        mov si, offset buffer ; pointer to buffer structure
        inc si ; pointer to buffer length
        xor cx, cx
        mov cl, byte ptr [si] ; put string length in cx

        ; put $ (EOF) in the end of input string
        inc si ; pointer to buffer
        add si, cx ; go to end of buffer
        xor ax, ax
        mov al, '$'
        mov byte ptr [si], al ; put $ symbol

        mov dx, offset newline
        call print_string

        mov di, offset buffer
        add di, 2

        xor ax, ax
        mov al, 8

        call rot

        mov si, offset password2

        call strcmp

        cmp ax, 1
        je level3

        jmp babah

level3:
        mov dx, offset xorordies
        call print_string

        mov dx, offset newline
        call print_string

        ; get string from keyboard
        mov dx, offset buffer
        mov ah, 0ah ; print to buffer
        int 21h
        
        ; get string length
        mov si, offset buffer ; pointer to buffer structure
        inc si ; pointer to buffer length
        xor cx, cx
        mov cl, byte ptr [si] ; put string length in cx

        ; put $ (EOF) in the end of input string
        inc si ; pointer to buffer
        add si, cx ; go to end of buffer
        xor ax, ax
        mov al, '$'
        mov byte ptr [si], al ; put $ symbol

        mov dx, offset newline
        call print_string

        mov di, offset buffer
        add di, 2

        xor ax, ax
        mov al, 2
        
        call xorstring

        mov si, offset password3

        call strcmp

        cmp ax, 1
        je level4

        jmp babah

level4:
        mov dx, offset timetodie
        call print_string

        mov dx, offset newline
        call print_string

        ; get string from keyboard
        mov dx, offset buffer
        mov ah, 0ah ; print to buffer
        int 21h
        
        ; get string length
        mov si, offset buffer ; pointer to buffer structure
        inc si ; pointer to buffer length
        xor cx, cx
        mov cl, byte ptr [si] ; put string length in cx

        ; put $ (EOF) in the end of input string
        inc si ; pointer to buffer
        add si, cx ; go to end of buffer
        xor ax, ax
        mov al, '$'
        mov byte ptr [si], al ; put $ symbol

        mov dx, offset newline
        call print_string

        mov di, offset buffer
        add di, 2

        call getbin

        push dx

        mov ah, 2 ; функция BIOS для получения текущего времени
        int 1ah

        xor ax, ax
        mov al, ch ; часы

        pop dx

        cmp ax, dx
        je ezwin

        jmp babah 

ezwin:
        mov dx, offset turnedoff
        call print_string

        ; exit program
        mov ah, 00h ; exit
        int 21h

babah:
        mov dx, offset explosion
        call print_string

        ; exit program
        mov ah, 00h ; exit
        int 21h

; print string from dx
print_string proc
        mov ah, 09h ; print string
        int 21h

        ret
print_string endp

; compare strings from di and si
strcmp proc
strcmp_loop:
        mov al, byte ptr [di]
        mov bl, byte ptr [si]

        cmp al, bl
        jne strcmp_not_equal

        cmp al, '$'
        je strcmp_equal

        inc di
        inc si

        jmp strcmp_loop

strcmp_not_equal:
        xor ax, ax
        ret

strcmp_equal:
        mov ax, 1
        ret
strcmp endp

; increments string from di with al byte
rot proc
        mov si, di
rot_loop:
        mov bl, byte ptr [si]
        cmp bl, '$'
        je rot_return

        sub bl, al
        mov byte ptr [si], bl

        inc si

        jmp rot_loop

rot_return:
        ret
rot endp

; xors string from di with al byte
xorstring proc
        mov si, di
xorstring_loop:
        mov bl, byte ptr [si]
        cmp bl, '$'
        je xorstring_return

        xor bl, al
        mov byte ptr [si], bl

        inc si

        jmp xorstring_loop

xorstring_return:
        ret

xorstring endp

getbin proc
        xor bx, bx
        xor dx, dx
getbin_loop:
        mov bl, byte ptr [di]
        cmp bl, '$'
        je getbin_return

        sub bx, 48

        shl dx, 1
        add dx, bx

        inc di

        jmp getbin_loop

getbin_return:
        ret


getbin endp

.data
        newline db 0ah, '$'

        ; buffer structure for keyboard input
        buffer db 100        ; max input string size
               db ?          ; input string size
               db 100 dup(0) ; reserved space for string

        turnedoff db 'YOU DID IT, HACKERMAN!', '$'
        explosion db 'BOOOOOOOM!', '$'

        greetings db 'Bomb is ready to explode! Quickly enter first code:', '$'
        password1 db 'DOS', '$'

        rot888888 db 'Duck! It still works, you need one more password: ', '$'
        password2 db 'KEK', '$'

        xorordies db 'Seems you need some secret key for this password:', '$'
        password3 db 'Not really a password', '$'

        timetodie db 'TIME to die. Or not? Do you have password?', '$'
        password4 db 'Get out of here', '$'

end start
