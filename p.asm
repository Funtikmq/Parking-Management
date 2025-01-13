MODEL small
stack [10]

code segment
ASSUME CS:code, DS:data

data segment
    welcome_msg db '	Bine Ati Venit', 0Dh, 0Ah, '$'
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
    msg_nivel db 'Selectati nivelul (1-3):$'
    msg_locuri db 'Locuri disponibile pe nivel:$'
    msg_ocupat db 'Nu mai sunt locuri disponibile pe acest nivel.$'
    msg_timer db 'Ora de intrare a fost inregistrata.$'
    msg_eroare_nivel db 'Nivel invalid! Selectati din nou.$'
    total_locuri db 5, 5, 5 ; Locuri totale pentru 3 niveluri
    locuri_disponibile db 5, 5, 5 ; Locuri disponibile pentru 3 niveluri
    ora_intrare db 0 ; Ora de intrare va fi stocată aici
    nr_inmatriculare db 8 dup(0) ; Variabilă pentru numărul de înmatriculare
	nr_inmatriculare_msg db 'Introduceți numărul de înmatriculare:$'
    valid_number_msg db 'Numărul de înmatriculare este valid.$'
    invalid_format_msg db 'Format greșit! Introduceți din nou.$'
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
je intrare_intermediar

cmp al, '2'
je iesire_intermediar

cmp al, '3'
je configurare_intermediar

cmp al, '4'
je anulare_operatiune

jmp eroare_optiune

intrare_intermediar:
jmp intrare_parcare

iesire_intermediar:
jmp iesire_parcare

configurare_intermediar:
jmp configurare_sistem

eroare_optiune:
mov ah, 09h
lea dx, msg_5
int 21h
jmp citire_optiune

intrare_parcare:
; Logica pentru intrarea în parcare
jmp terminare_intrare

iesire_parcare:
; Logica pentru ieșirea din parcare
jmp terminare_iesire

configurare_sistem:
; Logica pentru configurarea sistemului
jmp terminare_configurare

anulare_operatiune:
; Logica pentru anulare
jmp terminare_anulare

terminare_intrare:
ret

terminare_iesire:
ret

terminare_configurare:
ret

terminare_anulare:
ret


intrare:
    ; Afișăm mesajul pentru intrare în parcare
    mov ah, 09h
    lea dx, msg_1
    int 21h

    ; Introducerea numărului de înmatriculare
    mov ah, 09h
    lea dx, nr_inmatriculare_msg
    int 21h ; Afișăm mesajul de introducere a numărului de înmatriculare

introducere_numar:
    lea si, nr_inmatriculare ; Pregătim locația pentru stocare
    mov cx, 8 ; Numărul total de caractere pentru validare: 2 litere + 2 cifre + 3 litere + 1 spațiu
    xor di, di ; Resetăm indexul pentru nr_inmatriculare

citim_caracter:
    mov ah, 01h ; Citim câte un caracter
    int 21h
    cmp al, 0Dh ; Verificăm dacă utilizatorul a apăsat Enter
    je validare_format
    stosb ; Salvăm caracterul citit în memorie
    inc di ; Incrementăm indexul
    loop citim_caracter

validare_format:
    lea si, nr_inmatriculare ; Pregătim să verificăm formatul
    mov al, [si] ; Primul caracter
    jz format_gresit ; Dacă nu este literă, afișăm eroarea

    inc si
    mov al, [si] ; Al doilea caracter
    jz format_gresit ; Dacă nu este literă, afișăm eroarea

    inc si
    mov al, [si] ; Al treilea caracter (spațiu)
    cmp al, ' '
    jne format_gresit ; Dacă nu este spațiu, afișăm eroarea

    inc si
    mov al, [si] ; Al patrulea caracter (cifră 1)
    jz format_gresit ; Dacă nu este cifră, afișăm eroarea

    inc si
    mov al, [si] ; Al cincilea caracter (cifră 2)
    jz format_gresit ; Dacă nu este cifră, afișăm eroarea

    inc si
    mov al, [si] ; Al șaselea caracter (litera 1)
    jz format_gresit ; Dacă nu este literă, afișăm eroarea

    inc si
    mov al, [si] ; Al șaptelea caracter (litera 2)
    jz format_gresit ; Dacă nu este literă, afișăm eroarea

    inc si
    mov al, [si] ; Al optulea caracter (litera 3)
    jz format_gresit ; Dacă nu este literă, afișăm eroarea

    ; Numărul de înmatriculare este valid
    mov ah, 09h
    lea dx, valid_number_msg
    int 21h ; Afișăm mesaj de validare
    jmp verificare_locuri

format_gresit:
    mov ah, 09h
    lea dx, invalid_format_msg ; Mesaj de eroare
    int 21h
    jmp introducere_numar

verificare_locuri:
    ; Afișăm mesajul pentru selecția nivelului
    mov ah, 09h
    lea dx, msg_nivel
    int 21h

selectare_nivel:
    mov ah, 01h ; Citire nivel de la tastatură
    int 21h
    sub al, '0' ; Convertim caracterul citit în număr (1 -> nivel 1)
    cmp al, 1
    jl eroare_nivel
    cmp al, 3
    jg eroare_nivel

    mov bl, al ; Salvăm nivelul selectat în BL (1-3)
    dec bl ; Convertim nivelul pentru indexare (0-2)
    
    ; Verificăm locurile disponibile
    lea si, locuri_disponibile
    mov al, [si + bx]
    cmp al, 0 ; Verificăm dacă mai sunt locuri disponibile
    je nivel_ocupat

    ; Reducem locurile disponibile
    dec byte ptr [si + bx]

    ; Afișăm mesajul cu locuri disponibile
    mov ah, 09h
    lea dx, msg_locuri
    int 21h
    mov ah, 02h
    add al, '0' ; Convertim numărul în caracter
    mov dl, al
    int 21h

    ; Pornim timerul
    lea si, ora_intrare
    mov byte ptr [si], 10 ; Simulăm ora de intrare (ex. 10:00)
    mov ah, 09h
    lea dx, msg_timer
    int 21h
    jmp terminare_intrare

nivel_ocupat:
    mov ah, 09h
    lea dx, msg_ocupat
    int 21h
    jmp selectare_nivel

eroare_nivel:
    mov ah, 09h
    lea dx, msg_eroare_nivel
    int 21h
    jmp selectare_nivel

terminare:
    ret
	
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


    mov ah, 4ch ; Finalizează programul
    int 21h 

code ENDS
end start