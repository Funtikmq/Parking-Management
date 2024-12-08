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
	;
    jmp terminare

iesire:
    mov ah, 09h
    lea dx, msg_2
    int 21h
	;
	;Codul Gabi
	;
    jmp terminare

configurare:
    mov ah, 09h
    lea dx, msg_3
    int 21h
	;
	; Codul Denisa
	;
	
    jmp terminare

anulare:
    mov ah, 09h
    lea dx, msg_4
    int 21h
	
    jmp terminare

terminare:
    mov ah, 4Ch
    int 21h ; Termină programul

code ENDS
end start
