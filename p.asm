MODEL small
stack [10]

code segment
ASSUME CS:code, DS:data

data segment
    welcome_msg db '\tBine Ati Venit', 0Dh, 0Ah, '$' ; Mesajul de bun venit
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
    msg_5 db '\tOptiune invalida!$'

    ; Variabile adăugate pentru "Codul Denisa"
    parola db '1111$', 0 ; Parola pentru acces opțiunea 3
    parola_input db 10 dup(0)
    mesaj_parola db 'Introduceti parola: $'
    mesaj_eroare db 'Parola gresita!$'
    mesaj_optiuni db '1. Configurare etaj$\n2. Configurare metoda plata$'
    mesaj_etaj db 'Configurare etaj: $'
    mesaj_optiuni_etaj db '1. Inchidere etaj$\n2. Deschidere etaj$'
    mesaj_metoda_plata db 'Configurare metoda plata: $'
    mesaj_stare db '1. Disponibil$\n0. Indisponibil$'
    nr_inmatriculare db 10 dup(?) ; Număr de înmatriculare (10 caractere)
    etaj db ? ; Variabilă pentru etaj
    locuri_totale db 4 dup(20) ; Locuri totale pentru fiecare etaj (4 etaje)
    locuri_ocupate db 4 dup(0) ; Locuri ocupate pentru fiecare etaj
    stare_card db 1 ; 1 = Disponibil, 0 = Indisponibil
    stare_cash db 1 ; 1 = Disponibil, 0 = Indisponibil

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
    ; Codul Madalin
    ; Introducere numar de inmatriculare
    ; Anulare
    ; ---------------------------------
    ; Selectie nivel (Verifică dacă sunt locuri disponibile)
    ; Anulare
    ; ---------------------------------
    ; Pornește Timerul (Salvează ora la care a intrat)
    ;
    jmp terminare

iesire:
    mov ah, 09h
    lea dx, msg_2
    int 21h
    ; Codul Gabi
    ; Introducere numar de inmatriculare
    ; Anulare
    ; ---------------------------------
    ; Afișare sumă către plată (Calculează cât timp sa aflat mașina în parcare)
    ; Selectie metoda de plata
    ; Anulare
    ; ---------------------------------
    ; Plata 
    ;
    jmp terminare

configurare:
    mov ah, 09h
    lea dx, msg_3
    int 21h

    ; Verificare parolă
parola_check:
    lea dx, mesaj_parola
    mov ah, 09h
    int 21h

    ; Citire parolă utilizator
    lea dx, parola_input
    mov ah, 0Ah
    int 21h

    ; Comparare parolă
    lea si, parola
    lea di, parola_input+1
    mov cx, 4
check_parola:
    lodsb
    scasb
    jne parola_error
    loop check_parola

    ; Parola corectă
    jmp meniu_optiuni

parola_error:
    lea dx, mesaj_eroare
    mov ah, 09h
    int 21h
    jmp start

; Meniu opțiuni după autentificare
meniu_optiuni:
    lea dx, mesaj_optiuni
    mov ah, 09h
    int 21h

    ; Citire opțiune
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    je configurare_etaj
    cmp al, 2
    je configurare_metoda_plata
    jmp start

; Configurare etaj
configurare_etaj:
    lea dx, mesaj_etaj
    mov ah, 09h
    int 21h

    ; Afișare stări etaje
    lea si, locuri_ocupate
    lea di, locuri_totale
    mov cx, 4
etaje_loop:
    mov al, byte ptr [si]
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    lea dx, mesaj_optiuni_etaj
    mov ah, 09h
    int 21h

    ; Citire opțiune etaj
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    je inchidere_etaj
    cmp al, 2
    je deschidere_etaj
    jmp configurare_etaj

; Închidere etaj
inchidere_etaj:
    mov al, 4          ; Setare locuri ocupate la 4
    mov byte ptr [si], al
    jmp configurare_etaj

; Deschidere etaj
deschidere_etaj:
    mov al, 0          ; Resetare locuri ocupate
    mov byte ptr [si], al
    jmp configurare_etaj

; Configurare metodă de plată
configurare_metoda_plata:
    lea dx, mesaj_metoda_plata
    mov ah, 09h
    int 21h

    ; Citire metodă de plată
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    je setare_card
    cmp al, 2
    je setare_cash
    jmp configurare_metoda_plata

; Setare card
setare_card:
    lea dx, mesaj_stare
    mov ah, 09h
    int 21h

    ; Citire stare
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 0
    je indisponibil_card
    mov stare_card, 1
    jmp configurare_metoda_plata

indisponibil_card:
    mov stare_card, 0
    jmp configurare_metoda_plata

; Setare cash
setare_cash:
    lea dx, mesaj_stare
    mov ah, 09h
    int 21h

    ; Citire stare
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 0
    je indisponibil_cash
    mov stare_cash, 1
    jmp configurare_metoda_plata

indisponibil_cash:
    mov stare_cash, 0
    jmp configurare_metoda_plata
	
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
