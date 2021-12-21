include "8085.inc"

; 0F400H - порт клавиатуры
; 0F500H - порт пользователя №1
; 0F600H - порт пользователя №2
; 0F700H - порт платы расширения
; 0F800H - системный порт №1 - управление цветным режимом - (только для записи) 
; 0F900H - системный порт №2 - управление переключением страниц - (только для записи)
; 0FA00H - системный порт №3 - управление переключением экранов - (только для записи)
; 0FB00H - системный порт №4 - переключение типов дисплеев (не используется) - (только для записи)
;
; FFFF ---------------------------------------------------------
;      |   МОНИТОР   |                                         |
; F800 ---------------                                         |
;      | АДР. ПОРТОВ |      Н Е  И С П О Л Ь З У Е Т С Я       |
; F400 ---------------                                         |
;      |  СЛУЖ. ОЗУ  |                                         |
; F000 ---------------------------------------------------------
;      |             |             |             |             |
;      |     ОЗУ     |     ОЗУ     |             |             |
;      |   ЭКРАНА    | УПРАВЛЕНИЯ  |             |             |
;      |   ДИСПЛЕЯ   |   ЦВЕТОМ    |             |             |
;      |             |   ДИСПЛЕЯ   |             |             |
;      |         12K |         12K |             |             |
; C000 -----------------------------             |             |
;      |         48K |         48K |         60K |         60K |
;      |             |             |             |             |
;      |     "0"     |     "1"     |     "2"     |     "3"     |
;      |             |             |             |             |
;      |  ОСНОВНАЯ   |        Д О П О Л Н И Т Е Л Ь Н Ы Е      |
;      |  СТРАНИЦА   |             С Т Р А Н И Ц Ы             |
;      |    ОЗУ      |                  О З У                  |
;      |             |             |             |             |
; 0000 ---------------------------------------------------------
;
;    Служебные ячейки
; -----------------------------------------------------------------------------------------------------------------------------------
;| 0F3C0H | XX | StackHead         | Начало стека, расширяется в сторону уменьшения адреса
;| 0F3C3H | C3 | Beep_Jmp          | 0C3H (код команды JMP) - Beep
;| 0F3C4H | XX | Beep_Addr_Lo      | LO - адрес Beep
;| 0F3C5H | XX | Beep_Addr_Hi      | HI - адрес Beep
;| 0F3C6H | C3 | KBRD_Jmp          | 0C3H (код команды JMP) - KBRD
;| 0F3C7H | XX | KBRD_Addr_Lo      | LO - адрес KBRD
;| 0F3C8H | XX | KBRD_Addr_Hi      | HI - адрес KBRD
;| 0F3C9H | C3 | WCUR_Jmp          | 0C3H (код команды JMP) - WCUR
;| 0F3CAH | XX | WCUR_Addr_Lo      | LO - адрес WCUR
;| 0F3CBH | XX | WCUR_Addr_Hi      | HI - адрес WCUR
;| 0F3CCH | C3 | TV2_Jmp           | 0C3H (код команды JMP) - TV2
;| 0F3CDH | XX | TV2_Addr_Lo       | LO - адрес TV2
;| 0F3CEH | XX | TV2_Addr_Hi       | HI - адрес TV2
;| 0F3CFH | C0 | SCREEN_Addr_Hi    | старший байт начала видеопамяти 0C000H
;| 0F3D0H | 30 | SCREEN_Size_Hi    | старший байт размера видеопамяти 3000H = 12К
;| 0F3D1H | 00 | CODEPAGE_Addr_Lo  | LO - адрес CODEPAGE 0F000H 
;| 0F3D2H | F0 | CODEPAGE_Addr_Hi  | HI - адрес CODEPAGE 0F000H 
;| 0F3D3H | 00 | INVERSE_DISPLAY   | Признак инверсионного вывода 00H - нормальный вывод, 0FFH - инверсионный вывод

SZ:EQU    0F3D4H ;wysota okna
ZAPAS:EQU    0F3D5H ; !
TVAD:EQU    0F3D6H ;adres stolb. kursora
TVAD1:EQU    0F3D7H ;adres stroki kursora
MNJMP:EQU    0F3D8H ;adr.wozw.iz ERR-MGG
TIM50:EQU    0F3DAH ;konstanta zap. MG
TIM75:EQU    0F3DBH ;konst.~teniq MG
FLMN:EQU    0F3DCH ;flag inwers.MG
TB1:EQU    0F3DDH ;s/q~1 (prog.TV)
AR2:EQU    0F3DEH ; ESC
TIMES:EQU    0F3DFH ;s/para N1(prog.tV)
TIMES2:EQU    0F3E1H ;adres TV2 w monit.
MEMOR:EQU    0F3E3H ;mah adr.ozu
FFIX:EQU    0F3E5H ;triger "rus/lat"
SIMV:EQU    0F3E6H ;posl.wwed.simw.KBRD
CBEEP:EQU    0F3E7H ;konst.zw.signala
TSU:EQU    0F3E8H
TSH:EQU    0F3E9H
TBT:EQU    0F3EAH
ZAPAS2:EQU    0F3EBH ; !!!
LOW:EQU    0F3EEH ;q~. I-operanda
LOW1:EQU    0F3EFH

;| 0F3C9H | C3 | Reserv_JMP_ADDR   | 0C3H (код команды JMP) - Резерв 
;| 0F3CAH | XX | Reserv_ADDR       | LO - адрес
;| 0F3CBH | XX | Reserv_ADDR       | HI - адрес
;| 0F3CCH | C3 | DispSymC_JMP_ADDR | 0C3H (код команды JMP) - DispSymC
;| 0F3CDH | XX | DispSymC_ADDR     | LO - адрес
;| 0F3CEH | XX | DispSymC_ADDR     | HI - адрес
;| 0F3CFH | C0 | SCREEN_ADDR_HI    | старший байт начала видеопамяти 0C000H
;| 0F3D0H | 30 | SCREEN_SIZE_HI    | старший байт размера видеопамяти 3000H = 12К
;| 0F3D1H | 00 | CODEPAGE_ADDR     | LO - адрес CODEPAGE 0F000H 
;| 0F3D2H | F0 | CODEPAGE_ADDR     | HI - адрес CODEPAGE 0F000H 
;| 0F3D3H | 00 | INVERSE_DISP_ADDR | Признак инверсионного вывода 00H - нормальный вывод, 0FFH - инверсионный вывод
;| 0F3D4H | XX | X_POS_ADDR        | Номер позиции курсора X * 4 (0—3FH << 2)
;| 0F3D5H | XX | Y_POS_ADDR        | Номер строки  курсора Y     (0—18Н)
;| 0F3D6H | -- |                   |
;| 0F3D7H | -- |                   |
;| 0F3D8H | XX | RESTART_ADDR      | LO - адрес возврата
;| 0F3D9H | XX | RESTART_ADDR      | HI - адрес возврата
;| 0F3DAH | 40 | PAUSE_SAVE_ADDR   | запись - 1200 бод = 40H
;| 0F3DBH | 60 | PAUSE_LOAD_ADDR   | чтение - для стандартной скорости = 60H
;| 0F3DCH | XX | LOADBYTE_ADDR     |
;| 0F3DDH | XX |                   |
;| 0F3DEH | -- |                   |
;| 0F3DFH | XX |                   |
;| 0F3E0H | XX |                   |
;| 0F3E1H | -- |                   |
;| 0F3E2H | -- |                   |
;| 0F3E3H | FF | USER_MAX_RAM_ADDR | LO - адрес 0BFFFH = верхний адрес пользовательского ОЗУ
;| 0F3E4H | BF | USER_MAX_RAM_ADDR | HI - адрес 0BFFFH = верхний адрес пользовательского ОЗУ
;| 0F3E5H | XX | KEY_LED           |
;| 0F3E6H | XX | KEY_CODE          | Код нажатой клавиши
;| 0F3E7H | -- |                   |
;| 0F3E8H | -- |                   |
;| 0F3E9H | -- |                   |
;| 0F3EAH | -- |                   |
;| 0F3EBH | -- |                   |
;| 0F3ECH | -- |                   |
;| 0F3EDH | -- |                   |
;| 0F3EEH | XX | Cmd_Param         | LO - значение текущего параметра введенной команды
;| 0F3EFH | XX | Cmd_Param         | HI - значение текущего параметра введенной команды
;| 0F3F0H | XX | Cmd_Buffer_Start  | Буфер для введенной команды
;| 0F3F1H | XX | Cmd_Buffer        | Буфер для введенной команды
;| 0F3F2H | XX |                   | Буфер для введенной команды
;| 0F3F3H | XX |                   | Буфер для введенной команды
;| 0F3F4H | XX |                   | Буфер для введенной команды
;| 0F3F5H | XX |                   | Буфер для введенной команды
;| 0F3F6H | XX |                   | Буфер для введенной команды
;| 0F3F7H | XX |                   | Буфер для введенной команды
;| 0F3F8H | XX |                   | Буфер для введенной команды
;| 0F3F9H | XX |                   | Буфер для введенной команды
;| 0F3FAH | XX |                   | Буфер для введенной команды
;| 0F3FBH | XX |                   | Буфер для введенной команды
;| 0F3FCH | XX |                   | Буфер для введенной команды
;| 0F3FDH | XX |                   | Буфер для введенной команды
;| 0F3FEH | XX |                   | Буфер для введенной команды
;| 0F3FFH | XX |                   | Буфер для введенной команды
; -----------------------------------------------------------------------------------------------------------------------------------
;
;
;                     Коды символов
; _____________________________________________________
;|     |     |     |     |     |     |     |     |     |
;|     |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
;|_____|_____|_____|_____|_____|_____|_____|_____|_____|
;|     |     |     |     |     |     |     |     |     |
;|  0  |  F1 |     |Space|  0  |  @  |  P  |  Ю  |  П  |
;|  1  |  F2 |     |  !  |  1  |  A  |  Q  |  А  |  Я  |
;|  2  |  F3 |     |  "  |  2  |  B  |  R  |  Б  |  Р  |
;|  3  |  F4 |     |  #  |  3  |  C  |  S  |  Ц  |  С  |
;|  4  |  F5 |     |  $  |  4  |  D  |  T  |  Д  |  Т  |
;|  5  |     |     |  %  |  5  |  E  |  U  |  Е  |  У  |
;|  6  |     |     |  &  |  6  |  F  |  V  |  Ф  |  Ж  |
;|  7  |     |     |  '  |  7  |  G  |  W  |  Г  |  В  |
;|  8  |  ←  |  →  |  (  |  8  |  H  |  X  |  Х  |  Ь  |
;|  9  | ТАБ |  ↑  |  )  |  9  |  I  |  Y  |  И  |  Ы  |
;|  A  |  ПС |  ↓  |  *  |  :  |  J  |  Z  |  Й  |  З  |
;|  B  |     | АР2 |  +  |  ;  |  K  |  [  |  К  |  Ш  |
;|  C  |  \  |     |  ,  |  <  |  L  |  \  |  Л  |  Э  |
;|  D  |  ВК |     |  -  |  =  |  M  |  ]  |  М  |  Щ  |
;|  E  |     |     |  .  |  >  |  N  |  ^  |  Н  |  Ч  |
;|  F  |     | СТР |  /  |  ?  |  O  |  _  |  О  |  ЗБ |
;|_____|_____|_____|_____|_____|_____|_____|_____|_____|
;
;
;          PA0 PA1 PA2 PA3 PA4 PA5 PA6 PA7
;          01H 02H 04H 08H 10H 20H 40H 80H
;PB0  01H   \  TAB  0   8   @   H   P   X 
;PB1  02H  СТР  ПС  1   9   A   I   Q   Y 
;PB2  04H  АР2  ВК  2   *   B   J   R   Z 
;PB3  08H   F1  ЗБ  3   +   C   K   S   [ 
;PB4  10H   F2  ←   4   ,   D   L   T   \ 
;PB5  20H   F3  ↑   5   -   E   M   U   ] 
;PB6  40H   F4  →   6   .   F   N   V   ^ 
;PB7  80H   F5  ↓   7   /   G   O   W   _ 
;-----------------------------------------------------------------------------------------------------------------------------------

ORG 0F800H

    jmp  StartCode                  ;0F800H 

InputKeyA_Entry:
    jmp  0F3C6H                     ;0F803H 

LoadByteA_Entry:
    jmp  LoadByteA                  ;0F806H 

DisplaySymC_Entry:
    jmp  DisplaySymC                ;0F809H 

SaveByteC_Entry:
    jmp  SaveByteC                  ;0F80CH 

DisplaySymA_Entry:
    jmp  DisplaySymA                ;0F80FH 

GetKeyStateA_Entry:
    jmp  GetKeyStateA               ;0F812H 

DisplayHexA_Entry:
    jmp  DisplayHexA                ;0F815H 

DisplayTextHL_Entry:
    jmp  DisplayTextHL              ;0F818H 

InputkeyCodeA_Entry:
    jmp  InputkeyCodeA              ;0F81BH 

GetPosCursor_Entry:
    jmp  GetPosCursor               ;0F81EH 

NotImplemented_Entry:
    jmp  NotImplemented             ;0F821H 

LoadFile_Entry:
    jmp  LoadFile                   ;0F824H 

SaveFile_Entry:
    jmp  SaveFile                   ;0F827H 

CalcControlSum_Entry:
;------------------------------------------
; Подсчет контрольной суммы блока
;  вх:  HL = адрес начала
;       DE = адрес конца
;  вых: BC = контрольная сумма
;------------------------------------------
    jmp  CalcControlSum             ;0F82AH

LoadCodePage_Entry:
;------------------------------------------
; Распаковка внутреннего знакогенератора
;  вх:  нет
;  вых: нет
;------------------------------------------
    jmp  LoadCodePage               ;0F82DH

LoadRamAddr_Entry:
;------------------------------------------
; Чтение конечного адреса ОЗУ пользователя
;  вх:  нет
;  вых: HL = конечный адрес
;------------------------------------------
    jmp  LoadRamAddr                ;0F830H

SaveRamAddr_Entry:
;------------------------------------------
; Запись конечного адреса ОЗУ пользователя
;  вх:  HL = конечный адрес
;  вых: нет
;------------------------------------------
    jmp  SaveRamAddr                ;0F833H

LoadByteDisplayPage_Entry:
;------------------------------------------
; Чтение байта из доп. страницы
;  вх:  HL = адрес
;       A  = N страницы (0-3)
;  вых: C  = считанный байт
;------------------------------------------
    jmp  LoadByteDisplayPage        ;0F836H

SaveByteDisplayPage_Entry:
;------------------------------------------
; Запись байта в доп. страницы
;  вх:  HL = адрес
;       A  = N страницы (0-3)
;       C  = записываемый байт
;  вых: нет
;------------------------------------------
    jmp  SaveByteDisplayPage        ;0F839H

SetPosCursor_Entry:
    jmp  SetPosCursor               ;0F83CH 

Reserv_Entry:
    jmp  Reserv_Entry               ;0F83FH 

StartCode:
    lxi  SP, 0F3C0H                 ;0F842H Устанавливаем вершину стека = 0F3C0H
    xra  A                          ;0F845H Обнуляем регистр аккамулятора
    out  0F8H                       ;0F846H Записываем 0 в порт 0F800H - системный порт №1 (управление цветным режимом) 
    out  0F9H                       ;0F848H Записываем 0 в порт 0F900H - системный порт №2 (управление переключением страниц)
    out  0FAH                       ;0F84AH Записываем 0 в порт 0FA00H - системный порт №3 (управление переключением экранов)
    sta  0F3D3H                     ;0F84CH 
    sta  0F3D4H                     ;0F84FH 
    sta  0F3DEH                     ;0F852H 
    mvi  A, 0C3H                    ;0F855H Код команды безусловного перехода JMP (0C3H)
    sta  0F3C6H                     ;0F857H 
    sta  NotImplemented             ;0F85AH 
    sta  DisplaySymC                ;0F85DH 
    sta  Reserv_Entry               ;0F860H 
    lxi  H, 6040H                   ;0F863H Значение 6040H (запись - 1200 бод = 40H, чтение - для стандартной скорости = 60H)
    shld 0F3DAH                     ;0F866H Сохраняем в ячейке. 0F3DAH - ячейка в которой хранится константа записи на магнитную 40H. 0F3DBH - ячейка в которой хранится константа чтения с магнитной ленты = 60H
    call Init                       ;0F869H 
    lxi  SP, 0F3C0H                 ;0F86CH 
    mvi  A, 8AH                     ;0F86FH 
    sta  0F403H                     ;0F871H 
    mvi  A, 55H                     ;0F874H 
    sta  0F3E7H                     ;0F876H 
    lxi  H, 0F86CH                  ;0F879H 
    shld 0F3D8H                     ;0F87CH 
    xra  A                          ;0F87FH 
    sta  0F3E5H                     ;0F880H 
    mov  H, A                       ;0F883H 
    mov  L, A                       ;0F884H 
    mvi  A, 90H                     ;0F885H 
    sta  0F503H                     ;0F887H 
    call 0F8C1H                     ;0F88AH 
    mov  C, A                       ;0F88DH 
    inx  H                          ;0F88EH 
    call 0F8C1H                     ;0F88FH 
    cmp  C                          ;0F892H 
    jnz  0F8ADH                     ;0F893H 
    lxi  H, 0F8A6H                  ;0F896H 
    call DisplayTextHL              ;0F899H 
    call 0FA84H                     ;0F89CH 
    call LoadFile                   ;0F89FH 
    jnz  0F896H                     ;0F8A2H 
    pchl                            ;0F8A5H 
    DB    31,'wwod?', 0             ;0F8A6H 
    lxi  H, 07FFH                   ;0F8ADH 
    lxi  D, 0BFFFH                  ;0F8B0H 
    call 0F8C1H                     ;0F8B3H 
    stax D                          ;0F8B6H 
    dcx  D                          ;0F8B7H 
    dcx  H                          ;0F8B8H 
    mov  A, H                       ;0F8B9H 
    ora  A                          ;0F8BAH 
    jp   0F8B3H                     ;0F8BBH 
    jmp  0BFFDH                     ;0F8BEH 
    shld 0F501H                     ;0F8C1H 
    lda  0F500H                     ;0F8C4H 
    ret                             ;0F8C7H 

Init:
    lxi  H, 30C0H                   ;0F8C8H 
    shld 0F3CFH                     ;0F8CBH 
    lxi  H, 0F000H                  ;0F8CEH HL = 0F000H, адрес знакогенератора в ОЗУ 
    shld 0F3D1H                     ;0F8D1H Сохраняем адрес знакогенератора в CODEPAGE_ADDR
    lxi  H, 0FC37H                  ;0F8D4H 
    shld 0F3CDH                     ;0F8D7H 
    shld 0F3E1H                     ;0F8DAH 
    lxi  H, SaveFile                ;0F8DDH 
    shld 0F3CAH                     ;0F8E0H 
    lxi  H, 0FA84H                  ;0F8E3H 
    shld 0F3C7H                     ;0F8E6H 
    lxi  H, 0FE33H                  ;0F8E9H 
    shld 0F3C4H                     ;0F8ECH 

LoadCodePage:
    lxi  D, CodePageTable           ;0F8EFH DE = Адрес упаковонного знакогенератора в ПЗУ
    lhld 0F3D1H                     ;0F8F2H HL = Загружаем из CODEPAGE_ADDR адрес знакогенератора в ОЗУ (0F000H)
LoadCodePage_NextSymbol:
;------------------------------------------
;Знакогенератор содержит символы 5х7 точек, символы распаковываются в матрицу 8х8
;первая строка всегда = 0 (пустая), далее 7 строк символа в формате | XXX | XXXXX |
;где старшие 3 бита кол-во строк + 1, т.е. значение 0 = 1 строка, младшие 5 бит, строка символа.
;Значение 0С00H -> 11000000, где кол-во строк = 7, строка = 0 -> символ пробела.
;Значения 84H, 00H, 04H распаковывается в '!'
;00000000 - всегда пусто
;00000100 - 84H => 5 раз 00100
;00000100 - 84H => 5 раз 00100
;00000100 - 84H => 5 раз 00100
;00000100 - 84H => 5 раз 00100
;00000100 - 84H => 5 раз 00100
;00000000 - 00H => 1 раз 00000
;00000100 - 04H => 1 раз 00100
;------------------------------------------
    mvi  C, 07H                     ;0F8F5H
    xra  A                          ;0F8F7H 
    mov  M, A                       ;0F8F8H 
    inx  H                          ;0F8F9H 
LoadCodePage_Extract:
    ldax D                          ;0F8FAH 
    rlc                             ;0F8FBH 
    rlc                             ;0F8FCH 
    rlc                             ;0F8FDH 
    ani  07H                        ;0F8FEH 
    mov  B, A                       ;0F900H 
LoadCodePage_ExtractLine:
    ldax D                          ;0F901H 
    ani  1FH                        ;0F902H 
    mov  M, A                       ;0F904H 
    inx  H                          ;0F905H 
    dcr  C                          ;0F906H 
    mov  A, B                       ;0F907H 
    ana  A                          ;0F908H 
    jz   0F910H                     ;0F909H 
    dcr  B                          ;0F90CH 
    jmp  LoadCodePage_ExtractLine   ;0F90DH 
    inx  D                          ;0F910H 
    mov  A, D                       ;0F911H 
    ana  A                          ;0F912H 
    rz                              ;0F913H 
    mov  A, C                       ;0F914H 
    ana  A                          ;0F915H 
    jnz  LoadCodePage_Extract       ;0F916H 
    jmp  LoadCodePage_NextSymbol    ;0F919H 

DisplayHexA:
    push PSW                        ;0F91CH 
    rrc                             ;0F91DH 
    rrc                             ;0F91EH 
    rrc                             ;0F91FH 
    rrc                             ;0F920H 
    call DisplayHexA_Nibble         ;0F921H 
    pop  psw                        ;0F924H 
DisplayHexA_Nibble:
    ani  0FH                        ;0F925H 
    cpi  0AH                        ;0F927H 
    jm   DisplayHexA_Number         ;0F929H 
    adi  07H                        ;0F92CH 
DisplayHexA_Number:
    adi  30H                        ;0F92EH 
DisplaySymC_Call:
    push B                          ;0F930H 
    mov  C, A                       ;0F931H 
    call DisplaySymC_Entry          ;0F932H 
    pop  B                          ;0F935H 

SaveFile:
    ret                             ;0F936H 

DisplayTextHL:
    mov  A, M                       ;0F937H 
    ana  A                          ;0F938H 
    rz                              ;0F939H 
    call DisplaySymC_Call           ;0F93AH 
    inx  H                          ;0F93DH 
    jmp  DisplayTextHL              ;0F93EH 

CalcControlSum:
;------------------------------------------
; Подсчет контрольной суммы блока
;  вх:  HL = адрес начала
;       DE = адрес конца
;  вых: BC = контрольная сумма
;------------------------------------------
    lxi  B, 0000H                   ;0F941H
CalcControlSum_Loop:
    mov  A, C                       ;0F944H 
    add  M                          ;0F945H 
    mov  C, A                       ;0F946H 
    push PSW                        ;0F947H 
    call CalcControlSum_HL_DE       ;0F948H 
    jz   0FA76H                     ;0F94BH 
    pop  psw                        ;0F94EH 
    mov  A, B                       ;0F94FH 
    adc  M                          ;0F950H 
    mov  B, A                       ;0F951H 
    inx  H                          ;0F952H 
    jmp  CalcControlSum_Loop        ;0F953H 
CalcControlSum_HL_DE:
    mov  A, H                       ;0F956H 
    cmp  D                          ;0F957H 
    rnz                             ;0F958H 
    mov  A, L                       ;0F959H 
    cmp  E                          ;0F95AH 
    ret                             ;0F95BH 

SetPosCursor:
    mov  A, L                       ;0F95CH 
    rlc                             ;0F95DH 
    rlc                             ;0F95EH 
    mov  L, A                       ;0F95FH 
    shld 0F3D6H                     ;0F960H 

GetPosCursor:
    lhld 0F3D6H                     ;0F963H 
    mov  A, L                       ;0F966H 
    rrc                             ;0F967H 
    rrc                             ;0F968H 
    mov  L, A                       ;0F969H 
    ret                             ;0F96AH 

SaveRamAddr:
;------------------------------------------
; Запись конечного адреса ОЗУ пользователя
;  вх:  HL = конечный адрес
;  вых: нет
;------------------------------------------
    shld 0F3E3H                     ;0F96BH

LoadRamAddr:
;------------------------------------------
; Чтение конечного адреса ОЗУ пользователя
;  вх:  нет
;  вых: HL = конечный адрес
;------------------------------------------
    lhld 0F3E3H                     ;0F96EH
    ret                             ;0F971H 

SaveByteDisplayPage:
;------------------------------------------
; Запись байта в доп. страницы
;  вх:  HL = адрес
;       A  = N страницы (0-3)
;       C  = записываемый байт
;  вых: нет
;------------------------------------------
    out  0F9H                       ;0F972H
    mov  M, C                       ;0F974H 
    jmp  0F97BH                     ;0F975H 

LoadByteDisplayPage:
;------------------------------------------
; Чтение байта из доп. страницы
;  вх:  HL = адрес
;       A  = N страницы (0-3)
;  вых: C  = считанный байт
;------------------------------------------
    out  0F9H                       ;0F978H
    mov  C, M                       ;0F97AH 
    xra  A                          ;0F97BH 
    out  0F9H                       ;0F97CH 
    ret                             ;0F97EH 

LoadFile:
    mvi  A, 0FFH                    ;0F97FH 
    call 0F9B4H                     ;0F981H 
    shld 0F3EEH                     ;0F984H 
    xchg                            ;0F987H 
    call 0F9B2H                     ;0F988H 
    xchg                            ;0F98BH 
    push H                          ;0F98CH 
    call 0F9CBH                     ;0F98DH 
    mov  M, A                       ;0F990H 
    call CalcControlSum_HL_DE       ;0F991H 
    inx  H                          ;0F994H 
    jnz  0F98DH                     ;0F995H 
    call 0F9CBH                     ;0F998H 
    call 0F9B2H                     ;0F99BH 
    call 0F9B2H                     ;0F99EH 
    mov  B, H                       ;0F9A1H 
    mov  C, L                       ;0F9A2H 
    pop  H                          ;0F9A3H 
    push B                          ;0F9A4H 
    call CalcControlSum             ;0F9A5H 
    pop D                           ;0F9A8H 
    mov  H, B                       ;0F9A9H 
    mov  L, C                       ;0F9AAH 
    call CalcControlSum_HL_DE       ;0F9ABH 
    lhld 0F3EEH                     ;0F9AEH 
    ret                             ;0F9B1H 
    mvi  A, 08H                     ;0F9B2H 
    call LoadByteA                  ;0F9B4H 
    mov  H, A                       ;0F9B7H 
    call 0F9CBH                     ;0F9B8H 
    mov  L, A                       ;0F9BBH 
    ret                             ;0F9BCH 
    lda  0F3DAH                     ;0F9BDH 
    jmp  0F9C6H                     ;0F9C0H 
    lda  0F3DBH                     ;0F9C3H 
    dcr  A                          ;0F9C6H 
    jnz  0F9C6H                     ;0F9C7H 
    ret                             ;0F9CAH 
    mvi  A, 08H                     ;0F9CBH 

LoadByteA:
    push B                          ;0F9CDH 
    push D                          ;0F9CEH 
    push H                          ;0F9CFH 
    mvi  C, 00H                     ;0F9D0H 
    mov  D, A                       ;0F9D2H 
    call 0FA45H                     ;0F9D3H 
    mov  E, A                       ;0F9D6H 
    nop                             ;0F9D7H 
    nop                             ;0F9D8H 
    nop                             ;0F9D9H 
    nop                             ;0F9DAH 
    mov  A, C                       ;0F9DBH 
    ani  7FH                        ;0F9DCH 
    rlc                             ;0F9DEH 
    mov  C, A                       ;0F9DFH 
    nop                             ;0F9E0H 
    mvi  B, 00H                     ;0F9E1H 
    dcr  B                          ;0F9E3H 
    jnz  0F9F3H                     ;0F9E4H 
    nop                             ;0F9E7H 
    nop                             ;0F9E8H 
    nop                             ;0F9E9H 
    nop                             ;0F9EAH 
    nop                             ;0F9EBH 
    nop                             ;0F9ECH 
    nop                             ;0F9EDH 
    nop                             ;0F9EEH 
    nop                             ;0F9EFH 
    jmp  0FA4FH                     ;0F9F0H 
    call 0FA45H                     ;0F9F3H 
    cmp  E                          ;0F9F6H 
    jz   0F9E3H                     ;0F9F7H 
    nop                             ;0F9FAH 
    ora  C                          ;0F9FBH 
    mov  C, A                       ;0F9FCH 
    call 0F9C3H                     ;0F9FDH 
    call 0FA45H                     ;0FA00H 
    mov  E, A                       ;0FA03H 
    ora  D                          ;0FA04H 
    jp   0FA39H                     ;0FA05H 
    nop                             ;0FA08H 
    nop                             ;0FA09H 
    nop                             ;0FA0AH 
    nop                             ;0FA0BH 
    nop                             ;0FA0CH 
    nop                             ;0FA0DH 
    nop                             ;0FA0EH 
    nop                             ;0FA0FH 
    nop                             ;0FA10H 
    nop                             ;0FA11H 
    nop                             ;0FA12H 
    nop                             ;0FA13H 
    nop                             ;0FA14H 
    nop                             ;0FA15H 
    nop                             ;0FA16H 
    nop                             ;0FA17H 
    nop                             ;0FA18H 
    nop                             ;0FA19H 
    nop                             ;0FA1AH 
    nop                             ;0FA1BH 
    nop                             ;0FA1CH 
    nop                             ;0FA1DH 
    nop                             ;0FA1EH 
    nop                             ;0FA1FH 
    nop                             ;0FA20H 
    nop                             ;0FA21H 
    nop                             ;0FA22H 
    nop                             ;0FA23H 
    nop                             ;0FA24H 
    nop                             ;0FA25H 
    nop                             ;0FA26H 
    mvi  A, 0E6H                    ;0FA27H 
    sub  C                          ;0FA29H 
    jz   0FA34H                     ;0FA2AH 
    mvi  A, 19H                     ;0FA2DH 
    sub  C                          ;0FA2FH 
    jnz  0F9DBH                     ;0FA30H 
    cma                             ;0FA33H 
    sta  0F3DCH                     ;0FA34H 
    mvi  D, 09H                     ;0FA37H 
    dcr  D                          ;0FA39H 
    jnz  0F9DBH                     ;0FA3AH 
    lda  0F3DCH                     ;0FA3DH 
    xra  C                          ;0FA40H 
    pop  H                          ;0FA41H 
    pop D                           ;0FA42H 
    pop  B                          ;0FA43H 
    ret                             ;0FA44H 
    lda  0F402H                     ;0FA45H 
    rrc                             ;0FA48H 
    rrc                             ;0FA49H 
    rrc                             ;0FA4AH 
    rrc                             ;0FA4BH 
    ani  01H                        ;0FA4CH 
    ret                             ;0FA4EH 
    lhld 0F3D8H                     ;0FA4FH 
    pchl                            ;0FA52H 

SaveByteC:
    push PSW                        ;0FA53H 
    push B                          ;0FA54H 
    mvi  B, 08H                     ;0FA55H 
    nop                             ;0FA57H 
    nop                             ;0FA58H 
    nop                             ;0FA59H 
    nop                             ;0FA5AH 
    nop                             ;0FA5BH 
    mov  A, C                       ;0FA5CH 
    rlc                             ;0FA5DH 
    mov  C, A                       ;0FA5EH 
    mvi  A, 01H                     ;0FA5FH 
    xra  C                          ;0FA61H 
    sta  0F402H                     ;0FA62H 
    call 0F9BDH                     ;0FA65H 
    mvi  A, 00H                     ;0FA68H 
    xra  C                          ;0FA6AH 
    sta  0F402H                     ;0FA6BH 
    call 0F9BDH                     ;0FA6EH 
    dcr  B                          ;0FA71H 
    jnz  0FA5CH                     ;0FA72H 
    pop  B                          ;0FA75H 
    pop  psw                        ;0FA76H 
    ret                             ;0FA77H 

GetKeyStateA:
    xra  A                          ;0FA78H 
    sta  0F400H                     ;0FA79H 
    lda  0F401H                     ;0FA7CH 
    inr  A                          ;0FA7FH 
    rz                              ;0FA80H 
    mvi  A, 0FFH                    ;0FA81H 
    ret                             ;0FA83H 
    push B                          ;0FA84H 
    push D                          ;0FA85H 
    push H                          ;0FA86H 
    call InputkeyCodeA              ;0FA87H 
    cpi  0FFH                       ;0FA8AH 
    jnz  0FA92H                     ;0FA8CH 
    sta  0F3E6H                     ;0FA8FH 
    mvi  D, 00H                     ;0FA92H 
    inx  D                          ;0FA94H 
    dcr  E                          ;0FA95H 
    inr  E                          ;0FA96H 
    cz   0FD72H                     ;0FA97H 
    call InputkeyCodeA              ;0FA9AH 
    inr  A                          ;0FA9DH 
    jz   0FA94H                     ;0FA9EH 
    push PSW                        ;0FAA1H 
    mov  A, D                       ;0FAA2H 
    rrc                             ;0FAA3H 
    cnc  0FD72H                     ;0FAA4H 
    pop  psw                        ;0FAA7H 
    dcr  A                          ;0FAA8H 
    jp   0FACEH                     ;0FAA9H 
    lxi  D, 5540H                   ;0FAACH 
    lxi  H, 0F3E5H                  ;0FAAFH 
    mov  A, M                       ;0FAB2H 
    cma                             ;0FAB3H 
    mov  M, A                       ;0FAB4H 
    sta  0F402H                     ;0FAB5H 
    ana  A                          ;0FAB8H 
    mov  A, D                       ;0FAB9H 
    jz   0FABEH                     ;0FABAH 
    mov  A, E                       ;0FABDH 
    sta  0F3E7H                     ;0FABEH 
    call InputkeyCodeA              ;0FAC1H 
    inr  A                          ;0FAC4H 
    jnz  0FAC1H                     ;0FAC5H 
    call 0FD72H                     ;0FAC8H 
    jmp  0FA92H                     ;0FACBH 
    mov  E, A                       ;0FACEH 
    mvi  D, 14H                     ;0FACFH 
    lxi  H, 0F3E6H                  ;0FAD1H 
    cmp  M                          ;0FAD4H 
    jz   0FAE3H                     ;0FAD5H 
    dcr  D                          ;0FAD8H 
    jz   0FAE3H                     ;0FAD9H 
    call InputkeyCodeA              ;0FADCH 
    cmp  E                          ;0FADFH 
    jz   0FAD8H                     ;0FAE0H 
    call Reserv_Entry               ;0FAE3H 
    mov  M, E                       ;0FAE6H 
    call 0FD72H                     ;0FAE7H 
    mov  A, E                       ;0FAEAH 
    jmp  0FD00H                     ;0FAEBH 

InputkeyCodeA:
    push B                          ;0FAEEH 
    push D                          ;0FAEFH 
    push H                          ;0FAF0H 
    lxi  H, 0FD00H                  ;0FAF1H 
    push H                          ;0FAF4H 
    mvi  B, 00H                     ;0FAF5H 
    mvi  D, 09H                     ;0FAF7H 
    mvi  C, 0FEH                    ;0FAF9H 
    mov  A, C                       ;0FAFBH 
    sta  0F400H                     ;0FAFCH 
    rlc                             ;0FAFFH 
    mov  C, A                       ;0FB00H 
    lda  0F401H                     ;0FB01H 
    cpi  0FFH                       ;0FB04H 
    jz   0FB1AH                     ;0FB06H 
    mov  E, A                       ;0FB09H 
    lxi  H, 0600H                   ;0FB0AH 
    dcx  H                          ;0FB0DH 
    mov  A, H                       ;0FB0EH 
    ora  L                          ;0FB0FH 
    jnz  0FB0DH                     ;0FB10H 
    lda  0F401H                     ;0FB13H 
    cmp  E                          ;0FB16H 
    jz   0FB2DH                     ;0FB17H 
    mov  A, B                       ;0FB1AH 
    adi  08H                        ;0FB1BH 
    mov  B, A                       ;0FB1DH 
    dcr  D                          ;0FB1EH 
    jnz  0FAFBH                     ;0FB1FH 
    lda  0F402H                     ;0FB22H 
    ani  80H                        ;0FB25H 
    mvi  A, 0FEH                    ;0FB27H 
    rz                              ;0FB29H 
    inr  A                          ;0FB2AH 
    ret                             ;0FB2BH 
    inr  B                          ;0FB2CH 
    rar                             ;0FB2DH 
    jc   0FB2CH                     ;0FB2EH 
    mov  A, B                       ;0FB31H 
    ani  3FH                        ;0FB32H 
    cpi  10H                        ;0FB34H 
    jc   GetKeyCodeMap              ;0FB36H 
    cpi  3FH                        ;0FB39H 
    mov  B, A                       ;0FB3BH 
    mvi  A, 20H                     ;0FB3CH 
    rz                              ;0FB3EH 
    lda  0F402H                     ;0FB3FH 
    mov  C, A                       ;0FB42H 
    ani  40H                        ;0FB43H 
    jnz  0FB4CH                     ;0FB45H 
    mov  A, B                       ;0FB48H 
    ani  1FH                        ;0FB49H 
    ret                             ;0FB4BH 
    lda  0F3E5H                     ;0FB4CH 
    ana  A                          ;0FB4FH 
    jnz  0FB7BH                     ;0FB50H 
    mov  A, C                       ;0FB53H 
    ani  20H                        ;0FB54H 
    mov  A, B                       ;0FB56H 
    jz   0FB67H                     ;0FB57H 
    cpi  1CH                        ;0FB5AH 
    jm   0FB73H                     ;0FB5CH 
    cpi  20H                        ;0FB5FH 
    jm   0FB75H                     ;0FB61H 
    jmp  0FB73H                     ;0FB64H 
    cpi  1CH                        ;0FB67H 
    jc   0FB75H                     ;0FB69H 
    cpi  20H                        ;0FB6CH 
    jc   0FB73H                     ;0FB6EH 
    adi  20H                        ;0FB71H 
    adi  10H                        ;0FB73H 
    adi  10H                        ;0FB75H 
    pop  H                          ;0FB77H 
    jmp  0FD00H                     ;0FB78H 
    mov  A, C                       ;0FB7BH 
    ani  20H                        ;0FB7CH 
    mov  A, B                       ;0FB7EH 
    jz   0FB8FH                     ;0FB7FH 
    cpi  1CH                        ;0FB82H 
    jm   0FB73H                     ;0FB84H 
    cpi  20H                        ;0FB87H 
    jm   0FB75H                     ;0FB89H 
    jmp  0FB71H                     ;0FB8CH 
    cpi  1CH                        ;0FB8FH 
    jm   0FB75H                     ;0FB91H 
    jmp  0FB73H                     ;0FB94H 

GetKeyCodeMap:
    lxi  H, KeyCodeMap              ;0FB97H 
    mov  C, A                       ;0FB9AH 
    mvi  B, 00H                     ;0FB9BH 
    dad  B                          ;0FB9DH 
    mov  A, M                       ;0FB9EH 
    ret                             ;0FB9FH 

KeyCodeMap:
    DB    12                        ;0FBA0H Код клавиши \ (Home)
    DB    31                        ;0FBA1H Код клавиши СТР (Очистить экран)
    DB    27                        ;0FBA2H Код клавиши АР2 (Esc)
    DB    0                         ;0FBA3H Код клавиши F1
    DB    1                         ;0FBA4H Код клавиши F2
    DB    2                         ;0FBA5H Код клавиши F3
    DB    3                         ;0FBA6H Код клавиши F4
    DB    4                         ;0FBA7H Код клавиши F5
    DB    9                         ;0FBA8H Код клавиши TAB
    DB    10                        ;0FBA9H Код клавиши ПС
    DB    13                        ;0FBAAH Код клавиши ВК
    DB    127                       ;0FBABH Код клавиши ЗБ
    DB    8                         ;0FBACH Код клавиши ←
    DB    25                        ;0FBADH Код клавиши ↑
    DB    24                        ;0FBAEH Код клавиши →
    DB    26                        ;0FBAFH Код клавиши ↓
    DB    0                         ;0FBB0H 
    DB    0                         ;0FBB1H 
    DB    0                         ;0FBB2H 
    DB    0                         ;0FBB3H 
    DB    0                         ;0FBB4H 
    DB    0                         ;0FBB5H 
    DB    0                         ;0FBB6H 
    DB    0                         ;0FBB7H 
    DB    0                         ;0FBB8H 
    DB    0                         ;0FBB9H 
    DB    0                         ;0FBBAH 
    DB    0                         ;0FBBBH 
    DB    0                         ;0FBBCH 
    DB    0                         ;0FBBDH 
    DB    64                        ;0FBBEH 
    DB    0                         ;0FBBFH 
    DB    0                         ;0FBC0H 
    DB    0                         ;0FBC1H 
    DB    0                         ;0FBC2H 
    DB    0                         ;0FBC3H 
    DB    0                         ;0FBC4H 
    DB    0                         ;0FBC5H 
    DB    0                         ;0FBC6H 
    DB    0                         ;0FBC7H 
    DB    0                         ;0FBC8H 
    DB    0                         ;0FBC9H 
    DB    0                         ;0FBCAH 
    DB    0                         ;0FBCBH 
    DB    0                         ;0FBCCH 
    DB    0                         ;0FBCDH 
    DB    0                         ;0FBCEH 
    DB    0                         ;0FBCFH 
    DB    0                         ;0FBD0H 
    DB    0                         ;0FBD1H 
    DB    0                         ;0FBD2H 
    DB    0                         ;0FBD3H 
    DB    0                         ;0FBD4H 
    DB    0                         ;0FBD5H 
    DB    0                         ;0FBD6H 
    DB    0                         ;0FBD7H 
    DB    0                         ;0FBD8H 
    DB    0                         ;0FBD9H 
    DB    0                         ;0FBDAH 
    DB    0                         ;0FBDBH 
    DB    0                         ;0FBDCH 
    DB    0                         ;0FBDDH 
    DB    0                         ;0FBDEH 
    DB    0                         ;0FBDFH 
    DB    0                         ;0FBE0H 
    DB    0                         ;0FBE1H 
    DB    0                         ;0FBE2H 
    DB    0                         ;0FBE3H 
    DB    0                         ;0FBE4H 
    DB    0                         ;0FBE5H 
    DB    0                         ;0FBE6H 
    DB    128                       ;0FBE7H 
    DB    0                         ;0FBE8H 
    DB    128                       ;0FBE9H 
    DB    0                         ;0FBEAH 
    DB    0                         ;0FBEBH 
    DB    0                         ;0FBECH 
    DB    0                         ;0FBEDH 
    DB    0                         ;0FBEEH 
    DB    128                       ;0FBEFH 
    DB    0                         ;0FBF0H 
    DB    64                        ;0FBF1H 
    DB    0                         ;0FBF2H 
    DB    64                        ;0FBF3H 
    DB    0                         ;0FBF4H 
    DB    0                         ;0FBF5H 
    DB    0                         ;0FBF6H 
    DB    0                         ;0FBF7H 
    DB    0                         ;0FBF8H 
    DB    0                         ;0FBF9H 
    DB    0                         ;0FBFAH 
    DB    64                        ;0FBFBH 
    DB    0                         ;0FBFCH 
    DB    64                        ;0FBFDH 
    DB    0                         ;0FBFEH 
    DB    0                         ;0FBFFH 
    DB    0                         ;0FC00H 
    DB    0                         ;0FC01H 
    DB    0                         ;0FC02H 
    DB    0                         ;0FC03H 
    DB    0                         ;0FC04H 
    DB    0                         ;0FC05H 
    DB    0                         ;0FC06H 
    DB    0                         ;0FC07H 
    DB    0                         ;0FC08H 
    DB    0                         ;0FC09H 
    DB    0                         ;0FC0AH 
    DB    64                        ;0FC0BH 
    DB    0                         ;0FC0CH 
    DB    0                         ;0FC0DH 
    DB    0                         ;0FC0EH 
    DB    0                         ;0FC0FH 
    DB    0                         ;0FC10H 
    DB    0                         ;0FC11H 
    DB    0                         ;0FC12H 
    DB    0                         ;0FC13H 
    DB    0                         ;0FC14H 
    DB    0                         ;0FC15H 
    DB    0                         ;0FC16H 
    DB    0                         ;0FC17H 
    DB    0                         ;0FC18H 
    DB    0                         ;0FC19H 
    DB    0                         ;0FC1AH 
    DB    0                         ;0FC1BH 
    DB    0                         ;0FC1CH 
    DB    0                         ;0FC1DH 
    DB    0                         ;0FC1EH 
    DB    0                         ;0FC1FH 
    DB    0                         ;0FC20H 
    DB    0                         ;0FC21H 
    DB    0                         ;0FC22H 
    DB    0                         ;0FC23H 
    DB    0                         ;0FC24H 
    DB    0                         ;0FC25H 
    DB    128                       ;0FC26H 
    DB    0                         ;0FC27H 
    DB    0                         ;0FC28H 
    DB    0                         ;0FC29H 
    DB    0                         ;0FC2AH 
    DB    0                         ;0FC2BH 
    DB    0                         ;0FC2CH 
    DB    0                         ;0FC2DH 
    DB    0                         ;0FC2EH 
    DB    0                         ;0FC2FH 
    DB    0                         ;0FC30H 
    DB    0                         ;0FC31H 
    DB    0                         ;0FC32H 
    DB    0                         ;0FC33H 

DisplaySymA:
    push B                          ;0FC34H 
    mov  C, A                       ;0FC35H 
    mvi  B, 0C5H                    ;0FC36H 
    push D                          ;0FC38H 
    push H                          ;0FC39H 
    push PSW                        ;0FC3AH 
    mov  A, C                       ;0FC3BH 
    cpi  1BH                        ;0FC3CH 
    mvi  A, 0F0H                    ;0FC3EH 
    jz   0FD8AH                     ;0FC40H 
    lda  0F3DEH                     ;0FC43H 
    ana  A                          ;0FC46H 
    jnz  0FD90H                     ;0FC47H 
    mov  A, C                       ;0FC4AH 
    cpi  7FH                        ;0FC4BH 
    jnz  0FC5AH                     ;0FC4DH 
    lda  0F3D3H                     ;0FC50H 
    cma                             ;0FC53H 
    sta  0F3D3H                     ;0FC54H 
    jmp  0FCFFH                     ;0FC57H 
    mvi  H, 20H                     ;0FC5AH 
    sub  H                          ;0FC5CH 
    jc   0FCA4H                     ;0FC5DH 
    mov  L, A                       ;0FC60H 
    dad  H                          ;0FC61H 
    dad  H                          ;0FC62H 
    dad  H                          ;0FC63H 
    xchg                            ;0FC64H 
    lhld 0F3D1H                     ;0FC65H 
    dad  D                          ;0FC68H 
    xchg                            ;0FC69H 
    call 0FD44H                     ;0FC6AH 
    xchg                            ;0FC6DH 
    mvi  A, 16H                     ;0FC6EH 
    push PSW                        ;0FC70H 
    push H                          ;0FC71H 
    lda  0F3D3H                     ;0FC72H 
    xra  M                          ;0FC75H 
    ani  3FH                        ;0FC76H 
    mov  L, A                       ;0FC78H 
    lda  0F3DDH                     ;0FC79H 
    dcr  A                          ;0FC7CH 
    mvi  H, 00H                     ;0FC7DH 
    dad  H                          ;0FC7FH 
    dad  H                          ;0FC80H 
    inr  A                          ;0FC81H 
    jnz  0FC7FH                     ;0FC82H 
    xchg                            ;0FC85H 
    mov  A, B                       ;0FC86H 
    xra  M                          ;0FC87H 
    ana  M                          ;0FC88H 
    ora  D                          ;0FC89H 
    mov  M, A                       ;0FC8AH 
    inr  H                          ;0FC8BH 
    mov  A, C                       ;0FC8CH 
    xra  M                          ;0FC8DH 
    ana  M                          ;0FC8EH 
    ora  E                          ;0FC8FH 
    mov  M, A                       ;0FC90H 
    dcr  H                          ;0FC91H 
    inr  L                          ;0FC92H 
    xchg                            ;0FC93H 
    pop  H                          ;0FC94H 
    inx  H                          ;0FC95H 
    pop  psw                        ;0FC96H 
    sui  03H                        ;0FC97H 
    jp   0FC70H                     ;0FC99H 
    lxi  H, 0FD05H                  ;0FC9CH 
    cpi  0F8H                       ;0FC9FH 
    jnz  0FC70H                     ;0FCA1H 
    lhld 0F3D6H                     ;0FCA4H 
    call 0FD04H                     ;0FCA7H 
    dad  B                          ;0FCAAH 
    mov  A, H                       ;0FCABH 
    cpi  19H                        ;0FCACH 
    jc   0FCFCH                     ;0FCAEH 
    jnz  0FCFAH                     ;0FCB1H 
    inr  D                          ;0FCB4H 
    mov  H, D                       ;0FCB5H 
    jz   0FCFCH                     ;0FCB6H 
    push H                          ;0FCB9H 
    lxi  H, 0000H                   ;0FCBAH 
    dad  SP                         ;0FCBDH 
    shld 0F3DFH                     ;0FCBEH 
    lda  0F3D0H                     ;0FCC1H 
    mov  B, A                       ;0FCC4H 
    lda  0F3CFH                     ;0FCC5H 
    mov  H, A                       ;0FCC8H 
    lda  0F3D4H                     ;0FCC9H 
    mov  L, A                       ;0FCCCH 
    call 0FD6AH                     ;0FCCDH 
    mov  C, A                       ;0FCD0H 
    mov  A, C                       ;0FCD1H 
    adi  0AH                        ;0FCD2H 
    mov  L, A                       ;0FCD4H 
    sphl                            ;0FCD5H 
    mov  L, C                       ;0FCD6H 
    mvi  A, 0F0H                    ;0FCD7H 
    pop D                           ;0FCD9H 
    mov  M, E                       ;0FCDAH 
    inr  L                          ;0FCDBH 
    mov  M, D                       ;0FCDCH 
    inr  L                          ;0FCDDH 
    pop D                           ;0FCDEH 
    mov  M, E                       ;0FCDFH 
    inr  L                          ;0FCE0H 
    mov  M, D                       ;0FCE1H 
    inr  L                          ;0FCE2H 
    cmp  L                          ;0FCE3H 
    jnc  0FCD9H                     ;0FCE4H 
    lda  0F3D3H                     ;0FCE7H 
    inx  SP                         ;0FCEAH 
    mov  M, A                       ;0FCEBH 
    inr  L                          ;0FCECH 
    jnz  0FCEAH                     ;0FCEDH 
    inr  H                          ;0FCF0H 
    dcr  B                          ;0FCF1H 
    jnz  0FCD1H                     ;0FCF2H 
    lhld 0F3DFH                     ;0FCF5H 
    sphl                            ;0FCF8H 
    pop  H                          ;0FCF9H 
    mvi  H, 18H                     ;0FCFAH 
    shld 0F3D6H                     ;0FCFCH 
    pop  psw                        ;0FCFFH 
    pop  H                          ;0FD00H 
    pop D                           ;0FD01H 
    pop  B                          ;0FD02H 
    ret                             ;0FD03H 
    lxi  B, 0100H                   ;0FD04H 
    mov  D, C                       ;0FD07H 
    inr  A                          ;0FD08H 
    cz   0FDECH                     ;0FD09H 
    jz   0FD3FH                     ;0FD0CH 
    cpi  0EBH                       ;0FD0FH 
    rz                              ;0FD11H 
    dcr  D                          ;0FD12H 
    adi  05H                        ;0FD13H 
    rz                              ;0FD15H 
    inr  D                          ;0FD16H 
    mvi  B, 0FFH                    ;0FD17H 
    inr  A                          ;0FD19H 
    rz                              ;0FD1AH 
    mvi  C, 0FCH                    ;0FD1BH 
    cpi  0EFH                       ;0FD1DH 
    rz                              ;0FD1FH 
    lxi  B, 0000H                   ;0FD20H 
    cpi  0F0H                       ;0FD23H 
    jnz  0FD2FH                     ;0FD25H 
    mov  A, L                       ;0FD28H 
    ani  0E0H                       ;0FD29H 
    adi  20H                        ;0FD2BH 
    mov  L, A                       ;0FD2DH 
    ret                             ;0FD2EH 
    mvi  C, 04H                     ;0FD2FH 
    inr  A                          ;0FD31H 
    rz                              ;0FD32H 
    cpi  0EFH                       ;0FD33H 
    jz   Reserv_Entry               ;0FD35H 
    adi  0BH                        ;0FD38H 
    jz   0FD40H                     ;0FD3AH 
    inr  A                          ;0FD3DH 
    rnz                             ;0FD3EH 
    mov  H, D                       ;0FD3FH 
    mov  L, D                       ;0FD40H 
    mov  B, D                       ;0FD41H 
    mov  C, D                       ;0FD42H 
    ret                             ;0FD43H 
    lhld 0F3D6H                     ;0FD44H 
    mov  A, L                       ;0FD47H 
    rrc                             ;0FD48H 
    mov  L, A                       ;0FD49H 
    rrc                             ;0FD4AH 
    add  L                          ;0FD4BH 
    mov  B, A                       ;0FD4CH 
    mov  L, H                       ;0FD4DH 
    lda  0F3CFH                     ;0FD4EH 
    mov  H, A                       ;0FD51H 
    mov  A, B                       ;0FD52H 
    dcr  H                          ;0FD53H 
    inr  H                          ;0FD54H 
    sui  04H                        ;0FD55H 
    jnc  0FD54H                     ;0FD57H 
    sta  0F3DDH                     ;0FD5AH 
    push H                          ;0FD5DH 
    lxi  H, 00FCH                   ;0FD5EH 
    dad  H                          ;0FD61H 
    dad  H                          ;0FD62H 
    inr  A                          ;0FD63H 
    jnz  0FD61H                     ;0FD64H 
    mov  B, H                       ;0FD67H 
    mov  C, L                       ;0FD68H 
    pop  H                          ;0FD69H 
    mov  A, L                       ;0FD6AH 
    rlc                             ;0FD6BH 
    rlc                             ;0FD6CH 
    rlc                             ;0FD6DH 
    add  L                          ;0FD6EH 
    add  L                          ;0FD6FH 
    mov  L, A                       ;0FD70H 
    ret                             ;0FD71H 
    call 0FD44H                     ;0FD72H 
    adi  09H                        ;0FD75H 
    mov  L, A                       ;0FD77H 
    mov  A, B                       ;0FD78H 
    xra  M                          ;0FD79H 
    mov  M, A                       ;0FD7AH 
    inr  H                          ;0FD7BH 
    mov  A, C                       ;0FD7CH 
    xra  M                          ;0FD7DH 
    mov  M, A                       ;0FD7EH 
    dcr  H                          ;0FD7FH 
    ret                             ;0FD80H 
    mov  A, C                       ;0FD81H 
    cpi  59H                        ;0FD82H 
    jnz  0FD9EH                     ;0FD84H 
    mvi  A, 02H                     ;0FD87H 
    ora  B                          ;0FD89H 
    sta  0F3DEH                     ;0FD8AH 
    jmp  0FCFFH                     ;0FD8DH 
    mov  B, A                       ;0FD90H 
    ani  03H                        ;0FD91H 
    jz   0FD81H                     ;0FD93H 
    dcr  A                          ;0FD96H 
    jz   0FDD3H                     ;0FD97H 
    dcr  A                          ;0FD9AH 
    jz   0FDE1H                     ;0FD9BH 
    xra  A                          ;0FD9EH 
    sta  0F3DEH                     ;0FD9FH 
    mov  A, C                       ;0FDA2H 
    cpi  4AH                        ;0FDA3H 
    jz   0FDF6H                     ;0FDA5H 
    cpi  4BH                        ;0FDA8H 
    jz   0FE1EH                     ;0FDAAH 
    lxi  H, 0FC4AH                  ;0FDADH 
    push H                          ;0FDB0H 
    mvi  C, 18H                     ;0FDB1H 
    cpi  43H                        ;0FDB3H 
    rz                              ;0FDB5H 
    inr  C                          ;0FDB6H 
    cpi  41H                        ;0FDB7H 
    rz                              ;0FDB9H 
    inr  C                          ;0FDBAH 
    cpi  42H                        ;0FDBBH 
    rz                              ;0FDBDH 
    mvi  C, 08H                     ;0FDBEH 
    cpi  44H                        ;0FDC0H 
    rz                              ;0FDC2H 
    mvi  C, 0CH                     ;0FDC3H 
    cpi  48H                        ;0FDC5H 
    rz                              ;0FDC7H 
    mvi  C, 1FH                     ;0FDC8H 
    cpi  45H                        ;0FDCAH 
    rz                              ;0FDCCH 
    cmp  C                          ;0FDCDH 
    rz                              ;0FDCEH 
    pop  H                          ;0FDCFH 
    jmp  0FCFFH                     ;0FDD0H 
    mov  A, C                       ;0FDD3H 
    sui  20H                        ;0FDD4H 
    rlc                             ;0FDD6H 
    rlc                             ;0FDD7H 
    ani  0FCH                       ;0FDD8H 
    sta  0F3D6H                     ;0FDDAH 
    xra  A                          ;0FDDDH 
    jmp  0FD8AH                     ;0FDDEH 
    mov  A, C                       ;0FDE1H 
    sui  20H                        ;0FDE2H 
    sta  0F3D7H                     ;0FDE4H 
    mvi  A, 0F1H                    ;0FDE7H 
    jmp  0FD8AH                     ;0FDE9H 
    push B                          ;0FDECH 
    push D                          ;0FDEDH 
    push H                          ;0FDEEH 
    push PSW                        ;0FDEFH 
    lda  0F3D4H                     ;0FDF0H 
    jmp  0FDFAH                     ;0FDF3H 
    lda  0F3D7H                     ;0FDF6H 
    inr  A                          ;0FDF9H 
    cpi  19H                        ;0FDFAH 
    jnc  0FCFFH                     ;0FDFCH 
    mov  L, A                       ;0FDFFH 
    call 0FD6AH                     ;0FE00H 
    mov  C, A                       ;0FE03H 
    lda  0F3CFH                     ;0FE04H 
    mov  H, A                       ;0FE07H 
    lda  0F3D0H                     ;0FE08H 
    mov  B, A                       ;0FE0BH 
    dcr  H                          ;0FE0CH 
    inr  H                          ;0FE0DH 
    mov  L, C                       ;0FE0EH 
    lda  0F3D3H                     ;0FE0FH 
    mov  M, A                       ;0FE12H 
    inr  L                          ;0FE13H 
    jnz  0FE12H                     ;0FE14H 
    dcr  B                          ;0FE17H 
    jnz  0FE0DH                     ;0FE18H 
    jmp  0FCFFH                     ;0FE1BH 
    lhld 0F3D6H                     ;0FE1EH 
    push H                          ;0FE21H 
    mov  B, L                       ;0FE22H 
    mvi  C, 20H                     ;0FE23H 
    call 0FC37H                     ;0FE25H 
    mvi  A, 04H                     ;0FE28H 
    add  B                          ;0FE2AH 
    mov  B, A                       ;0FE2BH 
    jnz  0FE25H                     ;0FE2CH 
    pop  H                          ;0FE2FH 
    jmp  0FCFCH                     ;0FE30H 
    mvi  C, 15H                     ;0FE33H 
    lda  0F3E7H                     ;0FE35H 
    ei                              ;0FE38H 
    dcr  A                          ;0FE39H 
    jnz  0FE38H                     ;0FE3AH 
    lda  0F3E7H                     ;0FE3DH 
    di                              ;0FE40H 
    dcr  A                          ;0FE41H 
    jnz  0FE40H                     ;0FE42H 
    dcr  C                          ;0FE45H 
    jnz  0FE35H                     ;0FE46H 
    ret                             ;0FE49H 

CodePageTable:
;0FE4AH-0FE4AH ' '
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
    DB    11000000B                 ;0FE4AH
;0FE4BH-0FE4DH '!'
;░░░░░░░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░░░░
;░░░░░█░░
    DB    10000100B                 ;0FE4BH
    DB    00000000B                 ;0FE4CH 
    DB    00000100B                 ;0FE4DH 
;0FE4EH-0FE4FH '"'
;░░░░░░░░
;░░░░█░█░
;░░░░█░█░
;░░░░█░█░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
    DB    01001010B                 ;0FE4EH
    DB    01100000B                 ;0FE4FH 
;0FE50H-0FE54H '#'
;░░░░░░░░
;░░░░█░█░
;░░░░█░█░
;░░░█████
;░░░░█░█░
;░░░█████
;░░░░█░█░
;░░░░█░█░
    DB    00101010B                 ;0FE50H
    DB    00011111B                 ;0FE51H 
    DB    00001010B                 ;0FE52H 
    DB    00011111B                 ;0FE53H 
    DB    00101010B                 ;0FE54H 
;0FE55H-0FE59H '¤'
;░░░░░░░░
;░░░█░░░█
;░░░░███░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░░███░
;░░░█░░░█
    DB    00010001B                 ;0FE55H
    DB    00001110B                 ;0FE56H 
    DB    01010001B                 ;0FE57H 
    DB    00001110B                 ;0FE58H 
    DB    00010001B                 ;0FE59H 
;0FE5AH-0FE60H '%'
;░░░░░░░░
;░░░██░░░
;░░░██░░█
;░░░░░░█░
;░░░░░█░░
;░░░░█░░░
;░░░█░░██
;░░░░░░██
    DB    00011000B                 ;0FE5AH
    DB    00011001B                 ;0FE5BH 
    DB    00000010B                 ;0FE5CH 
    DB    00000100B                 ;0FE5DH 
    DB    00001000B                 ;0FE5EH 
    DB    00010011B                 ;0FE5FH 
    DB    00000011B                 ;0FE60H 
;0FE61H-0FE66H '&'
;░░░░░░░░
;░░░░░█░░
;░░░░█░█░
;░░░░█░█░
;░░░░██░░
;░░░█░█░█
;░░░█░░█░
;░░░░██░█
    DB    00000100B                 ;0FE61H
    DB    00101010B                 ;0FE62H 
    DB    00001100B                 ;0FE63H 
    DB    00010101B                 ;0FE64H 
    DB    00010010B                 ;0FE65H 
    DB    00001101B                 ;0FE66H 
;0FE67H-0FE6AH '''
;░░░░░░░░
;░░░░░██░
;░░░░░██░
;░░░░░░█░
;░░░░░█░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
    DB    00100110B                 ;0FE67H
    DB    00000010B                 ;0FE68H 
    DB    00000100B                 ;0FE69H 
    DB    01000000B                 ;0FE6AH 
;0FE6BH-0FE6FH '('
;░░░░░░░░
;░░░░░░█░
;░░░░░█░░
;░░░░█░░░
;░░░░█░░░
;░░░░█░░░
;░░░░░█░░
;░░░░░░█░
    DB    00000010B                 ;0FE6BH
    DB    00000100B                 ;0FE6CH 
    DB    01001000B                 ;0FE6DH 
    DB    00000100B                 ;0FE6EH 
    DB    00000010B                 ;0FE6FH 
;0FE70H-0FE74H ')'
;░░░░░░░░
;░░░░█░░░
;░░░░░█░░
;░░░░░░█░
;░░░░░░█░
;░░░░░░█░
;░░░░░█░░
;░░░░█░░░
    DB    00001000B                 ;0FE70H
    DB    00000100B                 ;0FE71H 
    DB    01000010B                 ;0FE72H 
    DB    00000100B                 ;0FE73H 
    DB    00001000B                 ;0FE74H 
;0FE75H-0FE7BH '*'
;░░░░░░░░
;░░░░░░░░
;░░░░░█░░
;░░░█░█░█
;░░░░███░
;░░░█░█░█
;░░░░░█░░
;░░░░░░░░
    DB    00000000B                 ;0FE75H
    DB    00000100B                 ;0FE76H 
    DB    00010101B                 ;0FE77H 
    DB    00001110B                 ;0FE78H 
    DB    00010101B                 ;0FE79H 
    DB    00000100B                 ;0FE7AH 
    DB    00000000B                 ;0FE7BH 
;0FE7CH-0FE80H '+'
;░░░░░░░░
;░░░░░░░░
;░░░░░█░░
;░░░░░█░░
;░░░█████
;░░░░░█░░
;░░░░░█░░
;░░░░░░░░
    DB    00000000B                 ;0FE7CH
    DB    00100100B                 ;0FE7DH 
    DB    00011111B                 ;0FE7EH 
    DB    00100100B                 ;0FE7FH 
    DB    00000000B                 ;0FE80H 
;0FE81H-0FE84H ','
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░██░░
;░░░░██░░
;░░░░░█░░
;░░░░█░░░
    DB    01000000B                 ;0FE81H
    DB    00101100B                 ;0FE82H 
    DB    00000100B                 ;0FE83H 
    DB    00001000B                 ;0FE84H 
;0FE85H-0FE87H '-'
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░█████
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
    DB    01000000B                 ;0FE85H
    DB    00011111B                 ;0FE86H 
    DB    01000000B                 ;0FE87H 
;0FE88H-0FE89H '.'
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░██░░
;░░░░██░░
    DB    10000000B                 ;0FE88H
    DB    00101100B                 ;0FE89H 
;0FE8AH-0FE90H '/'
;░░░░░░░░
;░░░░░░░░
;░░░░░░░█
;░░░░░░█░
;░░░░░█░░
;░░░░█░░░
;░░░█░░░░
;░░░░░░░░
    DB    00000000B                 ;0FE8AH
    DB    00000001B                 ;0FE8BH 
    DB    00000010B                 ;0FE8CH 
    DB    00000100B                 ;0FE8DH 
    DB    00001000B                 ;0FE8EH 
    DB    00010000B                 ;0FE8FH 
    DB    00000000B                 ;0FE90H 
;0FE91H-0FE97H '0'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░██
;░░░█░█░█
;░░░██░░█
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FE91H
    DB    00010001B                 ;0FE92H 
    DB    00010011B                 ;0FE93H 
    DB    00010101B                 ;0FE94H 
    DB    00011001B                 ;0FE95H 
    DB    00010001B                 ;0FE96H 
    DB    00001110B                 ;0FE97H 
;0FE98H-0FE9BH '1'
;░░░░░░░░
;░░░░░█░░
;░░░░██░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░███░
    DB    00000100B                 ;0FE98H
    DB    00001100B                 ;0FE99H 
    DB    01100100B                 ;0FE9AH 
    DB    00001110B                 ;0FE9BH 
;0FE9CH-0FEA2H '2'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░░░░░█
;░░░░░██░
;░░░░█░░░
;░░░█░░░░
;░░░█████
    DB    00001110B                 ;0FE9CH
    DB    00010001B                 ;0FE9DH 
    DB    00000001B                 ;0FE9EH 
    DB    00000110B                 ;0FE9FH 
    DB    00001000B                 ;0FEA0H 
    DB    00010000B                 ;0FEA1H 
    DB    00011111B                 ;0FEA2H 
;0FEA3H-0FEA9H '3'
;░░░░░░░░
;░░░█████
;░░░░░░░█
;░░░░░░█░
;░░░░░██░
;░░░░░░░█
;░░░█░░░█
;░░░░███░
    DB    00011111B                 ;0FEA3H
    DB    00000001B                 ;0FEA4H 
    DB    00000010B                 ;0FEA5H 
    DB    00000110B                 ;0FEA6H 
    DB    00000001B                 ;0FEA7H 
    DB    00010001B                 ;0FEA8H 
    DB    00001110B                 ;0FEA9H 
;0FEAAH-0FEAFH '4'
;░░░░░░░░
;░░░░░░█░
;░░░░░██░
;░░░░█░█░
;░░░█░░█░
;░░░█████
;░░░░░░█░
;░░░░░░█░
    DB    00000010B                 ;0FEAAH
    DB    00000110B                 ;0FEABH 
    DB    00001010B                 ;0FEACH 
    DB    00010010B                 ;0FEADH 
    DB    00011111B                 ;0FEAEH 
    DB    00100010B                 ;0FEAFH 
;0FEB0H-0FEB5H '5'
;░░░░░░░░
;░░░█████
;░░░█░░░░
;░░░████░
;░░░░░░░█
;░░░░░░░█
;░░░█░░░█
;░░░░███░
    DB    00011111B                 ;0FEB0H
    DB    00010000B                 ;0FEB1H 
    DB    00011110B                 ;0FEB2H 
    DB    00100001B                 ;0FEB3H 
    DB    00010001B                 ;0FEB4H 
    DB    00001110B                 ;0FEB5H 
;0FEB6H-0FEBBH '6'
;░░░░░░░░
;░░░░░███
;░░░░█░░░
;░░░█░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░░███░
    DB    00000111B                 ;0FEB6H
    DB    00001000B                 ;0FEB7H 
    DB    00010000B                 ;0FEB8H 
    DB    00011110B                 ;0FEB9H 
    DB    00110001B                 ;0FEBAH 
    DB    00001110B                 ;0FEBBH 
;0FEBCH-0FEC0H '7'
;░░░░░░░░
;░░░█████
;░░░░░░░█
;░░░░░░█░
;░░░░░█░░
;░░░░█░░░
;░░░░█░░░
;░░░░█░░░
    DB    00011111B                 ;0FEBCH
    DB    00000001B                 ;0FEBDH 
    DB    00000010B                 ;0FEBEH 
    DB    00000100B                 ;0FEBFH 
    DB    01001000B                 ;0FEC0H 
;0FEC1H-0FEC5H '8'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░█
;░░░░███░
;░░░█░░░█
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FEC1H
    DB    00110001B                 ;0FEC2H 
    DB    00001110B                 ;0FEC3H 
    DB    00110001B                 ;0FEC4H 
    DB    00001110B                 ;0FEC5H 
;0FEC6H-0FECBH '9'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░█
;░░░░████
;░░░░░░░█
;░░░░░░█░
;░░░███░░
    DB    00001110B                 ;0FEC6H
    DB    00110001B                 ;0FEC7H 
    DB    00001111B                 ;0FEC8H 
    DB    00000001B                 ;0FEC9H 
    DB    00000010B                 ;0FECAH 
    DB    00011100B                 ;0FECBH 
;0FECCH-0FECFH двоеточие
;░░░░░░░░
;░░░░░░░░
;░░░░██░░
;░░░░██░░
;░░░░░░░░
;░░░░░░░░
;░░░░██░░
;░░░░██░░
    DB    00000000B                 ;0FECCH
    DB    00101100B                 ;0FECDH 
    DB    00100000B                 ;0FECEH 
    DB    00101100B                 ;0FECFH 
;0FED0H-0FED4H '
;'
;░░░░░░░░
;░░░░██░░
;░░░░██░░
;░░░░░░░░
;░░░░██░░
;░░░░██░░
;░░░░░█░░
;░░░░█░░░
    DB    00101100B                 ;0FED0H
    DB    00000000B                 ;0FED1H 
    DB    00101100B                 ;0FED2H 
    DB    00000100B                 ;0FED3H 
    DB    00001000B                 ;0FED4H 
;0FED5H-0FEDBH '<'
;░░░░░░░░
;░░░░░░█░
;░░░░░█░░
;░░░░█░░░
;░░░█░░░░
;░░░░█░░░
;░░░░░█░░
;░░░░░░█░
    DB    00000010B                 ;0FED5H
    DB    00000100B                 ;0FED6H 
    DB    00001000B                 ;0FED7H 
    DB    00010000B                 ;0FED8H 
    DB    00001000B                 ;0FED9H 
    DB    00000100B                 ;0FEDAH 
    DB    00000010B                 ;0FEDBH 
;0FEDCH-0FEE0H '='
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░█████
;░░░░░░░░
;░░░█████
;░░░░░░░░
;░░░░░░░░
    DB    00100000B                 ;0FEDCH
    DB    00011111B                 ;0FEDDH 
    DB    00000000B                 ;0FEDEH 
    DB    00011111B                 ;0FEDFH 
    DB    00100000B                 ;0FEE0H 
;0FEE1H-0FEE7H '>'
;░░░░░░░░
;░░░░█░░░
;░░░░░█░░
;░░░░░░█░
;░░░░░░░█
;░░░░░░█░
;░░░░░█░░
;░░░░█░░░
    DB    00001000B                 ;0FEE1H
    DB    00000100B                 ;0FEE2H 
    DB    00000010B                 ;0FEE3H 
    DB    00000001B                 ;0FEE4H 
    DB    00000010B                 ;0FEE5H 
    DB    00000100B                 ;0FEE6H 
    DB    00001000B                 ;0FEE7H 
;0FEE8H-0FEEEH '?'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░░░░░█
;░░░░░░█░
;░░░░░█░░
;░░░░░░░░
;░░░░░█░░
    DB    00001110B                 ;0FEE8H
    DB    00010001B                 ;0FEE9H 
    DB    00000001B                 ;0FEEAH 
    DB    00000010B                 ;0FEEBH 
    DB    00000100B                 ;0FEECH 
    DB    00000000B                 ;0FEEDH 
    DB    00000100B                 ;0FEEEH 
;0FEEFH-0FEF5H '@'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░██
;░░░█░█░█
;░░░█░███
;░░░█░░░░
;░░░░███░
    DB    00001110B                 ;0FEEFH
    DB    00010001B                 ;0FEF0H 
    DB    00010011B                 ;0FEF1H 
    DB    00010101B                 ;0FEF2H 
    DB    00010111B                 ;0FEF3H 
    DB    00010000B                 ;0FEF4H 
    DB    00001110B                 ;0FEF5H 
;0FEF6H-0FEFAH 'A'
;░░░░░░░░
;░░░░░█░░
;░░░░█░█░
;░░░█░░░█
;░░░█░░░█
;░░░█████
;░░░█░░░█
;░░░█░░░█
    DB    00000100B                 ;0FEF6H
    DB    00001010B                 ;0FEF7H 
    DB    00110001B                 ;0FEF8H 
    DB    00011111B                 ;0FEF9H 
    DB    00110001B                 ;0FEFAH 
;0FEFBH-0FEFFH 'B'
;░░░░░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
    DB    00011110B                 ;0FEFBH
    DB    00110001B                 ;0FEFCH 
    DB    00011110B                 ;0FEFDH 
    DB    00110001B                 ;0FEFEH 
    DB    00011110B                 ;0FEFFH 
;0FF00H-0FF04H 'C'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FF00H
    DB    00010001B                 ;0FF01H 
    DB    01010000B                 ;0FF02H 
    DB    00010001B                 ;0FF03H 
    DB    00001110B                 ;0FF04H 
;0FF05H-0FF07H 'D'
;░░░░░░░░
;░░░████░
;░░░░█░░█
;░░░░█░░█
;░░░░█░░█
;░░░░█░░█
;░░░░█░░█
;░░░████░
    DB    00011110B                 ;0FF05H
    DB    10001001B                 ;0FF06H 
    DB    00011110B                 ;0FF07H 
;0FF08H-0FF0CH 'E'
;░░░░░░░░
;░░░█████
;░░░█░░░░
;░░░█░░░░
;░░░████░
;░░░█░░░░
;░░░█░░░░
;░░░█████
    DB    00011111B                 ;0FF08H
    DB    00110000B                 ;0FF09H 
    DB    00011110B                 ;0FF0AH 
    DB    00110000B                 ;0FF0BH 
    DB    00011111B                 ;0FF0CH 
;0FF0DH-0FF10H 'F'
;░░░░░░░░
;░░░█████
;░░░█░░░░
;░░░█░░░░
;░░░████░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
    DB    00011111B                 ;0FF0DH
    DB    00110000B                 ;0FF0EH 
    DB    00011110B                 ;0FF0FH 
    DB    01010000B                 ;0FF10H 
;0FF11H-0FF16H 'G'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░░
;░░░█░░░░
;░░░█░░██
;░░░█░░░█
;░░░░████
    DB    00001110B                 ;0FF11H
    DB    00010001B                 ;0FF12H 
    DB    00110000B                 ;0FF13H 
    DB    00010011B                 ;0FF14H 
    DB    00010001B                 ;0FF15H 
    DB    00001111B                 ;0FF16H 
;0FF17H-0FF19H 'H'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█████
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
    DB    01010001B                 ;0FF17H
    DB    00011111B                 ;0FF18H 
    DB    01010001B                 ;0FF19H 
;0FF1AH-0FF1CH 'I'
;░░░░░░░░
;░░░░███░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░███░
    DB    00001110B                 ;0FF1AH
    DB    10000100B                 ;0FF1BH 
    DB    00001110B                 ;0FF1CH 
;0FF1DH-0FF1FH 'J'
;░░░░░░░░
;░░░░░░░█
;░░░░░░░█
;░░░░░░░█
;░░░░░░░█
;░░░█░░░█
;░░░█░░░█
;░░░░███░
    DB    01100001B                 ;0FF1DH
    DB    00110001B                 ;0FF1EH 
    DB    00001110B                 ;0FF1FH 
;0FF20H-0FF26H 'K'
;░░░░░░░░
;░░░█░░░█
;░░░█░░█░
;░░░█░█░░
;░░░██░░░
;░░░█░█░░
;░░░█░░█░
;░░░█░░░█
    DB    00010001B                 ;0FF20H
    DB    00010010B                 ;0FF21H 
    DB    00010100B                 ;0FF22H 
    DB    00011000B                 ;0FF23H 
    DB    00010100B                 ;0FF24H 
    DB    00010010B                 ;0FF25H 
    DB    00010001B                 ;0FF26H 
;0FF27H-0FF29H 'L'
;░░░░░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░█
;░░░█████
    DB    10010000B                 ;0FF27H
    DB    00010001B                 ;0FF28H 
    DB    00011111B                 ;0FF29H 
;0FF2AH-0FF2DH 'M'
;░░░░░░░░
;░░░█░░░█
;░░░██░██
;░░░█░█░█
;░░░█░█░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
    DB    00010001B                 ;0FF2AH
    DB    00011011B                 ;0FF2BH 
    DB    00110101B                 ;0FF2CH 
    DB    01010001B                 ;0FF2DH 
;0FF2EH-0FF32H 'N'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░██░░█
;░░░█░█░█
;░░░█░░██
;░░░█░░░█
;░░░█░░░█
    DB    00110001B                 ;0FF2EH
    DB    00011001B                 ;0FF2FH 
    DB    00010101B                 ;0FF30H 
    DB    00010011B                 ;0FF31H 
    DB    00110001B                 ;0FF32H 
;0FF33H-0FF35H 'O'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FF33H
    DB    10010001B                 ;0FF34H 
    DB    00001110B                 ;0FF35H 
;0FF36H-0FF39H 'P'
;░░░░░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
    DB    00011110B                 ;0FF36H
    DB    00110001B                 ;0FF37H 
    DB    00011110B                 ;0FF38H 
    DB    01010000B                 ;0FF39H 
;0FF3AH-0FF3EH 'Q'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░█░█
;░░░█░░█░
;░░░░██░█
    DB    00001110B                 ;0FF3AH
    DB    01010001B                 ;0FF3BH 
    DB    00010101B                 ;0FF3CH 
    DB    00010010B                 ;0FF3DH 
    DB    00001101B                 ;0FF3EH 
;0FF3FH-0FF44H 'R'
;░░░░░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
;░░░█░█░░
;░░░█░░█░
;░░░█░░░█
    DB    00011110B                 ;0FF3FH
    DB    00110001B                 ;0FF40H 
    DB    00011110B                 ;0FF41H 
    DB    00010100B                 ;0FF42H 
    DB    00010010B                 ;0FF43H 
    DB    00010001B                 ;0FF44H 
;0FF45H-0FF4BH 'S'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░░
;░░░░███░
;░░░░░░░█
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FF45H
    DB    00010001B                 ;0FF46H 
    DB    00010000B                 ;0FF47H 
    DB    00001110B                 ;0FF48H 
    DB    00000001B                 ;0FF49H 
    DB    00010001B                 ;0FF4AH 
    DB    00001110B                 ;0FF4BH 
;0FF4CH-0FF4DH 'T'
;░░░░░░░░
;░░░█████
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
    DB    00011111B                 ;0FF4CH
    DB    10100100B                 ;0FF4DH 
;0FF4EH-0FF4FH 'U'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░░███░
    DB    10110001B                 ;0FF4EH
    DB    00001110B                 ;0FF4FH 
;0FF50H-0FF52H 'V'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░░█░█░
;░░░░█░█░
;░░░░░█░░
;░░░░░█░░
    DB    01010001B                 ;0FF50H
    DB    00101010B                 ;0FF51H 
    DB    00100100B                 ;0FF52H 
;0FF53H-0FF55H 'W'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░█░█
;░░░█░█░█
;░░░█░█░█
;░░░░█░█░
    DB    01010001B                 ;0FF53H
    DB    01010101B                 ;0FF54H 
    DB    00001010B                 ;0FF55H 
;0FF56H-0FF5AH 'X'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░░█░█░
;░░░░░█░░
;░░░░█░█░
;░░░█░░░█
;░░░█░░░█
    DB    00110001B                 ;0FF56H
    DB    00001010B                 ;0FF57H 
    DB    00000100B                 ;0FF58H 
    DB    00001010B                 ;0FF59H 
    DB    00110001B                 ;0FF5AH 
;0FF5BH-0FF5DH 'Y'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░░█░█░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
    DB    00110001B                 ;0FF5BH
    DB    00001010B                 ;0FF5CH 
    DB    01100100B                 ;0FF5DH 
;0FF5EH-0FF64H 'Z'
;░░░░░░░░
;░░░█████
;░░░░░░░█
;░░░░░░█░
;░░░░███░
;░░░░█░░░
;░░░█░░░░
;░░░█████
    DB    00011111B                 ;0FF5EH
    DB    00000001B                 ;0FF5FH 
    DB    00000010B                 ;0FF60H 
    DB    00001110B                 ;0FF61H 
    DB    00001000B                 ;0FF62H 
    DB    00010000B                 ;0FF63H 
    DB    00011111B                 ;0FF64H 
;0FF65H-0FF67H '['
;░░░░░░░░
;░░░░███░
;░░░░█░░░
;░░░░█░░░
;░░░░█░░░
;░░░░█░░░
;░░░░█░░░
;░░░░███░
    DB    00001110B                 ;0FF65H
    DB    10001000B                 ;0FF66H 
    DB    00001110B                 ;0FF67H 
;0FF68H-0FF6EH '\'
;░░░░░░░░
;░░░░░░░░
;░░░█░░░░
;░░░░█░░░
;░░░░░█░░
;░░░░░░█░
;░░░░░░░█
;░░░░░░░░
    DB    00000000B                 ;0FF68H
    DB    00010000B                 ;0FF69H 
    DB    00001000B                 ;0FF6AH 
    DB    00000100B                 ;0FF6BH 
    DB    00000010B                 ;0FF6CH 
    DB    00000001B                 ;0FF6DH 
    DB    00000000B                 ;0FF6EH 
;0FF6FH-0FF71H ']'
;░░░░░░░░
;░░░░███░
;░░░░░░█░
;░░░░░░█░
;░░░░░░█░
;░░░░░░█░
;░░░░░░█░
;░░░░███░
    DB    00001110B                 ;0FF6FH
    DB    10000010B                 ;0FF70H 
    DB    00001110B                 ;0FF71H 
;0FF72H-0FF74H '^'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
    DB    00001110B                 ;0FF72H
    DB    00010001B                 ;0FF73H 
    DB    10000000B                 ;0FF74H 
;0FF75H-0FF76H '_'
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░█████
    DB    10100000B                 ;0FF75H
    DB    00011111B                 ;0FF76H 
;0FF77H-0FF7BH 'Ю'
;░░░░░░░░
;░░░█░░█░
;░░░█░█░█
;░░░█░█░█
;░░░███░█
;░░░█░█░█
;░░░█░█░█
;░░░█░░█░
    DB    00010010B                 ;0FF77H
    DB    00110101B                 ;0FF78H 
    DB    00011101B                 ;0FF79H 
    DB    00110101B                 ;0FF7AH 
    DB    00010010B                 ;0FF7BH 
;0FF7CH-0FF80H 'А'
;░░░░░░░░
;░░░░░█░░
;░░░░█░█░
;░░░█░░░█
;░░░█░░░█
;░░░█████
;░░░█░░░█
;░░░█░░░█
    DB    00000100B                 ;0FF7CH
    DB    00001010B                 ;0FF7DH 
    DB    00110001B                 ;0FF7EH 
    DB    00011111B                 ;0FF7FH 
    DB    00110001B                 ;0FF80H 
;0FF81H-0FF85H 'Б'
;░░░░░░░░
;░░░█████
;░░░█░░░░
;░░░█░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
    DB    00011111B                 ;0FF81H
    DB    00110000B                 ;0FF82H 
    DB    00011110B                 ;0FF83H 
    DB    00110001B                 ;0FF84H 
    DB    00011110B                 ;0FF85H 
;0FF86H-0FF88H 'Ц'
;░░░░░░░░
;░░░█░░█░
;░░░█░░█░
;░░░█░░█░
;░░░█░░█░
;░░░█░░█░
;░░░█████
;░░░░░░░█
    DB    10010010B                 ;0FF86H
    DB    00011111B                 ;0FF87H 
    DB    00000001B                 ;0FF88H 
;0FF89H-0FF8CH 'Д'
;░░░░░░░░
;░░░░░██░
;░░░░█░█░
;░░░░█░█░
;░░░░█░█░
;░░░░█░█░
;░░░█████
;░░░█░░░█
    DB    00000110B                 ;0FF89H
    DB    01101010B                 ;0FF8AH 
    DB    00011111B                 ;0FF8BH 
    DB    00010001B                 ;0FF8CH 
;0FF8DH-0FF91H 'Е'
;░░░░░░░░
;░░░█████
;░░░█░░░░
;░░░█░░░░
;░░░████░
;░░░█░░░░
;░░░█░░░░
;░░░█████
    DB    00011111B                 ;0FF8DH
    DB    00110000B                 ;0FF8EH 
    DB    00011110B                 ;0FF8FH 
    DB    00110000B                 ;0FF90H 
    DB    00011111B                 ;0FF91H 
;0FF92H-0FF96H 'Ф'
;░░░░░░░░
;░░░░░█░░
;░░░█████
;░░░█░█░█
;░░░█░█░█
;░░░█████
;░░░░░█░░
;░░░░░█░░
    DB    00000100B                 ;0FF92H
    DB    00011111B                 ;0FF93H 
    DB    00110101B                 ;0FF94H 
    DB    00011111B                 ;0FF95H 
    DB    00100100B                 ;0FF96H 
;0FF97H-0FF99H 'Г'
;░░░░░░░░
;░░░█████
;░░░█░░░█
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
    DB    00011111B                 ;0FF97H
    DB    00010001B                 ;0FF98H 
    DB    10010000B                 ;0FF99H 
;0FF9AH-0FF9EH 'Х'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░░█░█░
;░░░░░█░░
;░░░░█░█░
;░░░█░░░█
;░░░█░░░█
    DB    00110001B                 ;0FF9AH
    DB    00001010B                 ;0FF9BH 
    DB    00000100B                 ;0FF9CH 
    DB    00001010B                 ;0FF9DH 
    DB    00110001B                 ;0FF9EH 
;0FF9FH-0FFA3H 'И'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░██
;░░░█░█░█
;░░░██░░█
;░░░█░░░█
;░░░█░░░█
    DB    00110001B                 ;0FF9FH
    DB    00010011B                 ;0FFA0H 
    DB    00010101B                 ;0FFA1H 
    DB    00011001B                 ;0FFA2H 
    DB    00110001B                 ;0FFA3H 
;0FFA4H-0FFA9H 'Й'
;░░░░░░░░
;░░░█░█░█
;░░░█░░░█
;░░░█░░██
;░░░█░█░█
;░░░██░░█
;░░░█░░░█
;░░░█░░░█
    DB    00010101B                 ;0FFA4H
    DB    00010001B                 ;0FFA5H 
    DB    00010011B                 ;0FFA6H 
    DB    00010101B                 ;0FFA7H 
    DB    00011001B                 ;0FFA8H 
    DB    00110001B                 ;0FFA9H 
;0FFAAH-0FFB0H 'К'
;░░░░░░░░
;░░░█░░░█
;░░░█░░█░
;░░░█░█░░
;░░░██░░░
;░░░█░█░░
;░░░█░░█░
;░░░█░░░█
    DB    00010001B                 ;0FFAAH
    DB    00010010B                 ;0FFABH 
    DB    00010100B                 ;0FFACH 
    DB    00011000B                 ;0FFADH 
    DB    00010100B                 ;0FFAEH 
    DB    00010010B                 ;0FFAFH 
    DB    00010001B                 ;0FFB0H 
;0FFB1H-0FFB3H 'Л'
;░░░░░░░░
;░░░░░███
;░░░░█░░█
;░░░░█░░█
;░░░░█░░█
;░░░░█░░█
;░░░░█░░█
;░░░██░░█
    DB    00000111B                 ;0FFB1H
    DB    10001001B                 ;0FFB2H 
    DB    00011001B                 ;0FFB3H 
;0FFB4H-0FFB7H 'М'
;░░░░░░░░
;░░░█░░░█
;░░░██░██
;░░░█░█░█
;░░░█░█░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
    DB    00010001B                 ;0FFB4H
    DB    00011011B                 ;0FFB5H 
    DB    00110101B                 ;0FFB6H 
    DB    01010001B                 ;0FFB7H 
;0FFB8H-0FFBAH 'Н'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█████
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
    DB    01010001B                 ;0FFB8H
    DB    00011111B                 ;0FFB9H 
    DB    01010001B                 ;0FFBAH 
;0FFBBH-0FFBDH 'О'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FFBBH
    DB    10010001B                 ;0FFBCH 
    DB    00001110B                 ;0FFBDH 
;0FFBEH-0FFBFH 'П'
;░░░░░░░░
;░░░█████
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
    DB    00011111B                 ;0FFBEH
    DB    10110001B                 ;0FFBFH 
;0FFC0H-0FFC5H 'Я'
;░░░░░░░░
;░░░░████
;░░░█░░░█
;░░░█░░░█
;░░░░████
;░░░░░█░█
;░░░░█░░█
;░░░█░░░█
    DB    00001111B                 ;0FFC0H
    DB    00110001B                 ;0FFC1H 
    DB    00001111B                 ;0FFC2H 
    DB    00000101B                 ;0FFC3H 
    DB    00001001B                 ;0FFC4H 
    DB    00010001B                 ;0FFC5H 
;0FFC6H-0FFC9H 'Р'
;░░░░░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
    DB    00011110B                 ;0FFC6H
    DB    00110001B                 ;0FFC7H 
    DB    00011110B                 ;0FFC8H 
    DB    01010000B                 ;0FFC9H 
;0FFCAH-0FFCEH 'С'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FFCAH
    DB    00010001B                 ;0FFCBH 
    DB    01010000B                 ;0FFCCH 
    DB    00010001B                 ;0FFCDH 
    DB    00001110B                 ;0FFCEH 
;0FFCFH-0FFD0H 'Т'
;░░░░░░░░
;░░░█████
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
    DB    00011111B                 ;0FFCFH
    DB    10100100B                 ;0FFD0H 
;0FFD1H-0FFD5H 'У'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░░█░█░
;░░░░░█░░
;░░░░█░░░
;░░░█░░░░
    DB    01010001B                 ;0FFD1H
    DB    00001010B                 ;0FFD2H 
    DB    00000100B                 ;0FFD3H 
    DB    00001000B                 ;0FFD4H 
    DB    00010000B                 ;0FFD5H 
;0FFD6H-0FFDAH 'Ж'
;░░░░░░░░
;░░░█░░░█
;░░░█░█░█
;░░░█░█░█
;░░░░███░
;░░░█░█░█
;░░░█░█░█
;░░░█░░░█
    DB    00010001B                 ;0FFD6H
    DB    00110101B                 ;0FFD7H 
    DB    00001110B                 ;0FFD8H 
    DB    00110101B                 ;0FFD9H 
    DB    00010001B                 ;0FFDAH 
;0FFDBH-0FFDFH 'В'
;░░░░░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
    DB    00011110B                 ;0FFDBH
    DB    00110001B                 ;0FFDCH 
    DB    00011110B                 ;0FFDDH 
    DB    00110001B                 ;0FFDEH 
    DB    00011110B                 ;0FFDFH 
;0FFE0H-0FFE3H 'Ь'
;░░░░░░░░
;░░░█░░░░
;░░░█░░░░
;░░░█░░░░
;░░░████░
;░░░█░░░█
;░░░█░░░█
;░░░████░
    DB    01010000B                 ;0FFE0H
    DB    00011110B                 ;0FFE1H 
    DB    00110001B                 ;0FFE2H 
    DB    00011110B                 ;0FFE3H 
;0FFE4H-0FFE7H 'Ы'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░██░░█
;░░░█░█░█
;░░░█░█░█
;░░░██░░█
    DB    01010001B                 ;0FFE4H
    DB    00011001B                 ;0FFE5H 
    DB    00110101B                 ;0FFE6H 
    DB    00011001B                 ;0FFE7H 
;0FFE8H-0FFEEH 'З'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░░░░░█
;░░░░░██░
;░░░░░░░█
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FFE8H
    DB    00010001B                 ;0FFE9H 
    DB    00000001B                 ;0FFEAH 
    DB    00000110B                 ;0FFEBH 
    DB    00000001B                 ;0FFECH 
    DB    00010001B                 ;0FFEDH 
    DB    00001110B                 ;0FFEEH 
;0FFEFH-0FFF1H 'Ш'
;░░░░░░░░
;░░░█░░░█
;░░░█░█░█
;░░░█░█░█
;░░░█░█░█
;░░░█░█░█
;░░░█░█░█
;░░░█████
    DB    00010001B                 ;0FFEFH
    DB    10010101B                 ;0FFF0H 
    DB    00011111B                 ;0FFF1H 
;0FFF2H-0FFF8H 'Э'
;░░░░░░░░
;░░░░███░
;░░░█░░░█
;░░░░░░░█
;░░░░░███
;░░░░░░░█
;░░░█░░░█
;░░░░███░
    DB    00001110B                 ;0FFF2H
    DB    00010001B                 ;0FFF3H 
    DB    00000001B                 ;0FFF4H 
    DB    00000111B                 ;0FFF5H 
    DB    00000001B                 ;0FFF6H 
    DB    00010001B                 ;0FFF7H 
    DB    00001110B                 ;0FFF8H 
;0FFF9H-0FFFBH 'Щ'
;░░░░░░░░
;░░░█░█░█
;░░░█░█░█
;░░░█░█░█
;░░░█░█░█
;░░░█░█░█
;░░░█████
;░░░░░░░█
    DB    10010101B                 ;0FFF9H
    DB    00011111B                 ;0FFFAH 
    DB    00000001B                 ;0FFFBH 
;0FFFCH-0FFFEH 'Ч'
;░░░░░░░░
;░░░█░░░█
;░░░█░░░█
;░░░█░░░█
;░░░█████
;░░░░░░░█
;░░░░░░░█
;░░░░░░░█
    DB    01010001B                 ;0FFFCH
    DB    00011111B                 ;0FFFDH 
    DB    01000001B                 ;0FFFEH 
    DB    01010010B                 ;0FFFFH 
