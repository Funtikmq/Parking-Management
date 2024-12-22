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
	msg_time db "Introduceti numarul de ore petrecute in parcare: $"
    msg_payment db "Selectati metoda de plata: (1) Cash (2) Card$"
    msg_invalid db "Optiune invalida. Incercati din nou.$"
    msg_total db "Total de plata: $"
    msg_lei db " lei.$"
    payment_cash db "Ati selectat plata cash.$"
    payment_card db "Ati selectat plata cu cardul.$"
	
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
    mov ah, 09h
    lea dx, msg_2
    int 21h
	
	mov ah, 09h
    lea dx, msg_time
    int 21h ; Afiseaza mesaj pentru numarul de ore petrecute
	
	call read_number
    mov [hours], al

    ; Calculare total (pret pe ora = 3 lei)
    mov al, [hours]
    mov bl, 3
    mul bl
    mov [total], al
	
	payment_selection:
    mov ah, 09h
    lea dx, msg_payment
    int 21h ; Afiseaza optiuni de plata

    call read_char
    mov [payment_option], al

    cmp al, '1'
    je payment_cash
    cmp al, '2'
    je payment_card

    mov ah, 09h
    lea dx, msg_invalid
    int 21h ; Optiune invalida
    jmp payment_selection
	
	payment_cash:
    mov ah, 09h
    lea dx, payment_cash
    int 21h
    jmp print_total

payment_card:
    mov ah, 09h
    lea dx, payment_card
    int 21h
    jmp print_total

print_total:
    mov ah, 09h
    lea dx, msg_total
    int 21h

    ; Afiseaza totalul de plata
    mov al, [total]
    call print_number

    mov ah, 09h
    lea dx, msg_lei
    int 21h
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
