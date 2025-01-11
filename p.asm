MODEL small
stack 100h

data segment
    welcome_msg db 'Bine Ati Venit', 0Dh, 0Ah, '$'
    optiune_msg db 'Selectati o Optiune:', 0Dh, 0Ah, '$'
    op_1 db '1. Intrare In Parcare', 0Dh, 0Ah, '$'
    op_2 db '2. Iesire din Parcare', 0Dh, 0Ah, '$'
    op_3 db '3. Configurarea Sistemului', 0Dh, 0Ah, '$'
    op_4 db '4. Anulare', 0Dh, 0Ah, '$'
    optiune db 0
    msg_1 db ' Intrare in Parcare.', 0Dh, 0Ah, '$'
    msg_2 db ' Iesire din Parcare.', 0Dh, 0Ah, '$'
    msg_3 db ' Configurarea Sistemului.', 0Dh, 0Ah, '$'
    msg_4 db ' O zi buna!', 0Dh, 0Ah, '$'
    msg_5 db ' Optiune invalida!', 0Dh, 0Ah, '$'
    nr_inmatriculare db 7 dup(?)
    nivel_ales db 0
    msg_intr_nr db 'Introduceti numarul de inmatriculare:', 0Dh, 0Ah, '$'
    msg_select_lvl db 'Alegeti nivelul (1-4):', 0Dh, 0Ah, '$'
    msg_succes db ' Intrare inregistrata cu succes!', 0Dh, 0Ah, '$'
    msg_invalid_lvl db ' Nivel invalid! Incercati din nou.', 0Dh, 0Ah, '$'
    msg_no_space db ' Nivel complet! Alegeti alt nivel.', 0Dh, 0Ah, '$'
    msg_metoda_plata db 'Selectati metoda de plata (1. Cash, 2. Card):', 0Dh, 0Ah, '$'
    msg_plata_cash db ' Plata cash efectuata cu succes.', 0Dh, 0Ah, '$'
    msg_plata_card db ' Plata cu cardul efectuata cu succes.', 0Dh, 0Ah, '$'
    msg_iesire_succes db ' Iesire inregistrata cu succes. Va multumim!', 0Dh, 0Ah, '$'
    parcare db 4 dup(0)

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
    je intrare_call      
    
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

intrare_call:
    call intrare
    jmp terminare

iesire_call:
    call iesire
    jmp terminare

configurare_call:
    call configurare
    jmp terminare

anulare_call:
    call anulare
    jmp terminare

citire_optiune endp

intrare proc
    ; Mesaj pentru intrare în parcare
    mov ah, 09h
    lea dx, msg_1
    int 21h

    ; Mesaj pentru introducerea numărului de înmatriculare
    mov ah, 09h
    lea dx, msg_intr_nr
    int 21h

    ; Citirea numărului de înmatriculare
    lea di, nr_inmatriculare 
    mov cx, 7 

citire_nr:
    mov ah, 01h 
    int 21h
    mov [di], al 
    inc di 
    loop citire_nr 

    ; Linie nouă după introducerea numărului
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    ; Mesaj pentru selectarea nivelului
    mov ah, 09h
    lea dx, msg_select_lvl
    int 21h

    ; Citirea nivelului selectat
    mov ah, 01h 
    int 21h
    sub al, '0' 
    cmp al, 1
    jl invalid_lvl 
    cmp al, 4
    jg invalid_lvl 

    ; Salvarea nivelului selectat
    mov nivel_ales, al

    ; Verificarea disponibilității nivelului
    lea si, parcare 
    dec al          
    xor bx, bx      ; Resetează BX înainte de utilizare
    mov bl, al      
    mov al, [si+bx] 
    cmp al, 4       
    jge no_space    

    ; Incrementarea locurilor ocupate pe nivel
    inc byte ptr [si+bx]

    ; Mesaj de succes
    mov ah, 09h
    lea dx, msg_succes
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

no_space:
    ; Mesaj pentru nivel complet
    mov ah, 09h
    lea dx, msg_no_space
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp intrare 

invalid_lvl:
    ; Mesaj pentru nivel invalid
    mov ah, 09h
    lea dx, msg_invalid_lvl
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp intrare 

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

    ; Mesaj pentru selectarea metodei de plată
    mov ah, 09h
    lea dx, msg_metoda_plata
    int 21h

    ; Citirea opțiunii de plată
    mov ah, 01h
    int 21h
    cmp al, '1'
    je cash_payment
    cmp al, '2'
    je card_payment

    ; Mesaj pentru opțiune invalidă
    mov ah, 09h
    lea dx, msg_5
    int 21h

    ; Linie nouă după mesaj
    mov ah, 02h
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h

    jmp citire_optiune

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

    jmp citire_optiune

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

    jmp citire_optiune

iesire endp



configurare proc
    mov ah, 09h
    lea dx, msg_3
    int 21h
    jmp citire_optiune
configurare endp

anulare proc
    mov ah, 09h
    lea dx, msg_4
    int 21h
    jmp terminare
anulare endp

code ENDS
end start
