; 0F821H - универсальный вход
; 0F3CAH - ячейка входа
; Программа вывода на экран сообщенийю В HL - адрес начала, 00H - конечный байт
; Программа работает совместно с 0F80FH (вывод символа на экран, A - выводимый символ)

;include "8085.inc"
;ORG 0AFF6H
;
;M1:
;    mov A, M                        ;0AFF6H 
;    ana A                           ;0AFF7H 
;    rz                              ;0AFF8H
;    call 0F80FH                     ;0AFF9H
;    inx H                           ;0AFFCH
;    jmp M1                          ;0AFFDH 

; Программа записывающая предыдущую программу с адреса 0AFF6H по 0AFFFH и записывает в ячейки 0F3CAH и 0F3CBH адрес перехода 0AFF6H
include "8085.inc"
ORG 0H
M1:
    lxi B, M3                       ;
    lxi B, 0AFF6H                   ;
    ldax B                          ;
    ana A                           ;
    jz M2                           ;
    stax D                          ;
    inx B                           ;
    inx D                           ;
    jmp M1                          ;
M2:
    lxi H, 0AFF6H                   ;
    shld 0F3CAH                     ;
	jmp 0F958H
M3:
    file 'DisplayText.rom'
    DB    00H                      ;

;    DB    7EH                      ;
;    DB    A7H                      ;
;    DB    0C8H                     ;
;    DB    0CDH                     ;
;    DB    0FH                      ;
;    DB    0F8H                     ;
;    DB    23H                      ;
;    DB    0C3H                     ;
;    DB    0F6H                     ;
;    DB    0AFH                     ;
;    DB    00H                      ;
