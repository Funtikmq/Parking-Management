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
	
    msg_inmatriculare db 'Introduceti numarul de inmatriculare: $'
	
    msg_invalid_plate db 'Numar invalid! Introduceti un numar valid: $'
	nr_inmatriculare db 0 ; Variabila pentru a salva numerele de inmatriculare
	license_plate db 10, 0, 12 dup('$') ; Buffer configurat corect pentru citire (10 maxim, 0 lungime inițială)
    license_msg db 'Introduceti numarul de inmatriculare (e.g., BV67JJH):$'
    license_error db 'Numar invalid. Reincercati.$'
    license_success db 'Numar inmatriculare acceptat.$'
    msg_ore db 'Introduceti numarul de ore petrecute in parcare: $'
    msg_suma db 'Suma de plata este: LEI $'
    msg_metoda_plata db 'Selectati metoda de plata (1: Cash, 2: Card): $'
    msg_invalid db 'Optiune invalida! Reincercati.$'
    msg_plata_cash db 'Ati selectat plata cash. Multumim! $'
    msg_plata_card db 'Ati selectat plata cu cardul. Multumim! $'
    newline db 0Dh, 0Ah, '$'
	

    ore db 0
    suma dw 0
    metoda_plata db ?
    
	
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
        jmp configurare        
        
        cmp al, '4'        
        jmp anulare        
        
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
	;
	;Codul Madalin 
	;Introducere numar de inmatriculare
	;Anulare
	;---------------------------------
	;Selectie nivel (Verifică dacă sunt locuri disponibile)
	;Anulare
	;---------------------------------
	;Pornește Timerul (Salvează ora la care a intrat)
	;
    jmp terminare

iesire:
    
	; Segment de cod pentru validarea numărului de înmatriculare
citire_inmatriculare:
    ; Cerere pentru numarul de inmatriculare
    mov ah, 09h
    lea dx, license_msg
    int 21h

    ; Citire numar de inmatriculare
    lea dx, license_plate ; Incarca bufferul pentru citire
    mov ah, 0Ah ; Functia DOS pentru citirea unui buffer
    int 21h

    ; Validare numar de inmatriculare
    mov al, license_plate[1] ; Al doilea octet contine lungimea introdusa
    cmp al, 3 ; Minim 3 caractere
    jl invalid_input
    cmp al, 7 ; Maxim 7 caractere
    jg invalid_input

    ; Mesaj de succes
    mov ah, 09h
    lea dx, license_success
    int 21h

    jmp continuare_program

invalid_input:
    ; Mesaj de eroare
    mov ah, 09h
    lea dx, license_error
    int 21h
    jmp citire_inmatriculare

continuare_program:
    
    ; Continuă cu restul programului

    ; Afișare mesaj pentru numărul de ore
    mov ah, 09h
    lea dx, msg_ore
    int 21h

    ; Citire număr de ore
    mov ah, 01h
    int 21h
    sub al, '0' ; Conversie ASCII -> număr
    mov ore, al

    ; Calculare sumă (2 lei/oră)
    mov al, ore
    mov ah, 0
    mov bl, 2
    mul bl ; AX = AL * BL
    mov suma, ax

    ; Afișare suma de plată
    mov ah, 09h
    lea dx, msg_suma
    int 21h

    ; Conversie suma în ASCII și afișare
    mov ax, suma
    call print_number

    ; Linie nouă
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Selectare metodă de plată
    mov ah, 09h
    lea dx, msg_metoda_plata
    int 21h

    ; Citire metodă de plată
    mov ah, 01h
    int 21h
    mov metoda_plata, al

    cmp al, '1'
    je plata_cash
    cmp al, '2'
    je plata_card

    ; Mesaj pentru opțiune invalidă
    mov ah, 09h
    lea dx, msg_invalid
    int 21h
    jmp iesire ; Revenire la început

plata_cash:
    mov ah, 09h
    lea dx, msg_plata_cash
    int 21h
    jmp finalizare

plata_card:
    mov ah, 09h
    lea dx, msg_plata_card
    int 21h
    jmp finalizare

finalizare:
    ret

; Subrutina pentru afișarea unui număr
print_number proc
    push ax
    push bx
    push cx
    push dx

    xor cx, cx
convert_digit:
    xor dx, dx
    mov bx, 10
    div bx ; AX = AX / 10, DX = rest
    push dx
    inc cx
    test ax, ax
    jnz convert_digit

print_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp

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