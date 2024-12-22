; Introducere numar de inmatriculare
intrare_numar:
    lea dx, 'Introduceti numarul de inmatriculare (ex: BV30MAD): $'
    mov ah, 09h
    int 21h

    lea dx, nr_inmatriculare
    mov ah, 0Ah
    int 21h

    ; Validare format numar de inmatriculare
validare_format:
    lea si, nr_inmatriculare+1 ; Ignoram primul byte (lungimea inputului)
    mov cl, byte ptr [nr_inmatriculare+1] ; Lungimea efectiva a inputului
    cmp cl, 7 ; Verificam daca lungimea este exact 7 caractere
    jne format_invalid

    ; Verificam primele 2 caractere (litere mari)
    mov al, [si]
    cmp al, 'A'
    jb format_invalid
    cmp al, 'Z'
    ja format_invalid

    inc si
    mov al, [si]
    cmp al, 'A'
    jb format_invalid
    cmp al, 'Z'
    ja format_invalid

    inc si
    ; Verificam urmatoarele 2 caractere (cifre)
    mov al, [si]
    cmp al, '0'
    jb format_invalid
    cmp al, '9'
    ja format_invalid

    inc si
    mov al, [si]
    cmp al, '0'
    jb format_invalid
    cmp al, '9'
    ja format_invalid

    inc si
    ; Verificam ultimele 3 caractere (litere mari)
    mov al, [si]
    cmp al, 'A'
    jb format_invalid
    cmp al, 'Z'
    ja format_invalid

    inc si
    mov al, [si]
    cmp al, 'A'
    jb format_invalid
    cmp al, 'Z'
    ja format_invalid

    inc si
    mov al, [si]
    cmp al, 'A'
    jb format_invalid
    cmp al, 'Z'
    ja format_invalid

    jmp selectie_nivel ; Format valid, trecem mai departe

format_invalid:
    lea dx, 'Format gresit! Introduceti din nou: $'
    mov ah, 09h
    int 21h
    jmp intrare_numar

    ; Anulare
anulare:
    lea dx, 'Operatiune anulata.$'
    mov ah, 09h
    int 21h
    jmp terminare_intrare

; Selectie nivel (Verifică dacă sunt locuri disponibile)
selectie_nivel:
    lea si, locuri_totale
    lea di, locuri_ocupate
    mov cx, 4
nivel_loop:
    mov al, [si]
    sub al, [di]
    cmp al, 0
    jg loc_disponibil
    add si, 1
    add di, 1
    loop nivel_loop

    lea dx, 'Ne pare rau, nu sunt locuri disponibile.$'
    mov ah, 09h
    int 21h
    jmp anulare_intrare

loc_disponibil:
    lea dx, 'Selectati nivelul (1-4): $'
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '1'
    mov bl, al
    mov al, [locuri_ocupate+bx]
    inc al
    mov [locuri_ocupate+bx], al

    lea dx, 'Loc rezervat cu succes.$'
    mov ah, 09h
    int 21h
    jmp terminare_intrare

anulare_intrare:
    lea dx, 'Operatiune anulata.$'
    mov ah, 09h
    int 21h

terminare_intrare:
    ; Pornește Timerul (Salvează ora la care a intrat)
    lea dx, 'Ora de intrare a fost salvata.$'
    mov ah, 09h
    int 21h
