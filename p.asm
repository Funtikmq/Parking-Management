MODEL small
stack [10]

code segment
ASSUME CS:code, DS:data

data segment
    welcome_msg db '	Bine Ati Venit', 0Dh, 0Ah, '$' ; Mesajul de bun venit
    optiune_msg db 'Selectati o Optiune:$'
    op_1 db '1.Intrare In Parcare$'
    op_2 db '2.Iesire din Parcare$'
    op_3 db '3.Configurarea Sistemului$'
    op_4 db '4.Anulare$'
	optiune db 0 ; Variabila pentru a salva opțiunea aleasă
    msg_1 db 'Intrare in Parcare.$'
    msg_2 db 'Iesire din Parcare.$'
    msg_3 db 'Configurarea Sistemului.$'
    msg_4 db 'O zi buna!$'
	msg_5 db '	Optiune invalida!$'
	nr_inmatriculare db 0 ; Variabila pentru a salva numerele de inmatriculare
	
data ends

start:
    mov ax, data
    mov ds, ax 
    
    mov ah, 09h
    lea dx, welcome_msg
    int 21h ; Afișează mesajul de bun venit

    mov ah, 02h
	mov dl, 0dh ; Mută cursorul
	int 21h 

	mov ah, 09h
	lea dx, optiune_msg 
	int 21h ; Afișează mesajul de interogare
	
    citire_optiune:
        mov ah, 02h
        mov dl, 0dh ; Mută cursorul
        int 21h 
        
        mov ah, 02h
        mov dl, 0ah ; Linie Nouă
        int 21h 
        
        mov ah, 09h
        lea dx, op_1
        int 21h
        
        mov ah, 02h
        mov dl, 0dh ; Mută cursorul
        int 21h
        
        mov ah, 02h
        mov dl, 0ah ; Linie Nouă
        int 21h
        
        mov ah, 09h
        lea dx, op_2
        int 21h
        
        mov ah, 02h
        mov dl, 0dh ; Mută cursorul
        int 21h
        
        mov ah, 02h
        mov dl, 0ah ; Linie Nouă
        int 21h
        
        mov ah, 09h
        lea dx, op_3
        int 21h
        
        mov ah, 02h
        mov dl, 0dh ; Mută cursorul
        int 21h
        
        mov ah, 02h
        mov dl, 0ah ; Linie Nouă
        int 21h
        
        mov ah, 09h
        lea dx, op_4
        int 21h
        
        mov ah, 02h
        mov dl, 0ah ; Linie Nouă
        int 21h
        
        ; Citirea Opțiunii De La Tastatură
        mov ah, 01h ; Citire A Unui Caracter
        int 21h
        
        mov [optiune], al ; Stocăm caracterul citit în variabila 'optiune'
        
        mov ah, 02h
        mov dl, 0ah ; Linie Nouă
        int 21h
        
        ; Compară valoarea introdusă și afișează mesajul corespunzător
        mov al, [optiune]  ; Încărcăm valoarea introdusă în AL
        
        cmp al, '1'        
        je intrare        
        
        cmp al, '2'        
        je iesire        
        
        cmp al, '3'        
        je configurare        
        
        cmp al, '4'        
        je anulare        
        
        ; Mesajul de eroare
        mov ah, 09h
        lea dx, msg_5
        int 21h
        
        ; Continuăm să cerem o nouă opțiune
        jmp citire_optiune

intrare:
    mov ah, 09h
    lea dx, msg_1
    int 21h
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

    jmp terminare

iesire:
    mov ah, 09h
    lea dx, msg_2
    int 21h
	;
	;Codul Gabi
	;Introducere numar de inmatriculare
	;Anulare
	;---------------------------------
	;Afișare sumă către plată (Calculează cât timp sa aflat mașina în parcare)
	;Selectie metoda de plata
	;Anulare
	;---------------------------------
	;Plata 
	;
    jmp terminare

configurare:
    mov ah, 09h
    lea dx, msg_3
    int 21h
	;
	; Codul Denisa
	; *Parola*
	; Configurare disponibilitate nivel
	; Configurare metode de plata
	;
	
    jmp terminare

anulare:
    mov ah, 09h
    lea dx, msg_4
    int 21h
	
    jmp terminare

terminare:
    mov ah, 4ch ; Finalizează programul
    int 21h 

code ENDS
end start
