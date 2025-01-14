MODEL small
stack 100h

data segment
    welcome_msg db 'Bine ati Venit', 0Dh, 0Ah, '$'
    optiune_msg db 'Selectati o Optiune:', 0Dh, 0Ah, '$'
    op_1 db '1.Intrare in Parcare', 0Dh, 0Ah, '$'
    op_2 db '2.Iesire din Parcare', 0Dh, 0Ah, '$'
    op_3 db '3.Configurarea Sistemului', 0Dh, 0Ah, '$'
    op_4 db '4.Anulare', 0Dh, 0Ah, '$'
    optiune db 0
    msg_1 db '-Intrare in Parcare.', 0Dh, 0Ah, '$'
    msg_2 db '-Iesire din Parcare.', 0Dh, 0Ah, '$'
    msg_3 db '-Configurarea Sistemului.', 0Dh, 0Ah, '$'
    msg_4 db ' O Zi Buna!', 0Dh, 0Ah, '$'
    msg_5 db '-Optiune Invalida!', 0Dh, 0Ah, '$'
    nr_inmatriculare db 7 dup(?)
    nivel_ales db 0
    msg_intr_nr db 'Introduceti Numarul de Inmatriculare:', 0Dh, 0Ah, '$'
    msg_select_lvl db 'Alegeti Nivelul (1-4):', 0Dh, 0Ah, '$'
    msg_succes db ' Intrare Inregistrata cu Succes!', 0Dh, 0Ah, '$'
    msg_invalid_lvl db '-Nivel Invalid! Incercati din Nou.', 0Dh, 0Ah, '$'
    msg_no_space db ' Nivel Complet! Alegeti alt Nivel.', 0Dh, 0Ah, '$'
    msg_metoda_plata db 'Selectati Metoda de Plata (1. Cash, 2. Card):', 0Dh, 0Ah, '$'
    msg_plata_cash db '-Plata Cash Efectuata cu Succes.', 0Dh, 0Ah, '$'
    msg_plata_card db '-Plata cu Cardul Efectuata cu Succes.', 0Dh, 0Ah, '$'
    msg_iesire_succes db 'Iesire Inregistrata cu Succes. Va Multumim!', 0Dh, 0Ah, '$'
    msg_config_1 db '1.Modificare Disponibilitate Nivele', 0Dh, 0Ah, '$'
    msg_config_2 db '2.Modificare Metoda de Plata', 0Dh, 0Ah, '$'
    msg_config_3 db '3.Spre Ecranul Principal', 0Dh, 0Ah, '$'
    msg_disp_lvl db '-Nivel marcat Disponibil.', 0Dh, 0Ah, '$'
    msg_indisp_lvl db '-Nivel marcat Indisponibil.', 0Dh, 0Ah, '$'
    msg_disp_check db '-Nivel Indisponibil! Alegeti alt Nivel.', 0Dh, 0Ah, '$'
    msg_optiune_indisp db '-Intrarea este Indisponibila! Toate Metodele de Plata Sunt Dezactivate.', 0Dh, 0Ah, '$'
	msg_nivel_indisp db '-Intrarea este Indisponibila! Toate Nivelele Sunt Ocupate.', 0Dh, 0Ah, '$'
    parcare db 4 dup(0)
    disponibilitate db 4 dup(1) ; 1 = disponibil, 0 = indisponibil
    disponibilitate_plata db 2 dup(1) ; 1 = disponibil, 0 = indisponibil
    msg_indisp_plata db '-Metoda de Plata Este Indisponibila', 0Dh, 0Ah, '$'
    msg_disp_plata db '-Metoda de Plata Este Disponibila', 0Dh, 0Ah, '$'

data ends

code segment
ASSUME CS:code, DS:data

start:
    mov ax, data
    mov ds, ax 

    mov ah, 09h
    lea dx, welcome_msg
    int 21h 

    mov ah, 09h
    lea dx, optiune_msg 
    int 21h 

    call citire_optiune

terminare:
    mov ah, 4ch 
    int 21h 

citire_optiune proc
    mov ah, 09h
    lea dx, op_1
    int 21h

    mov ah, 09h
    lea dx, op_2
    int 21h

    mov ah, 09h
    lea dx, op_3
    int 21h

    mov ah, 09h
    lea dx, op_4
    int 21h

    mov ah, 01h
    int 21h

    mov optiune, al 

    cmp al, '1'        
    je verificare_nivele_ocupate ; Mutăm verificarea înainte de introducerea numărului

    cmp al, '2'        
    je iesire_call       

    cmp al, '3'        
    je configurare_call  

    cmp al, '4'        
    je anulare_call      

    mov ah, 09h
    lea dx, msg_5
    int 21h

    jmp citire_optiune

verificare_nivele_ocupate:
    lea si, parcare
    mov cx, 4
    xor al, al ; Al inițializat la 0 pentru a număra spațiile ocupate

verificare_ocupare:
    add al, [si]
    inc si
    loop verificare_ocupare

    cmp al, 8 ; Fiecare nivel poate avea maximum 2 mașini, deci 4 nivele ocupate = 8 mașini
    je toate_nivelele_ocupate

    jmp intrare_call

toate_nivelele_ocupate:
    mov ah, 09h
    lea dx, msg_nivel_indisp
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

intrare_call:
    call intrare
    jmp terminare

iesire_call:
    call iesire
    jmp terminare

configurare_call:
    call configurare
    jmp citire_optiune

anulare_call:
    call anulare
    jmp terminare

citire_optiune endp

intrare proc
    ; Verificare metode de plată disponibile
    lea si, disponibilitate_plata
    mov cx, 2 ; Două metode de plată (cash și card)
    xor al, al ; AL inițializat la 0 pentru a număra metodele disponibile

verificare_plata:
    add al, [si] ; Adăugă valoarea metodei curente (1 = disponibil, 0 = indisponibil)
    inc si
    loop verificare_plata

    cmp al, 0 ; Dacă nicio metodă nu este disponibilă
    jne continuare_verificare_nivele ; Sari dacă cel puțin o metodă este disponibilă

    jmp toate_metodele_indisponibile ; Salt lung pentru eticheta respectivă

continuare_verificare_nivele:
    ; Verificare nivele disponibile
    lea si, disponibilitate
    mov cx, 4 ; Patru nivele
    xor al, al ; AL inițializat la 0 pentru a număra nivelele disponibile

verificare_nivele:
    add al, [si] ; Adăugă valoarea nivelului curent (1 = disponibil, 0 = indisponibil)
    inc si
    loop verificare_nivele

    cmp al, 0 ; Dacă niciun nivel nu este disponibil
    jne continuare_intrare ; Sari dacă cel puțin un nivel este disponibil

    jmp toate_nivelele_indisponibile ; Salt lung pentru eticheta respectivă

continuare_intrare:
    ; Continuă cu procesul de intrare
    mov ah, 09h
    lea dx, msg_1
    int 21h

    ; Linie nouă după mesajul introductiv
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    mov ah, 09h
    lea dx, msg_intr_nr
    int 21h

    lea di, nr_inmatriculare
    mov cx, 7

citire_nr:
    mov ah, 01h
    int 21h
    mov [di], al
    inc di
    loop citire_nr

    ; Linie nouă înainte de selectarea nivelului
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

selectare_nivel:
    mov ah, 09h
    lea dx, msg_select_lvl
    int 21h

    mov ah, 01h 
    int 21h
    sub al, '0' 
    cmp al, 1
    jl invalid_lvl 
    cmp al, 4
    jg invalid_lvl 

    mov nivel_ales, al

    lea si, disponibilitate
    dec al
    mov bl, al
    mov al, [si+bx]
    cmp al, 0
    je indisponibil_lvl

    lea si, parcare 
    mov al, [si+bx]
    cmp al, 2
    jge no_space    

    inc byte ptr [si+bx]

    mov ah, 09h
    lea dx, msg_succes
    int 21h

    ; Linie nouă după mesajul de succes
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

no_space:
    mov ah, 09h
    lea dx, msg_no_space
    int 21h

    ; Linie nouă după mesajul de eroare
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp selectare_nivel

invalid_lvl:
    mov ah, 09h
    lea dx, msg_invalid_lvl
    int 21h

    ; Linie nouă după mesajul de eroare
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp selectare_nivel

indisponibil_lvl:
    mov ah, 09h
    lea dx, msg_disp_check
    int 21h

    ; Linie nouă după mesajul de eroare
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp selectare_nivel

    ; Afișare mesaj pentru metode de plată indisponibile

toate_metodele_indisponibile:
    mov ah, 09h
    lea dx, msg_optiune_indisp
    int 21h

    ; Linie nouă după mesajul de eroare
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

    ; Afișare mesaj pentru toate nivelele indisponibile

toate_nivelele_indisponibile:
    mov ah, 09h
    lea dx, msg_nivel_indisp
    int 21h

    ; Linie nouă după mesajul de eroare
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

intrare endp


iesire proc
    ; Mesaj pentru iesire din parcare
    mov ah, 09h
    lea dx, msg_2
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    ; Mesaj pentru introducerea numărului de înmatriculare
    mov ah, 09h
    lea dx, msg_intr_nr
    int 21h

    ; Citirea numărului de înmatriculare
    lea di, nr_inmatriculare 
    mov cx, 7 

citire_nr_iesire:
    mov ah, 01h 
    int 21h
    mov [di], al 
    inc di 
    loop citire_nr_iesire 

    ; Linie nouă după introducerea numărului
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

selectare_metoda_plata:
    ; Mesaj pentru selectarea metodei de plată
    mov ah, 09h
    lea dx, msg_metoda_plata
    int 21h

    ; Citirea opțiunii de plată
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    jl optiune_invalida_plata
    cmp al, 2
    jg optiune_invalida_plata

    lea si, disponibilitate_plata
    dec al
    mov bl, al
    cmp byte ptr [si+bx], 1
    je metoda_disponibila

    ; Mesaj pentru metoda de plată indisponibilă
    mov ah, 09h
    lea dx, msg_indisp_plata
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp selectare_metoda_plata

metoda_disponibila:
    cmp bl, 0
    je cash_payment
    cmp bl, 1
    je card_payment

optiune_invalida_plata:
    mov ah, 09h
    lea dx, msg_5
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp selectare_metoda_plata

cash_payment:
    ; Procesare plată cash
    mov ah, 09h
    lea dx, msg_plata_cash
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp iesire_succes

card_payment:
    ; Procesare plată card
    mov ah, 09h
    lea dx, msg_plata_card
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp iesire_succes

iesire_succes:
    ; Confirmarea ieșirii și afișarea unui mesaj de succes
    mov ah, 09h
    lea dx, msg_iesire_succes
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

iesire endp

configurare proc
    mov ah, 09h
    lea dx, msg_3
    int 21h
	
	mov ah,02h
	mov dl, 0Dh ; Carriage return
	int 21h
	
	mov dl,0Ah	; Line feed
	int 21h

	;Selecția opțiunii de configurare
	mov ah, 09h
    lea dx, msg_config_1
    int 21h

	mov ah, 09h
    lea dx, msg_config_2
    int 21h

    mov ah, 09h
    lea dx, msg_config_3
    int 21h

	mov ah, 01h ; citirea optiunii de la tastatura
    int 21h
	
	; Verificarea opțiunii selectate
	sub al, '0'
	cmp al, 1
	je selectare_config_nivel
	cmp al, 2
	jne skip_configurare_metoda
	jmp configurare_metoda_plata
	skip_configurare_metoda:
    cmp al, 3
    je anulare_configurare
	
	; Daca optiunea nu este valida, afisam mesaj si reluam selectia
anulare_configurare:
	mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
	
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

invalid_option:
    mov ah, 09h
    lea dx, msg_5
	int 21h
	
	mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
	
    mov dl, 0Ah ; Line feed
    int 21h
	
	jmp configurare

;Configurarea disponibilității nivelelor
selectare_config_nivel:

	mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
	
    mov dl, 0Ah ; Line feed
    int 21h

    mov ah, 09h
    lea dx, msg_select_lvl
    int 21h

    mov ah, 01h ; citirea optiunii de la tastatura
    int 21h
	
    sub al, '0'
    cmp al, 1
    jl invalid_lvl_config
    cmp al, 4
    jg invalid_lvl_config

    lea si, disponibilitate
    dec al
    mov bl, al
    mov al, [si+bx]
    xor al, 1
    mov [si+bx], al

    cmp al, 1
    je nivel_disponibil

nivel_indisponibil:
    mov ah, 09h
    lea dx, msg_indisp_lvl
    int 21h

    ; Linie nouă după mesajul de indisponibilitate
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp configurare

nivel_disponibil:
    mov ah, 09h
    lea dx, msg_disp_lvl
    int 21h

    ; Linie nouă după mesajul de disponibilitate
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp configurare

invalid_lvl_config:
    mov ah, 09h
    lea dx, msg_invalid_lvl
    int 21h

    ; Linie nouă după mesajul de nivel invalid
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
	
    mov dl, 0Ah ; Line feed
    int 21h

    jmp selectare_config_nivel

; Configurarea metodei de plată
configurare_metoda_plata:
	mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
	
    mov dl, 0Ah ; Line feed
    int 21h

    mov ah, 09h
    lea dx, msg_metoda_plata
    int 21h

    mov ah, 01h ; citirea opțiunii de la tastatură
    int 21h

    sub al, '0'
    cmp al, 1
    jl invalid_metoda_config
    cmp al, 2
    jg invalid_metoda_config

    lea si, disponibilitate_plata
    dec al
    mov bl, al
    mov al, [si+bx]
    xor al, 1
    mov [si+bx], al

    cmp al, 1
    je metoda_disponibila_config

metoda_indisponibila_config:
    mov ah, 09h
    lea dx, msg_indisp_plata
    int 21h

    ; Linie nouă
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp configurare

metoda_disponibila_config:
    mov ah, 09h
    lea dx, msg_disp_plata
    int 21h

    ; Linie nouă
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp configurare

invalid_metoda_config:
    mov ah, 09h
    lea dx, msg_5
    int 21h

    ; Linie nouă
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
	
    mov dl, 0Ah ; Line feed
    int 21h

    jmp configurare_metoda_plata

configurare endp

anulare proc
    mov ah, 09h
    lea dx, msg_4
    int 21h
    jmp terminare
anulare endp

code ENDS
end start