include "8085.inc"

include "bru.inc"
BRU_BEGIN
ORG 0H

;ORG 0F800H

    jmp  Start                      ;0F800H 
Start:
    xra  A                          ;0F803H 
    sta  0F800H                     ;0F804H 
    sta  0F900H                     ;0F807H 
    sta  0FA00H                     ;0F80AH 
    lxi  H, 0EFFFH                  ;0F80DH 
ClearScreen_Loop:
    mvi  M, 00H                     ;0F810H 
    dcx  H                          ;0F812H 
    mov  A, H                       ;0F813H 
    cpi  0BFH                       ;0F814H 
    jnz  ClearScreen_Loop           ;0F816H 
    inx  H                          ;0F819H HL = 0C0000H


L_1:
    mov  C, M                       ;0F81AH 
    mvi  M, 0FFH                    ;0F81BH 
    mov  A, M                       ;0F81DH 
    cma                             ;0F81EH 
    ora  C                          ;0F81FH 
    mov  C, A                       ;0F820H 
L_2:
    lxi  D, 2000H                   ;0F821H 
    mov  A, C                       ;0F824H 
    rrc                             ;0F825H 
    mov  C, A                       ;0F826H 
    jnc  L_3                        ;0F827H 
    mvi  E, 0FFH                    ;0F82AH 
L_3:
    mov  M, E                       ;0F82CH 
    inr  L                          ;0F82DH 
    dcr  D                          ;0F82EH 
    jnz  L_3                        ;0F82FH 
    dcr  L                          ;0F832H 
    mvi  M, 0FFH                    ;0F833H 
    inr  L                          ;0F835H 
    jnz  L_2                        ;0F836H 
    inr  H                          ;0F839H 
    mov  A, H                       ;0F83AH 
    cpi  0F0H                       ;0F83BH 
    jnz  L_1                        ;0F83DH 
    lxi  D, L_23                    ;0F840H 

    jmp  PauseDelay                 ;0F843H 
L_4:
    mvi  A, 01H                     ;0F846H 
    sta  0F900H                     ;0F848H 
L_5:
    mvi  D, 08H                     ;0F84BH 
StopX:
    jmp  StopX
L_6:
    mov  A, B                       ;0F84DH 
    sui  30H                        ;0F84EH 
    ani  0C0H                       ;0F850H 
    mov  H, A                       ;0F852H 
    mvi  L, 00H                     ;0F853H 
L_7:
    mvi  M, 0FFH                    ;0F855H 
    inr  L                          ;0F857H 
    jnz  L_7                        ;0F858H 
    inr  H                          ;0F85BH 
    mov  A, H                       ;0F85CH 
    cmp  B                          ;0F85DH 
    jnz  L_7                        ;0F85EH 
    mvi  C, 00H                     ;0F861H 
    mov  A, B                       ;0F863H 
    sui  30H                        ;0F864H 
    ani  0C0H                       ;0F866H 
    mov  H, A                       ;0F868H 
    mvi  L, 00H                     ;0F869H 
L_8:
    mov  A, M                       ;0F86BH 
    cma                             ;0F86CH 
    ora  C                          ;0F86DH 
    mov  C, A                       ;0F86EH 
    inr  L                          ;0F86FH 
    jnz  L_8                        ;0F870H 
    inr  H                          ;0F873H 
    mov  A, H                       ;0F874H 
    cmp  B                          ;0F875H 
    jnz  L_8                        ;0F876H 
    mov  A, B                       ;0F879H 
    sui  30H                        ;0F87AH 
    ani  0C0H                       ;0F87CH 
    mov  H, A                       ;0F87EH 
    mvi  L, 00H                     ;0F87FH 
L_9:
    mvi  M, 00H                     ;0F881H 
    inr  L                          ;0F883H 
    jnz  L_9                        ;0F884H 
    inr  H                          ;0F887H 
    mov  A, H                       ;0F888H 
    cmp  B                          ;0F889H 
    jnz  L_9                        ;0F88AH 
    mov  A, B                       ;0F88DH 
    sui  30H                        ;0F88EH 
    ani  0C0H                       ;0F890H 
    mov  H, A                       ;0F892H 
    mvi  L, 00H                     ;0F893H 
L_10:
    mov  A, M                       ;0F895H 
    ora  C                          ;0F896H 
    mov  C, A                       ;0F897H 
    inr  L                          ;0F898H 
    jnz  L_10                       ;0F899H 
    inr  H                          ;0F89CH 
    mov  A, H                       ;0F89DH 
    cmp  B                          ;0F89EH 
    jnz  L_10                       ;0F89FH 
    dcr  D                          ;0F8A2H 
    jnz  L_6                        ;0F8A3H 
    mov  A, B                       ;0F8A6H 
    sui  30H                        ;0F8A7H 
    ani  0C0H                       ;0F8A9H 
    mov  H, A                       ;0F8ABH 
    mvi  B, 01H                     ;0F8ACH 
L_11:
    mvi  L, 00H                     ;0F8AEH 
L_12:
    mvi  M, 0FFH                    ;0F8B0H 
    inr  L                          ;0F8B2H 
    mov  A, L                       ;0F8B3H 
    cmp  B                          ;0F8B4H 
    jnz  L_12                       ;0F8B5H 
L_13:
    mov  A, M                       ;0F8B8H 
    ora  C                          ;0F8B9H 
    mov  C, A                       ;0F8BAH 
    inr  L                          ;0F8BBH 
    jnz  L_13                       ;0F8BCH 
    mov  A, B                       ;0F8BFH 
    rlc                             ;0F8C0H 
    mov  B, A                       ;0F8C1H 
    dcr  A                          ;0F8C2H 
    jnz  L_11                       ;0F8C3H 
L_14:
    mvi  M, 0FFH                    ;0F8C6H 
    inr  L                          ;0F8C8H 
    jnz  L_14                       ;0F8C9H 
    mvi  A, 01H                     ;0F8CCH 
L_15:
    mov  B, A                       ;0F8CEH 
    mov  A, H                       ;0F8CFH 
    add  B                          ;0F8D0H 
    mov  H, A                       ;0F8D1H 
    mvi  L, 00H                     ;0F8D2H 
L_16:
    mov  A, M                       ;0F8D4H 
    ora  C                          ;0F8D5H 
    mov  C, A                       ;0F8D6H 
    inr  L                          ;0F8D7H 
    jnz  L_16                       ;0F8D8H 
    mov  A, H                       ;0F8DBH 
    sub  B                          ;0F8DCH 
    mov  H, A                       ;0F8DDH 
    mov  A, B                       ;0F8DEH 
    rlc                             ;0F8DFH 
    cpi  40H                        ;0F8E0H 
    jnz  L_15                       ;0F8E2H 
    mvi  L, 00H                     ;0F8E5H 
L_17:
    mvi  M, 00H                     ;0F8E7H 
    inr  L                          ;0F8E9H 
    jnz  L_17                       ;0F8EAH 
    xra  A                          ;0F8EDH 
    sta  0F900H                     ;0F8EEH 
    mov  A, H                       ;0F8F1H 
    rrc                             ;0F8F2H 
    rrc                             ;0F8F3H 
    rrc                             ;0F8F4H 
    mov  B, A                       ;0F8F5H 
    lxi  H, L_27                    ;0F8F6H 
    mov  A, L                       ;0F8F9H 
    cmp  E                          ;0F8FAH 
    mvi  A, 40H                     ;0F8FBH 
    jnc  L_19                       ;0F8FDH 
    mvi  A, 80H                     ;0F900H 
L_19:
    add  B                          ;0F902H 
    mov  B, A                       ;0F903H 
    mvi  H, 0D0H                    ;0F904H 
L_20:
    mov  L, B                       ;0F906H 
    mvi  M, 0FFH                    ;0F907H 
    inr  L                          ;0F909H 
    mov  A, C                       ;0F90AH 
    rlc                             ;0F90BH 
    mov  C, A                       ;0F90CH 
L_21:
    mov  A, C                       ;0F90DH 
    ani  01H                        ;0F90EH 
    mvi  M, 81H                     ;0F910H 
    jz   L_22                       ;0F912H 
    mvi  M, 0FFH                    ;0F915H 
L_22:
    inr  L                          ;0F917H 
    mov  A, L                       ;0F918H 
    ani  07H                        ;0F919H 
    jnz  L_21                       ;0F91BH 
    mvi  M, 0FFH                    ;0F91EH 
    inr  H                          ;0F920H 
    inr  H                          ;0F921H 
    mov  A, H                       ;0F922H 
    cpi  0E0H                       ;0F923H 
    jnz  L_20                       ;0F925H 
    mvi  D, 01H                    ;0F928H 
    xchg                            ;0F92AH 
    pchl                            ;0F92BH 
L_23:
    mvi  B, 0F4H                    ;0F92CH 
    lxi  D, DrawText                ;0F92EH 
    jmp  L_5                        ;0F931H 
DrawText:
    mvi  H, 0D0H                    ;0F934H 
    lxi  D, TESTRAM565PY5           ;0F936H 
    mvi  B, 0FH                     ;0F939H 
DrawText_NextColumn:
    mvi  L, 00H                     ;0F93BH 
DrawText_Next8Pixel:
    ldax D                          ;0F93DH 
    inx  D                          ;0F93EH 
    mov  M, A                       ;0F93FH 
    inr  L                          ;0F940H 
    mov  A, L                       ;0F941H 
    cpi  0AH                        ;0F942H Высота колонки = 10 пикселей
    jnz  DrawText_Next8Pixel        ;0F944H 
    inr  H                          ;0F947H Переходим на след. колонку, так как по вертикали 256 пикселей, то просто увеличиваем регистр H
    dcr  B                          ;0F948H 
    jnz  DrawText_NextColumn        ;0F949H 
    mvi  B, 0C0H                    ;0F94CH 
    lxi  D, L_24                    ;0F94EH 
    jmp  L_5                        ;0F951H 
L_24:
    mvi  B, 80H                     ;0F954H 
    lxi  D, L_25                    ;0F956H 
    jmp  L_5                        ;0F959H 
L_25:
    mvi  B, 40H                     ;0F95CH 
    lxi  D, L_26                    ;0F95EH 
    jmp  L_5                        ;0F961H 
L_26:
    mvi  B, 0F0H                    ;0F964H 
L_27:
    lxi  D, L_28                    ;0F966H 
    jmp  L_4                        ;0F969H 
L_28:
    mvi  B, 0C0H                    ;0F96CH 
    lxi  D, L_28_2                  ;0F96EH 
    jmp  L_4                        ;0F971H 
L_28_2:
    mvi  B, 80H                     ;0F974H 
    lxi  D, L_29                    ;0F976H 
    jmp  L_4                        ;0F979H 
L_29:
    mvi  B, 40H                     ;0F97CH 
    lxi  D, L_30                    ;0F97EH 
    jmp  L_4                        ;0F981H 
L_30:
    jmp  L_31                       ;0F984H 

PauseDelay:
;------------------------------------------
; Вход DE = адрес возврата
;------------------------------------------ 
    mvi  B, 02H                     ;0F987H
    lxi  H, 0000H                   ;0F989H 
PauseDelay_Loop:
    dcx  H                          ;0F98CH 
    mov  A, L                       ;0F98DH 
    ora  H                          ;0F98EH 
    jnz  PauseDelay_Loop            ;0F98FH 
    dcr  B                          ;0F992H 
    jnz  PauseDelay_Loop            ;0F993H 
    xchg                            ;0F996H 
    pchl                            ;0F997H 
L_31:
    lxi  D, NextTest                ;0F998H 
    jmp  PauseDelay                 ;0F99BH 
TESTRAM565PY5:
    DB    11111111B                 ;0F99EH ==========================
    DB    11111111B                 ;0F99FH    ИНВЕРСИОННЫЙ ТЕКСТ (высота 10 строк)
    DB    11111111B                 ;0F9A0H     TEST RAM 565РУ5
    DB    11111111B                 ;0F9A1H ==========================
    DB    11111111B                 ;0F9A2H ==========================
    DB    11111111B                 ;0F9A3H '                                                                                                                        '
    DB    11111111B                 ;0F9A4H '             00000 00000  000  00000       0000    0   0   0             00000   000 00000 0000  0   0 00000            '
    DB    11111111B                 ;0F9A5H '               0   0     0   0   0         0   0  0 0  00 00             0      0    0     0   0 0   0 0                '
    DB    11111111B                 ;0F9A6H '               0   0     0       0         0   0 0   0 0 0 0             0000  0     0000  0   0 0   0 0000             '
    DB    11111111B                 ;0F9A7H '               0   0000   000    0         0000  0   0 0 0 0                 0 0000      0 0000   0 0      0            '
    DB    11111111B                 ;0F9A8H '               0   0         0   0         0 0   00000 0   0                 0 0   0     0 0       0       0            '
    DB    11111000B                 ;0F9A9H '               0   0     0   0   0         0  0  0   0 0   0             0   0 0   0 0   0 0      0    0   0            '
    DB    11111110B                 ;0F9AAH '               0   00000  000    0         0   0 0   0 0   0              000   000   000  0     0      000             '
    DB    11111110B                 ;0F9ABH '                                                                                                                        '
    DB    11111110B                 ;0F9ACH '                                                                                                                        '
    DB    11111110B                 ;0F9ADH ==========================
    DB    11111110B                 ;0F9AEH ==========================
    DB    11111110B                 ;0F9AFH ==========================
    DB    11111111B                 ;0F9B0H ==========================
    DB    11111111B                 ;0F9B1H ==========================
    DB    11111111B                 ;0F9B2H ==========================
    DB    00100000B                 ;0F9B3H ==========================
    DB    11101111B                 ;0F9B4H ==========================
    DB    11101111B                 ;0F9B5H ==========================
    DB    11100001B                 ;0F9B6H ==========================
    DB    11101111B                 ;0F9B7H ==========================
    DB    11101111B                 ;0F9B8H ==========================
    DB    11100000B                 ;0F9B9H ==========================
    DB    11111111B                 ;0F9BAH ==========================
    DB    11111111B                 ;0F9BBH ==========================
    DB    11111111B                 ;0F9BCH ==========================
    DB    11000110B                 ;0F9BDH ==========================
    DB    10111011B                 ;0F9BEH ==========================
    DB    10111111B                 ;0F9BFH ==========================
    DB    11000111B                 ;0F9C0H ==========================
    DB    11111011B                 ;0F9C1H ==========================
    DB    10111011B                 ;0F9C2H ==========================
    DB    11000111B                 ;0F9C3H ==========================
    DB    11111111B                 ;0F9C4H ==========================
    DB    11111111B                 ;0F9C5H ==========================
    DB    11111111B                 ;0F9C6H ==========================
    DB    00001111B                 ;0F9C7H ==========================
    DB    10111111B                 ;0F9C8H ==========================
    DB    10111111B                 ;0F9C9H ==========================
    DB    10111111B                 ;0F9CAH ==========================
    DB    10111111B                 ;0F9CBH ==========================
    DB    10111111B                 ;0F9CCH ==========================
    DB    10111111B                 ;0F9CDH ==========================
    DB    11111111B                 ;0F9CEH ==========================
    DB    11111111B                 ;0F9CFH ==========================
    DB    11111111B                 ;0F9D0H ==========================
    DB    11100001B                 ;0F9D1H ==========================
    DB    11101110B                 ;0F9D2H ==========================
    DB    11101110B                 ;0F9D3H ==========================
    DB    11100001B                 ;0F9D4H ==========================
    DB    11101011B                 ;0F9D5H ==========================
    DB    11101101B                 ;0F9D6H ==========================
    DB    11101110B                 ;0F9D7H ==========================
    DB    11111111B                 ;0F9D8H ==========================
    DB    11111111B                 ;0F9D9H ==========================
    DB    11111111B                 ;0F9DAH ==========================
    DB    11101110B                 ;0F9DBH ==========================
    DB    11010110B                 ;0F9DCH ==========================
    DB    10111010B                 ;0F9DDH ==========================
    DB    10111010B                 ;0F9DEH ==========================
    DB    10000010B                 ;0F9DFH ==========================
    DB    10111010B                 ;0F9E0H ==========================
    DB    10111010B                 ;0F9E1H ==========================
    DB    11111111B                 ;0F9E2H ==========================
    DB    11111111B                 ;0F9E3H ==========================
    DB    11111111B                 ;0F9E4H ==========================
    DB    11101111B                 ;0F9E5H ==========================
    DB    01001111B                 ;0F9E6H ==========================
    DB    10101111B                 ;0F9E7H ==========================
    DB    10101111B                 ;0F9E8H ==========================
    DB    11101111B                 ;0F9E9H ==========================
    DB    11101111B                 ;0F9EAH ==========================
    DB    11101111B                 ;0F9EBH ==========================
    DB    11111111B                 ;0F9ECH ==========================
    DB    11111111B                 ;0F9EDH ==========================
    DB    11111111B                 ;0F9EEH ==========================
    DB    11111111B                 ;0F9EFH ==========================
    DB    11111111B                 ;0F9F0H ==========================
    DB    11111111B                 ;0F9F1H ==========================
    DB    11111111B                 ;0F9F2H ==========================
    DB    11111111B                 ;0F9F3H ==========================
    DB    11111111B                 ;0F9F4H ==========================
    DB    11111111B                 ;0F9F5H ==========================
    DB    11111111B                 ;0F9F6H ==========================
    DB    11111111B                 ;0F9F7H ==========================
    DB    11111111B                 ;0F9F8H ==========================
    DB    10000011B                 ;0F9F9H ==========================
    DB    10111111B                 ;0F9FAH ==========================
    DB    10000110B                 ;0F9FBH ==========================
    DB    11111010B                 ;0F9FCH ==========================
    DB    11111010B                 ;0F9FDH ==========================
    DB    10111010B                 ;0F9FEH ==========================
    DB    11000111B                 ;0F9FFH ==========================
    DB    11111111B                 ;0FA00H ==========================
    DB    11111111B                 ;0FA01H ==========================
    DB    11111111B                 ;0FA02H ==========================
    DB    10001000B                 ;0FA03H ==========================
    DB    01111011B                 ;0FA04H ==========================
    DB    11111000B                 ;0FA05H ==========================
    DB    00011111B                 ;0FA06H ==========================
    DB    11101111B                 ;0FA07H ==========================
    DB    11101011B                 ;0FA08H ==========================
    DB    00011100B                 ;0FA09H ==========================
    DB    11111111B                 ;0FA0AH ==========================
    DB    11111111B                 ;0FA0BH ==========================
    DB    11111111B                 ;0FA0CH ==========================
    DB    00100001B                 ;0FA0DH ==========================
    DB    11101110B                 ;0FA0EH ==========================
    DB    01101110B                 ;0FA0FH ==========================
    DB    10100001B                 ;0FA10H ==========================
    DB    10101111B                 ;0FA11H ==========================
    DB    10101111B                 ;0FA12H ==========================
    DB    01101111B                 ;0FA13H ==========================
    DB    11111111B                 ;0FA14H ==========================
    DB    11111111B                 ;0FA15H ==========================
    DB    11111111B                 ;0FA16H ==========================
    DB    10111010B                 ;0FA17H ==========================
    DB    10111010B                 ;0FA18H ==========================
    DB    10111010B                 ;0FA19H ==========================
    DB    11010111B                 ;0FA1AH ==========================
    DB    11101111B                 ;0FA1BH ==========================
    DB    11011110B                 ;0FA1CH ==========================
    DB    10111111B                 ;0FA1DH ==========================
    DB    11111111B                 ;0FA1EH ==========================
    DB    11111111B                 ;0FA1FH ==========================
    DB    11111111B                 ;0FA20H ==========================
    DB    00001111B                 ;0FA21H ==========================
    DB    11111111B                 ;0FA22H ==========================
    DB    00011111B                 ;0FA23H ==========================
    DB    11101111B                 ;0FA24H ==========================
    DB    11101111B                 ;0FA25H ==========================
    DB    11101111B                 ;0FA26H ==========================
    DB    00011111B                 ;0FA27H ==========================
    DB    11111111B                 ;0FA28H ==========================
    DB    11111111B                 ;0FA29H ==========================
    DB    11111111B                 ;0FA2AH ==========================
    DB    11111111B                 ;0FA2BH ==========================
    DB    11111111B                 ;0FA2CH ==========================
    DB    11111111B                 ;0FA2DH ==========================
    DB    11111111B                 ;0FA2EH ==========================
    DB    11111111B                 ;0FA2FH ==========================
    DB    11111111B                 ;0FA30H ==========================
    DB    11111111B                 ;0FA31H ==========================
    DB    11111111B                 ;0FA32H ==========================
    DB    11111111B                 ;0FA33H ==========================
    DB    00000000B                 ;0FA34H 
    DB    00000000B                 ;0FA35H 
    DB    00000000B                 ;0FA36H 
    DB    00000000B                 ;0FA37H 
    DB    00000000B                 ;0FA38H 
    DB    00000000B                 ;0FA39H 
    DB    00000000B                 ;0FA3AH 
    DB    00000000B                 ;0FA3BH 
    DB    00000000B                 ;0FA3CH 
    DB    00000000B                 ;0FA3DH 
NextTest:
    lxi  H, 0EFFFH                  ;0FA3EH 
NextTest_Loop:
    mvi  M, 55H                     ;0FA41H 
    dcx  H                          ;0FA43H 
    mvi  M, 0AAH                    ;0FA44H 
    dcx  H                          ;0FA46H 
    mov  A, H                       ;0FA47H 
    cpi  0BFH                       ;0FA48H 
    jnz  NextTest_Loop              ;0FA4AH 
    inx  H                          ;0FA4DH HL = 0C0000H
    mvi  A, 01H                     ;0FA4EH 
    sta  0F900H                     ;0FA50H 
    mvi  C, 00H                     ;0FA53H 
NextTest_L1:
    mvi  B, 03H                     ;0FA55H 
NextTest_L2:
    mov  M, C                       ;0FA57H 
    inr  L                          ;0FA58H 
    jnz  NextTest_L2                ;0FA59H 
    inr  H                          ;0FA5CH 
    dcr  B                          ;0FA5DH 
    jnz  NextTest_L2                ;0FA5EH 
    inr  C                          ;0FA61H 
    mov  A, C                       ;0FA62H 
    cpi  10H                        ;0FA63H 
    jnz  NextTest_L1                ;0FA65H 
    mvi  C, 00H                     ;0FA68H 
NextTest_L3:
    mvi  D, 20H                     ;0FA6AH 
NextTest_L4:
    mvi  H, 0C0H                    ;0FA6CH 
    mvi  B, 30H                     ;0FA6EH 
NextTest_L5:
    mov  A, M                       ;0FA70H 
    ora  C                          ;0FA71H 
    mov  M, A                       ;0FA72H 
    inr  H                          ;0FA73H 
    dcr  B                          ;0FA74H 
    jnz  NextTest_L5                ;0FA75H 
    inr  L                          ;0FA78H 
    dcr  D                          ;0FA79H 
    jnz  NextTest_L4                ;0FA7AH 
    mov  A, C                       ;0FA7DH 
    adi  10H                        ;0FA7EH 
    mov  C, A                       ;0FA80H 
    jnc  NextTest_L3                ;0FA81H 
    xra  A                          ;0FA84H 
    sta  0F900H                     ;0FA85H 
    mvi  A, 07H                     ;0FA88H 
    sta  0F800H                     ;0FA8AH 
Stop:
    jmp  Stop                       ;0FA8DH 


BRU_END
