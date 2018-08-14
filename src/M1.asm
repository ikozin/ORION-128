include "8085.inc"

DisplayModePort	EQU 0F800H
DisplayPagePort	EQU 0F900H
DisplayViewPort	EQU 0F900H

VAL_0C0H_ADDR		EQU 0F3CFH
VAL_30H_ADDR		EQU 0F3D0H
CODEPAGE_ADDR		EQU 0F3D1H
INVERSE_DISP_ADDR	EQU 0F3D3H
X_POS_ADDR			EQU 0F3D4H
Y_POS_ADDR			EQU 0F3D5H
PAUSE_SAVE_ADDR		EQU 0F3DAH
PAUSE_LOAD_ADDR		EQU 0F3DBH

Run_0BFFDH			EQU 0BFFDH

; 0F400H - порт клавиатуры
; 0F500H - порт пользователя №1
; 0F600H - порт пользователя №2
; 0F700H - порт платы расширения
; 0F800H - системный порт №1 - управление цветным режимом - (только для записи) 
; 0F900H - системный порт №2 - управление переключением страниц - (только для записи)
; 0FA00H - системный порт №3 - управление переключением экранов - (только для записи)
; 0FB00H - системный порт №4 - переключение типов дисплеев (не используется) - (только для записи)

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


ORG 0F800H

    jmp StartCode                   ;0F800H 
InputKey_Entry:
    jmp InputKey                    ;0F803H Ввод символа с клавиатуры (вых: A - введенный символ)
LoadByte_Entry:
    jmp LoadByte                    ;0F806H Ввод байта с магнитофона (вх: A = 0FFH - с поиском синхробайта, A = 08H - без поиска)
DisplaySymC_Entry:
    jmp 0F3CCH                      ;0F809H Вывод символа на экран (вх: C = выводимый символ)
SaveByte_Entry:
    jmp SaveByte                    ;0F80CH Запись байта на магнитофон (вх: A = записываемый байт)
DispplaySymA_Entry:
    jmp DispSymA                    ;0F80FH Вывод символа на экран (вх: A = выводимый символ)
GetKeyState_Entry:
    jmp GetKeyState                 ;0F812H Опрос состояния клавиатуры (вых: A = 00H - не нажата, A = 0FFH - нажата)
DisplayHEX_Entry:
    jmp DisplayHex                  ;0F815H Вывод байта на экран в HEX-коде (вх: A = выводимый символ)
DisplayText_Entry:
    jmp DisplayText                 ;0F818H Вывод на экран сообщений (вх: HL - адрес начала, конечный байт - 00H)
InputkeyCode_Entry:
    jmp InputKeyCode                ;0F81BH Ввод кода нажатой клавиши inkey  (вых: A = 0FFH - не нажата, A = 0FEH - РУС/ЛАТ, иначе - код клавиши)
GetPosCursor_Entry:
    jmp GetPosCursor                ;0F81EH Запрос положения курсора (вых: H - номер строки Y, L номер позиции X)
NotImplemented_Entry:
    jmp 0F3C9H                      ;0F821H Не используется
LoadFile_Entry:
    jmp LoadFile                    ;0F824H Чтение файла из магнитной ленты
SaveFile_Entry:
    jmp SaveFile                    ;0F827H Запись файла на магнитную ленту (вх: HL - нач. адрес массива, DE - конечный адрес)
CalcControlSum_Entry:
    jmp CalcControlSum              ;0F82AH Подсчет контрольной суммы блока (вх: HL - адрес начала, DE - адрес конца; вых: BC - контрольная сумма)
LoadCodePage_Entry:
    jmp LoadCodePage                ;0F82DH Распаковка внутреннего знакогенератора
LoadRamAddr_Entry:
    jmp LoadRamAddr                 ;0F830H Чтение конечного адреса ОЗУ пользователя (вых: HL - конечный адрес)
SaveRamAddr_Entry:
    jmp SaveRamAddr                 ;0F833H Запись конечного адреса ОЗУ пользователя (вх: HL - конечный адрес)
LoadByteDisplayPage_Entry:
    jmp LoadByteDisplayPage         ;0F836H Чтение байта из доп. страницы (вх: HL - адрес, A - N страницы (0-3), C - считанный байт)
SaveByteDisplayPage_Entry:
    jmp SaveByteDisplayPage         ;0F839H Запись байта в доп. страницы (вх: HL - адрес, A - N страницы (0-3), C - записываемый байт)
SetPosCursor_Entry:
    jmp SetPosCursor                ;0F83CH 
    ret                             ;0F83FH 
    nop                             ;0F840H 
    nop                             ;0F841H 
StartCode:
    lxi SP, 0F3C9H                  ;0F842H 
    xra A                           ;0F845H 
    sta 0F800H                      ;0F846H Порт - Управление цветным режимом
    sta 0F900H                      ;0F849H Порт - Управление переключением страниц памяти
    sta 0FA00H                      ;0F84CH Порт - Управление переключением экранов
    sta INVERSE_DISP_ADDR           ;0F84FH 
    sta 0F402H                      ;0F852H 
    mvi A, 0C3H                     ;0F855H Код команды безусловного перехода JMP
    sta 0F3CCH                      ;0F857H 
    sta 0F3C9H                      ;0F85AH 
    call InitializeCodePage         ;0F85DH 
    lxi H, 6040H                    ;0F860H Значение 6040H (запись - 1200 бод = 40H, чтение - для стандартной скорости = 60H)
    shld PAUSE_SAVE_ADDR            ;0F863H сохраняем в ячейке. 0F3DAH - ячейка в которой хранится константа записи на магнитную 40H. 0F3DBH - ячейка в которой хранится константа чтения с магнитной ленты = 60H
    lxi H, Label_Version            ;0F866H 
    call DisplayText                ;0F869H Выводим "orion-128.2"
HandleCmd:
    lxi SP, 0F3C9H                  ;0F86CH Начало цикла обработки команд
    mvi A, 8AH                      ;0F86FH 
    sta 0F403H                      ;0F871H 
    lxi H, Label_Prompt             ;0F874H 
    call DisplayText                ;0F877H Выводим приглашение для ввода команды "=>"
    sta 0F3E5H                      ;0F87AH 
    lxi H, HotReset                 ;0F87DH 
    shld 0F3D8H                     ;0F880H 
    lxi H, HandleCmd                ;0F883H Сохраняем начало цикла обработки команд в HL
    push H                          ;0F886H 
    call 0F8DEH                     ;0F887H 
    call DisplayNewLine             ;0F88AH 
    call 0F918H                     ;0F88DH 
    lda 0F3F0H                      ;0F890H 
    cpi 4DH                         ;0F893H M <адрес> <ВК>						- Модификация ячеек ОЗУ
    jz EditMemory                   ;0F895H 
    cpi 44H                         ;0F898H D <нач. адрес> <номер стр.> <ВК>	- Вывод дампа памяти
    jz DumpMemory                   ;0F89AH 
    cpi 49H                         ;0F89DH I <ВК>								- Ввод с магнитофона
    jz LoadFile                     ;0F89FH 
    cpi 4FH                         ;0F8A2H O <нач. адрес> <конеч. адрес> <ВК>	- Вывод на магнитофон
    jz SaveFile                     ;0F8A4H 
    cpi 52H                         ;0F8A7H R
    jz CMD_ROM_BOOT                 ;0F8A9H 
    cpi 5AH                         ;0F8ACH Z <ВК>								- Передача управления по адресу 0BFFDH
    jz Run_0BFFDH                   ;0F8AEH 
    cpi 43H                         ;0F8B1H C <байт цвета> <ВК>					- Включение цветного режима дисплея
    jz SetColorMode                 ;0F8B3H 
    cpi 47H                         ;0F8B6H G <адрес> <ВК>						- Передача управления по адресу
    jnz HotReset                    ;0F8B8H 
    pchl                            ;0F8BBH Переходим на начало цикла обработки команд (см 0F883H)
InitializeCodePage:
    lxi H, 0F000H                   ;0F8BCH Начальный адрес знакогенератора
    shld CODEPAGE_ADDR              ;0F8BFH сохраняем в ячейке 0F3D1H
    call LoadCodePage               ;0F8C2H загружаем знакогенератор
    lxi H, 30C0H                    ;0F8C5H Значение 30C0H
    shld VAL_0C0H_ADDR              ;0F8C8H сохраняем в ячейке 0F3CFH (0C0H -> 0F3CFH, 30H -> 0F3D0H)
    lxi H, DispSymC                 ;0F8CBH Адрес 0FCD0H (0F809H Вывод символа на экран, 0F855H Код команды безусловного перехода JMP)
    shld 0F3CDH                     ;0F8CEH сохраняем в ячейке 0F3CDH
    lxi H, Stub                     ;0F8D1H Значение 0F8DDH
    shld 0F3CAH                     ;0F8D4H сохраняем в ячейке 0F3CAH
    lxi H, 0BFFFH                   ;0F8D7H Значение 0BFFFH
    shld 0F3E3H                     ;0F8DAH сохраняем в ячейке 0F3E3H
Stub:
    ret                             ;0F8DDH 
    lxi D, 0F3F0H                   ;0F8DEH 
Handle_Loop:
    call InputKey                   ;0F8E1H 
    cpi 2EH                         ;0F8E4H 
    jz HotReset                     ;0F8E6H 
    cpi 7FH                         ;0F8E9H 7FH -> Спец. символ инверсия вывода
    jz Handle_Inverse               ;0F8EBH 
    cpi 18H                         ;0F8EEH 
    jz 0F908H                       ;0F8F0H 
    cpi 08H                         ;0F8F3H 
    jnz 0F907H                      ;0F8F5H 
    mvi A, 0F0H                     ;0F8F8H 
    cmp E                           ;0F8FAH 
    jz Handle_Loop                  ;0F8FBH 
    mvi A, 08H                      ;0F8FEH 
    dcx D                           ;0F900H 
Handle_Inverse:
    call DispSymA                   ;0F901H 
    jmp Handle_Loop                 ;0F904H 
    stax D                          ;0F907H 
    call DispSymA                   ;0F908H 
    cpi 0DH                         ;0F90BH 
    rz                              ;0F90DH 
    inx D                           ;0F90EH 
    mov A, E                        ;0F90FH 
    cpi 0FFH                        ;0F910H 
    jnz Handle_Loop                 ;0F912H 
    jmp 0F8FEH                      ;0F915H 
    lxi D, 0F3F1H                   ;0F918H 
    call 0F92AH                     ;0F91BH 
    shld 0F3EEH                     ;0F91EH 
    rc                              ;0F921H 
    call 0F92AH                     ;0F922H 
    xchg                            ;0F925H 
    lhld 0F3EEH                     ;0F926H 
    ret                             ;0F929H 
    lxi H, 0000H                    ;0F92AH 
    mov B, L                        ;0F92DH 
    mov C, L                        ;0F92EH 
    dad B                           ;0F92FH 
    ldax D                          ;0F930H 
    inx D                           ;0F931H 
    cpi 0DH                         ;0F932H 
    jz 0F960H                       ;0F934H 
    cpi 2CH                         ;0F937H 
    rz                              ;0F939H 
    sui 30H                         ;0F93AH 
    jm HotReset                     ;0F93CH 
    cpi 0AH                         ;0F93FH 
    jm 0F950H                       ;0F941H 
    cpi 11H                         ;0F944H 
    jm HotReset                     ;0F946H 
    cpi 17H                         ;0F949H 
    jp HotReset                     ;0F94BH 
    sui 07H                         ;0F94EH 
    mov C, A                        ;0F950H 
    dad H                           ;0F951H 
    dad H                           ;0F952H 
    dad H                           ;0F953H 
    dad H                           ;0F954H 
    jnc 0F92FH                      ;0F955H 
HotReset:
    mvi A, 3FH                      ;0F958H '?'
    call DispSymA                   ;0F95AH 
    jmp HandleCmd                   ;0F95DH 
    lxi D, 0000H                    ;0F960H 
    stc                             ;0F963H 
    ret                             ;0F964H 
DisplayHex_M:
    mov A, M                        ;0F965H 
DisplayHex:
    push PSW                        ;0F966H сохраняем аккумулятор и слово состояния
    rrc                             ;0F967H Старшие 4 бита загоняем в младшие
    rrc                             ;0F968H Старшие 4 бита загоняем в младшие
    rrc                             ;0F969H Старшие 4 бита загоняем в младшие
    rrc                             ;0F96AH Старшие 4 бита загоняем в младшие
    call DisplayTetrasHex           ;0F96BH Показываем старшие 4 бита (которые загнали в младшие) в HEX формате
    pop psw                         ;0F96EH Восстанавливаем аккумулятор
DisplayTetrasHex:
    ani 0FH                         ;0F96FH Отображаем тетраду (4 младших бита) в HEX формате
    cpi 0AH                         ;0F971H 
    jm DisplayTetrasHex_1           ;0F973H 
    adi 07H                         ;0F976H A -> 'A' (+ 07H + 30H), 'A'=41H, 'B'=42H, 'C'=43H, 'D'=44H, 'E'=45H, 'F'=46H
DisplayTetrasHex_1:
    adi 30H                         ;0F978H 0 -> '0' (+ 30H), '0'=30H,'1'=31H,'2'=32H,'3'=33H,'4'=34H,'5'=35H,'6'=36H,'7'=37H,'8'=38H,'9'=39H
    push B                          ;0F97AH 
    mov C, A                        ;0F97BH 
    call DisplaySymC_Entry          ;0F97CH Отображаем HEX символ
    pop B                           ;0F97FH 
    ret                             ;0F980H 
DisplayText:
    mov A, M                        ;0F981H 
    ana A                           ;0F982H 
    rz                              ;0F983H 
    push B                          ;0F984H 
    mov C, A                        ;0F985H 
    call DisplaySymC_Entry          ;0F986H 
    pop B                           ;0F989H 
    inx H                           ;0F98AH 
    jmp DisplayText                 ;0F98BH 
CalcControlSum:
    lxi B, 0000H                    ;0F98EH Обнуляем BC
CalcSumLoop:
    mov A, C                        ;0F991H 
    add M                           ;0F992H 
    mov C, A                        ;0F993H 
    push PSW                        ;0F994H Сохраняем флаги
    call CheckEnd                   ;0F995H 
    jz Ret_Pop_PSW                  ;0F998H 
    pop psw                         ;0F99BH Восстанавливаем флаги
    mov A, B                        ;0F99CH 
    adc M                           ;0F99DH 
    mov B, A                        ;0F99EH 
    inx H                           ;0F99FH 
    jmp CalcSumLoop                 ;0F9A0H 
DisplayAddr:
    call DisplayNewLine             ;0F9A3H 
    call DisplaySpace               ;0F9A6H 
DisplayHL:
    mov A, H                        ;0F9A9H 
    call DisplayHex                 ;0F9AAH Отображаем адрес (H)
    mov A, L                        ;0F9ADH 
    call DisplayHex                 ;0F9AEH Отображаем адрес (L)
DisplaySpace:
    mvi A, 20H                      ;0F9B1H ' '
    jmp DispSymA                    ;0F9B3H 
CheckEnd:
    mov A, H                        ;0F9B6H ----------------------------------------
    cmp D                           ;0F9B7H Проверяем на конец блока
    rnz                             ;0F9B8H в HL - начало блока
    mov A, L                        ;0F9B9H в DE - конец блока
    cmp E                           ;0F9BAH ----------------------------------------
    ret                             ;0F9BBH 
GetPosCursor:
    lhld X_POS_ADDR                 ;0F9BCH Запрос положения курсора (вых H - номер строки Y, L номер позиции X)
    mov A, L                        ;0F9BFH 0F3D4H -> L (X)
    rrc                             ;0F9C0H 0F3D5H -> H (Y)
    rrc                             ;0F9C1H L делим на 4 
    mov L, A                        ;0F9C2H ---------------
    ret                             ;0F9C3H 
SetPosCursor:
    mov A, L                        ;0F9C4H ---------------
    rlc                             ;0F9C5H L умножаем на 4 
    rlc                             ;0F9C6H L -> 0F3D4H (X)
    mov L, A                        ;0F9C7H H -> 0F3D5H (Y)
    shld X_POS_ADDR                 ;0F9C8H ---------------
    ret                             ;0F9CBH 
SaveRamAddr:
    shld 0F3E3H                     ;0F9CCH 
LoadRamAddr:
    lhld 0F3E3H                     ;0F9CFH 
    ret                             ;0F9D2H 
LoadCodePage:
    lxi H, CodePageTable            ;0F9D3H Адрес начала знакогенератора в ПЗУ (0FE48H - 0FFFFH)
    lxi D, 0F000H                   ;0F9D6H Адрес знакогенератора в ОЗУ (0F000H - 0F2FFH)
LoadCodePage_NextSymbol:
    mvi C, 07H                      ;0F9D9H Знакогенератор содержит символы 5х7 точек
    xra A                           ;0F9DBH символы распаковываются в матрицу 8х8
    stax D                          ;0F9DCH первая строка всегда = 0 (пустая)
    inx D                           ;0F9DDH далее 7 строк символа в формате | XXX | XXXXX |
LoadCodePage_Extract:
    mov A, M                        ;0F9DEH где старшие 3 бита кол-во строк + 1, т.е. значение 0 = 1 строка
    rlc                             ;0F9DFH младшие 5 бит, строка символа.
    rlc                             ;0F9E0H Значение 0С00H -> 11000000, где кол-во строк = 7, строка = 0 -> символ пробела
    rlc                             ;0F9E1H Значения 84H, 00H, 04H распаковывается в '!'
    ani 07H                         ;0F9E2H 00000000 - всегда пусто
    mov B, A                        ;0F9E4H 00000100 - 84H => 5 раз 00100
LoadCodePage_ExtractLine:
    mov A, M                        ;0F9E5H 00000100 - 84H => 5 раз 00100
    ani 1FH                         ;0F9E6H 00000100 - 84H => 5 раз 00100
    stax D                          ;0F9E8H 00000100 - 84H => 5 раз 00100
    inx D                           ;0F9E9H 00000100 - 84H => 5 раз 00100
    dcr C                           ;0F9EAH 00000000 - 00H
    dcr B                           ;0F9EBH 00000100 - 04H => 1 раз 00100
    jp LoadCodePage_ExtractLine     ;0F9ECH 
    inx H                           ;0F9EFH Увеличиваем HL
    mov A, H                        ;0F9F0H проверяем на выход за предел границу адреса
    ana A                           ;0F9F1H т.е. как перескочим с 0FFFFH на 0000H
    rz                              ;0F9F2H завершаем работу
    mov A, C                        ;0F9F3H 
    ana A                           ;0F9F4H 
    jnz LoadCodePage_Extract        ;0F9F5H 
    jmp LoadCodePage_NextSymbol     ;0F9F8H 
LoadByteDisplayPage:
    sta 0F900H                      ;0F9FBH 
    mov C, M                        ;0F9FEH 
SetZeroDisplayPage:
    xra A                           ;0F9FFH 
    sta 0F900H                      ;0FA00H 
    ret                             ;0FA03H 
SaveByteDisplayPage:
    sta 0F900H                      ;0FA04H 
    mov M, C                        ;0FA07H 
    jmp SetZeroDisplayPage          ;0FA08H 
    mvi A, 08H                      ;0FA0BH 
LoadByte:
    push B                          ;0FA0DH 
    push D                          ;0FA0EH 
    push H                          ;0FA0FH 
    mvi C, 00H                      ;0FA10H 
    mov D, A                        ;0FA12H 
    lda 0F402H                      ;0FA13H 
    rrc                             ;0FA16H 
    rrc                             ;0FA17H 
    rrc                             ;0FA18H 
    rrc                             ;0FA19H 
    ani 01H                         ;0FA1AH 
    mov E, A                        ;0FA1CH 
    mov A, C                        ;0FA1DH 
    ani 7FH                         ;0FA1EH 
    rlc                             ;0FA20H 
    mov C, A                        ;0FA21H 
    mvi B, 00H                      ;0FA22H 
    dcr B                           ;0FA24H 
    jnz 0FA2CH                      ;0FA25H 
    lhld 0F3D8H                     ;0FA28H 
    pchl                            ;0FA2BH 
    lda 0F402H                      ;0FA2CH 
    rrc                             ;0FA2FH 
    rrc                             ;0FA30H 
    rrc                             ;0FA31H 
    rrc                             ;0FA32H 
    ani 01H                         ;0FA33H 
    cmp E                           ;0FA35H 
    jz 0FA24H                       ;0FA36H 
    ora C                           ;0FA39H 
    mov C, A                        ;0FA3AH 
    call Pause_Load                 ;0FA3BH 
    lda 0F402H                      ;0FA3EH 
    rrc                             ;0FA41H 
    rrc                             ;0FA42H 
    rrc                             ;0FA43H 
    rrc                             ;0FA44H 
    ani 01H                         ;0FA45H 
    mov E, A                        ;0FA47H 
    mov A, D                        ;0FA48H 
    ora A                           ;0FA49H 
    jp 0FA66H                       ;0FA4AH 
    mov A, C                        ;0FA4DH 
    cpi 0E6H                        ;0FA4EH 
    jnz 0FA5AH                      ;0FA50H 
    xra A                           ;0FA53H 
    sta 0F3DCH                      ;0FA54H 
    jmp 0FA64H                      ;0FA57H 
    cpi 19H                         ;0FA5AH 
    jnz 0FA1DH                      ;0FA5CH 
    mvi A, 0FFH                     ;0FA5FH 
    sta 0F3DCH                      ;0FA61H 
    mvi D, 09H                      ;0FA64H 
    dcr D                           ;0FA66H 
    jnz 0FA1DH                      ;0FA67H 
    lda 0F3DCH                      ;0FA6AH 
    xra C                           ;0FA6DH 
Ret_Pop_HDB:
    pop H                           ;0FA6EH 
    pop D                           ;0FA6FH 
    pop B                           ;0FA70H 
    ret                             ;0FA71H 
Save_HL:
    mov C, H                        ;0FA72H 
    call SaveByte                   ;0FA73H 
    mov C, L                        ;0FA76H 
SaveByte:
    push PSW                        ;0FA77H 
    push D                          ;0FA78H 
    push B                          ;0FA79H 
    mvi D, 08H                      ;0FA7AH 
    mov A, C                        ;0FA7CH 
    rlc                             ;0FA7DH 
    mov C, A                        ;0FA7EH 
    mvi A, 01H                      ;0FA7FH 
    xra C                           ;0FA81H 
    sta 0F402H                      ;0FA82H 
    call Pause_Save                 ;0FA85H 
    xra A                           ;0FA88H 
    xra C                           ;0FA89H 
    sta 0F402H                      ;0FA8AH 
    call Pause_Save                 ;0FA8DH 
    dcr D                           ;0FA90H 
    jnz 0FA7CH                      ;0FA91H 
    pop B                           ;0FA94H 
    pop D                           ;0FA95H 
Ret_Pop_PSW:
    pop psw                         ;0FA96H 
    ret                             ;0FA97H 
Pause_Save:
    lda PAUSE_SAVE_ADDR             ;0FA98H Загружаем значение паузы для записи на магнитную ленту
    jmp Pause_A                     ;0FA9BH 
Pause_Load:
    lda PAUSE_LOAD_ADDR             ;0FA9EH Загружаем значение паузы для чтения с магнитной ленты
Pause_A:
    dcr A                           ;0FAA1H 
    jnz Pause_A                     ;0FAA2H 
    ret                             ;0FAA5H 
DisplayNextAddr:
    inx H                           ;0FAA6H 
EditMemory:
    call DisplayAddr                ;0FAA7H 
    call DisplayHex_M               ;0FAAAH 
    call DisplaySpace               ;0FAADH 
    call 0F8DEH                     ;0FAB0H 
    lxi D, 0F3F0H                   ;0FAB3H 
    ldax D                          ;0FAB6H 
    cpi 0DH                         ;0FAB7H 
    jz DisplayNextAddr              ;0FAB9H 
    push H                          ;0FABCH 
    call 0F92AH                     ;0FABDH 
    xchg                            ;0FAC0H 
    pop H                           ;0FAC1H 
    mov M, E                        ;0FAC2H 
    jmp DisplayNextAddr             ;0FAC3H 
DumpMemory:
    mov B, E                        ;0FAC6H 
DumpMemory_NextLine:
    call DisplayAddr                ;0FAC7H 
DumpMemory_NextByte:
    call DisplaySpace               ;0FACAH 
    mov A, B                        ;0FACDH 
    ana A                           ;0FACEH 
    jz 0FAD9H                       ;0FACFH 
    call LoadByteDisplayPage        ;0FAD2H 
    mov A, C                        ;0FAD5H 
    jmp 0FADAH                      ;0FAD6H 
    mov A, M                        ;0FAD9H 
    call DisplayHex                 ;0FADAH 
    inx H                           ;0FADDH 
    mov A, L                        ;0FADEH 
    ani 0FH                         ;0FADFH 
    jnz DumpMemory_NextByte         ;0FAE1H 
    mov A, L                        ;0FAE4H 
    ana A                           ;0FAE5H 
    jnz DumpMemory_NextLine         ;0FAE6H 
    call 0F8DEH                     ;0FAE9H 
    jmp DumpMemory_NextLine         ;0FAECH 
LoadFile:
    mvi A, 0FFH                     ;0FAEFH 
    call 0FB28H                     ;0FAF1H 
    xchg                            ;0FAF4H 
    call 0FB26H                     ;0FAF5H 
    xchg                            ;0FAF8H 
    push H                          ;0FAF9H 
    call 0FA0BH                     ;0FAFAH 
    mov M, A                        ;0FAFDH 
    call CheckEnd                   ;0FAFEH 
    inx H                           ;0FB01H 
    jnz 0FAFAH                      ;0FB02H 
    mvi A, 0FFH                     ;0FB05H 
    call 0FB28H                     ;0FB07H 
    mov B, H                        ;0FB0AH 
    mov C, L                        ;0FB0BH 
    pop H                           ;0FB0CH 
    call DisplayHL                  ;0FB0DH 
    xchg                            ;0FB10H 
    call DisplayHL                  ;0FB11H 
    xchg                            ;0FB14H 
    push B                          ;0FB15H 
    call CalcControlSum             ;0FB16H 
    pop D                           ;0FB19H 
    mov H, B                        ;0FB1AH 
    mov L, C                        ;0FB1BH 
    call DisplayHL                  ;0FB1CH 
    call CheckEnd                   ;0FB1FH 
    rz                              ;0FB22H 
    jmp 0FA28H                      ;0FB23H 
    mvi A, 08H                      ;0FB26H 
    call LoadByte                   ;0FB28H 
    mov H, A                        ;0FB2BH 
    call 0FA0BH                     ;0FB2CH 
    mov L, A                        ;0FB2FH 
    ret                             ;0FB30H 
SaveFile:
    push H                          ;0FB31H 
    call CalcControlSum             ;0FB32H 
    pop H                           ;0FB35H 
    push B                          ;0FB36H 
    push H                          ;0FB37H 
    lxi B, 0000H                    ;0FB38H 
    call SaveByte                   ;0FB3BH 
    dcr B                           ;0FB3EH 
    jnz 0FB3BH                      ;0FB3FH 
    mvi C, 0E6H                     ;0FB42H 
    call SaveByte                   ;0FB44H 
    call Save_HL                    ;0FB47H 
    xchg                            ;0FB4AH 
    call Save_HL                    ;0FB4BH 
    xchg                            ;0FB4EH 
    pop H                           ;0FB4FH 
    mov C, M                        ;0FB50H 
    call SaveByte                   ;0FB51H 
    call CheckEnd                   ;0FB54H 
    inx H                           ;0FB57H 
    jnz 0FB50H                      ;0FB58H 
    lxi H, 0000H                    ;0FB5BH 
    call Save_HL                    ;0FB5EH 
    mvi C, 0E6H                     ;0FB61H 
    call SaveByte                   ;0FB63H 
    pop H                           ;0FB66H 
    call Save_HL                    ;0FB67H 
    jmp DisplayHL                   ;0FB6AH 
SetColorMode:
    mov C, L                        ;0FB6DH 
    mvi A, 06H                      ;0FB6EH 
    sta 0F800H                      ;0FB70H 
    mvi A, 01H                      ;0FB73H 
    sta 0F900H                      ;0FB75H 
    lxi H, INVERSE_DISP_ADDR        ;0FB78H 
    mov D, M                        ;0FB7BH 
    mov M, C                        ;0FB7CH 
    call ClearScreen                ;0FB7DH 
    mov M, D                        ;0FB80H 
    xra A                           ;0FB81H 
    sta 0F900H                      ;0FB82H 
    ret                             ;0FB85H 
GetKeyState:
    xra A                           ;0FB86H 
    sta 0F400H                      ;0FB87H 
    lda 0F401H                      ;0FB8AH 
    xri 0FFH                        ;0FB8DH 
    rz                              ;0FB8FH 
    mvi A, 0FFH                     ;0FB90H 
    ret                             ;0FB92H 
CMD_ROM_BOOT:
    lxi D, 0B800H                   ;0FB93H 
    mov H, E                        ;0FB96H 
    mov L, E                        ;0FB97H 
    mvi A, 90H                      ;0FB98H 
    sta 0F503H                      ;0FB9AH 
    shld 0F501H                     ;0FB9DH 
    lda 0F500H                      ;0FBA0H 
    stax D                          ;0FBA3H 
    inx D                           ;0FBA4H 
    inx H                           ;0FBA5H 
    mov A, H                        ;0FBA6H 
    cpi 08H                         ;0FBA7H 
    jnz 0FB9DH                      ;0FBA9H 
    jmp Run_0BFFDH                  ;0FBACH 
InputKey:
    push B                          ;0FBAFH 
    push D                          ;0FBB0H 
    push H                          ;0FBB1H 
    call InputKeyCode               ;0FBB2H 
    cpi 0FFH                        ;0FBB5H 
    jnz 0FBBDH                      ;0FBB7H 
    sta 0F3E6H                      ;0FBBAH 
    mvi D, 00H                      ;0FBBDH 
    inx D                           ;0FBBFH 
    dcr E                           ;0FBC0H 
    inr E                           ;0FBC1H 
    cz 0FDF2H                       ;0FBC2H 
    call InputKeyCode               ;0FBC5H 
    inr A                           ;0FBC8H 
    jz 0FBBFH                       ;0FBC9H 
    push PSW                        ;0FBCCH 
    mov A, D                        ;0FBCDH 
    rrc                             ;0FBCEH 
    cnc 0FDF2H                      ;0FBCFH 
    pop psw                         ;0FBD2H 
    dcr A                           ;0FBD3H 
    jp 0FBEDH                       ;0FBD4H 
    lxi H, 0F3E5H                   ;0FBD7H 
    mov A, M                        ;0FBDAH 
    cma                             ;0FBDBH 
    mov M, A                        ;0FBDCH 
    sta 0F402H                      ;0FBDDH 
    call InputKeyCode               ;0FBE0H 
    inr A                           ;0FBE3H 
    jnz 0FBE0H                      ;0FBE4H 
    call 0FDF2H                     ;0FBE7H 
    jmp 0FBBDH                      ;0FBEAH 
    mov E, A                        ;0FBEDH 
    mvi D, 14H                      ;0FBEEH 
    lxi H, 0F3E6H                   ;0FBF0H 
    cmp M                           ;0FBF3H 
    jz 0FC02H                       ;0FBF4H 
    dcr D                           ;0FBF7H 
    jz 0FC02H                       ;0FBF8H 
    call InputKeyCode               ;0FBFBH 
    cmp E                           ;0FBFEH 
    jz 0FBF7H                       ;0FBFFH 
    call 0FE1BH                     ;0FC02H 
    mov M, E                        ;0FC05H 
    call 0FDF2H                     ;0FC06H 
    mov A, E                        ;0FC09H 
    jmp Ret_Pop_HDB                 ;0FC0AH 
InputKeyCode:
    push B                          ;0FC0DH 
    push D                          ;0FC0EH 
    push H                          ;0FC0FH 
    lxi H, Ret_Pop_HDB              ;0FC10H 
    push H                          ;0FC13H 
    mvi B, 00H                      ;0FC14H 
    mvi D, 09H                      ;0FC16H 
    mvi C, 0FEH                     ;0FC18H 
    mov A, C                        ;0FC1AH 
    sta 0F400H                      ;0FC1BH 
    rlc                             ;0FC1EH 
    mov C, A                        ;0FC1FH 
    lda 0F401H                      ;0FC20H 
    cpi 0FFH                        ;0FC23H 
    jz 0FC33H                       ;0FC25H 
    mov E, A                        ;0FC28H 
    call 0FCBAH                     ;0FC29H 
    lda 0F401H                      ;0FC2CH 
    cmp E                           ;0FC2FH 
    jz 0FC46H                       ;0FC30H 
    mov A, B                        ;0FC33H 
    adi 08H                         ;0FC34H 
    mov B, A                        ;0FC36H 
    dcr D                           ;0FC37H 
    jnz 0FC1AH                      ;0FC38H 
    lda 0F402H                      ;0FC3BH 
    ani 80H                         ;0FC3EH 
    mvi A, 0FEH                     ;0FC40H 
    rz                              ;0FC42H 
    inr A                           ;0FC43H 
    ret                             ;0FC44H 
    inr B                           ;0FC45H 
    rar                             ;0FC46H 
    jc 0FC45H                       ;0FC47H 
    mov A, B                        ;0FC4AH 
    ani 3FH                         ;0FC4BH 
    cpi 10H                         ;0FC4DH 
    jc 0FC8DH                       ;0FC4FH 
    cpi 3FH                         ;0FC52H 
    mov B, A                        ;0FC54H 
    mvi A, 20H                      ;0FC55H 
    rz                              ;0FC57H 
    lda 0F402H                      ;0FC58H 
    mov C, A                        ;0FC5BH 
    ani 40H                         ;0FC5CH 
    jnz 0FC65H                      ;0FC5EH 
    mov A, B                        ;0FC61H 
    ani 1FH                         ;0FC62H 
    ret                             ;0FC64H 
    lda 0F3E5H                      ;0FC65H 
    ana A                           ;0FC68H 
    jnz 0FCA6H                      ;0FC69H 
    mov A, C                        ;0FC6CH 
    ani 20H                         ;0FC6DH 
    mov A, B                        ;0FC6FH 
    jz 0FC80H                       ;0FC70H 
    cpi 1CH                         ;0FC73H 
    jm 0FC85H                       ;0FC75H 
    cpi 20H                         ;0FC78H 
    jm 0FC87H                       ;0FC7AH 
    jmp 0FC85H                      ;0FC7DH 
    cpi 1CH                         ;0FC80H 
    jc 0FC87H                       ;0FC82H 
    adi 10H                         ;0FC85H 
    adi 10H                         ;0FC87H 
    pop H                           ;0FC89H 
    jmp Ret_Pop_HDB                 ;0FC8AH 
    lxi H, 0FC96H                   ;0FC8DH 
    mov C, A                        ;0FC90H 
    mvi B, 00H                      ;0FC91H 
    dad B                           ;0FC93H 
    mov A, M                        ;0FC94H 
    ret                             ;0FC95H 
    DB    12                        ;0FC96H 
    DB    31                        ;0FC97H 
    DB    27                        ;0FC98H 
    DB    0                         ;0FC99H 
    DB    1                         ;0FC9AH 
    DB    2                         ;0FC9BH 
    DB    3                         ;0FC9CH 
    DB    4                         ;0FC9DH 
    DB    9                         ;0FC9EH 
    DB    10                        ;0FC9FH 
    DB    13                        ;0FCA0H 
    DB    127                       ;0FCA1H 
    DB    8                         ;0FCA2H 
    DB    25                        ;0FCA3H 
    DB    24                        ;0FCA4H 
    DB    26                        ;0FCA5H 
    mov A, C                        ;0FCA6H 
    ani 20H                         ;0FCA7H 
    mov A, B                        ;0FCA9H 
    jz 0FC80H                       ;0FCAAH 
    cpi 1CH                         ;0FCADH 
    jm 0FC85H                       ;0FCAFH 
    cpi 20H                         ;0FCB2H 
    jm 0FC87H                       ;0FCB4H 
    adi 40H                         ;0FCB7H 
    ret                             ;0FCB9H 
    lxi H, 0B00H                    ;0FCBAH 
    dcx H                           ;0FCBDH 
    mov A, H                        ;0FCBEH 
    ora L                           ;0FCBFH 
    jnz 0FCBDH                      ;0FCC0H 
    ret                             ;0FCC3H 
DisplayNewLine:
    mvi A, 0DH                      ;0FCC4H 
    call DispSymA                   ;0FCC6H 
    mvi A, 0AH                      ;0FCC9H 
DispSymA:
    push B                          ;0FCCBH 
    mov C, A                        ;0FCCCH 
    jmp DispSymC_0                  ;0FCCDH 
DispSymC:
    push B                          ;0FCD0H 
DispSymC_0:
    push D                          ;0FCD1H 
    push H                          ;0FCD2H 
    push PSW                        ;0FCD3H 
    mov A, C                        ;0FCD4H 
    cpi 7FH                         ;0FCD5H ----------------------------------------------------------
    jnz DispSymC_1                  ;0FCD7H  При выводе символа 7F переключаем признак инверсии вывода
    lda INVERSE_DISP_ADDR           ;0FCDAH  Загружаем признак инверсии вывода
    cma                             ;0FCDDH  инвертируем (переключаем)
    sta INVERSE_DISP_ADDR           ;0FCDEH  Сохраняем признак инверсии вывода
    jmp DispSymC_Ret                ;0FCE1H ----------------------------------------------------------
DispSymC_1:
    mvi H, 20H                      ;0FCE4H ----------------------------------------------------------
    sub H                           ;0FCE6H Проверяем, что код символа меньше пробела (такие не выводим)
    jc DispSymC_Hidden              ;0FCE7H ----------------------------------------------------------
    mov L, A                        ;0FCEAH В A индекс символа, для ' ' = 0
    dad H                           ;0FCEBH H = 20H, L = A (индекс символа)
    dad H                           ;0FCECH так как символ состоит из 8 строк, сдвигаем HL влево (т.е. умножаем на 8)
    dad H                           ;0FCEDH H - обнулится, таким образом HL содержит смещение символа от начала знакогенератора
    xchg                            ;0FCEEH сохраняем смещение в DE
    lhld CODEPAGE_ADDR              ;0FCEFH 
    dad D                           ;0FCF2H 
    xchg                            ;0FCF3H 
    call 0FDC4H                     ;0FCF4H 
    xchg                            ;0FCF7H 
    mvi A, 16H                      ;0FCF8H 
    push PSW                        ;0FCFAH 
    push H                          ;0FCFBH 
    lda INVERSE_DISP_ADDR           ;0FCFCH 
    xra M                           ;0FCFFH 
    ani 3FH                         ;0FD00H 
    mov L, A                        ;0FD02H 
    lda 0F3DDH                      ;0FD03H 
    dcr A                           ;0FD06H 
    mvi H, 00H                      ;0FD07H 
    dad H                           ;0FD09H 
    dad H                           ;0FD0AH 
    inr A                           ;0FD0BH 
    jnz 0FD09H                      ;0FD0CH 
    xchg                            ;0FD0FH 
    mov A, B                        ;0FD10H 
    xra M                           ;0FD11H 
    ana M                           ;0FD12H 
    ora D                           ;0FD13H 
    mov M, A                        ;0FD14H 
    inr H                           ;0FD15H 
    mov A, C                        ;0FD16H 
    xra M                           ;0FD17H 
    ana M                           ;0FD18H 
    ora E                           ;0FD19H 
    mov M, A                        ;0FD1AH 
    dcr H                           ;0FD1BH 
    inr L                           ;0FD1CH 
    xchg                            ;0FD1DH 
    pop H                           ;0FD1EH 
    inx H                           ;0FD1FH 
    pop psw                         ;0FD20H 
    sui 03H                         ;0FD21H 
    jp 0FCFAH                       ;0FD23H 
    lxi H, 0FD85H                   ;0FD26H 
    cpi 0F8H                        ;0FD29H 
    jnz 0FCFAH                      ;0FD2BH 
DispSymC_Hidden:
    lhld X_POS_ADDR                 ;0FD2EH 
    call 0FD84H                     ;0FD31H 
    dad B                           ;0FD34H 
    mov A, H                        ;0FD35H 
    cpi 19H                         ;0FD36H 
    jc 0FD7DH                       ;0FD38H 
    jnz 0FD7BH                      ;0FD3BH 
    inr D                           ;0FD3EH 
    mov H, D                        ;0FD3FH 
    jz 0FD7DH                       ;0FD40H 
    push H                          ;0FD43H 
    lxi H, 0000H                    ;0FD44H 
    dad SP                          ;0FD47H 
    shld 0F3DFH                     ;0FD48H 
    lda VAL_30H_ADDR                ;0FD4BH 
    mov B, A                        ;0FD4EH 
    lda VAL_0C0H_ADDR               ;0FD4FH 
    mov H, A                        ;0FD52H 
    mvi L, 0AH                      ;0FD53H 
    sphl                            ;0FD55H 
    mvi L, 00H                      ;0FD56H 
    mvi C, 3CH                      ;0FD58H 
    pop D                           ;0FD5AH 
    mov M, E                        ;0FD5BH 
    inr L                           ;0FD5CH 
    mov M, D                        ;0FD5DH 
    inr L                           ;0FD5EH 
    pop D                           ;0FD5FH 
    mov M, E                        ;0FD60H 
    inr L                           ;0FD61H 
    mov M, D                        ;0FD62H 
    inr L                           ;0FD63H 
    dcr C                           ;0FD64H 
    jnz 0FD5AH                      ;0FD65H 
    lda INVERSE_DISP_ADDR           ;0FD68H 
    inx SP                          ;0FD6BH 
    mov M, A                        ;0FD6CH 
    inr L                           ;0FD6DH 
    jnz 0FD6BH                      ;0FD6EH 
    inr H                           ;0FD71H 
    dcr B                           ;0FD72H 
    jnz 0FD58H                      ;0FD73H 
    lhld 0F3DFH                     ;0FD76H 
    sphl                            ;0FD79H 
    pop H                           ;0FD7AH 
    mvi H, 18H                      ;0FD7BH 
    shld X_POS_ADDR                 ;0FD7DH 
DispSymC_Ret:
    pop psw                         ;0FD80H 
    jmp Ret_Pop_HDB                 ;0FD81H 
    lxi B, 0100H                    ;0FD84H 
    mov D, C                        ;0FD87H 
    inr A                           ;0FD88H 
    cz ClearScreen                  ;0FD89H 
    jz Ret_Zero_HB                  ;0FD8CH 
    cpi 0EBH                        ;0FD8FH 
    rz                              ;0FD91H 
    dcr D                           ;0FD92H 
    adi 05H                         ;0FD93H 
    rz                              ;0FD95H 
    inr D                           ;0FD96H 
    mvi B, 0FFH                     ;0FD97H 
    inr A                           ;0FD99H 
    rz                              ;0FD9AH 
    mvi C, 0FCH                     ;0FD9BH 
    cpi 0EFH                        ;0FD9DH 
    rz                              ;0FD9FH 
    lxi B, 0000H                    ;0FDA0H 
    cpi 0F0H                        ;0FDA3H 
    jnz 0FDAFH                      ;0FDA5H 
    mov A, L                        ;0FDA8H 
    ani 0E0H                        ;0FDA9H 
    adi 20H                         ;0FDABH 
    mov L, A                        ;0FDADH 
    ret                             ;0FDAEH 
    mvi C, 04H                      ;0FDAFH 
    inr A                           ;0FDB1H 
    rz                              ;0FDB2H 
    cpi 0EFH                        ;0FDB3H 
    jz 0FE1BH                       ;0FDB5H 
    adi 0BH                         ;0FDB8H 
    jz 0FDC0H                       ;0FDBAH 
    inr A                           ;0FDBDH 
    rnz                             ;0FDBEH 
Ret_Zero_HB:
    mov H, D                        ;0FDBFH 
    mov L, D                        ;0FDC0H 
    mov B, D                        ;0FDC1H 
    mov C, D                        ;0FDC2H 
    ret                             ;0FDC3H 
    lhld X_POS_ADDR                 ;0FDC4H 
    mov A, L                        ;0FDC7H 
    rrc                             ;0FDC8H 
    mov L, A                        ;0FDC9H 
    rrc                             ;0FDCAH 
    add L                           ;0FDCBH 
    mov B, A                        ;0FDCCH 
    mov L, H                        ;0FDCDH 
    lda VAL_0C0H_ADDR               ;0FDCEH 
    mov H, A                        ;0FDD1H 
    mov A, B                        ;0FDD2H 
    dcr H                           ;0FDD3H 
    inr H                           ;0FDD4H 
    sui 04H                         ;0FDD5H 
    jnc 0FDD4H                      ;0FDD7H 
    sta 0F3DDH                      ;0FDDAH 
    push H                          ;0FDDDH 
    lxi H, 00FCH                    ;0FDDEH 
    dad H                           ;0FDE1H 
    dad H                           ;0FDE2H 
    inr A                           ;0FDE3H 
    jnz 0FDE1H                      ;0FDE4H 
    mov B, H                        ;0FDE7H 
    mov C, L                        ;0FDE8H 
    pop H                           ;0FDE9H 
    mov A, L                        ;0FDEAH 
    rlc                             ;0FDEBH 
    rlc                             ;0FDECH 
    rlc                             ;0FDEDH 
    add L                           ;0FDEEH 
    add L                           ;0FDEFH 
    mov L, A                        ;0FDF0H 
    ret                             ;0FDF1H 
    call 0FDC4H                     ;0FDF2H 
    adi 09H                         ;0FDF5H 
    mov L, A                        ;0FDF7H 
    mov A, B                        ;0FDF8H 
    xra M                           ;0FDF9H 
    mov M, A                        ;0FDFAH 
    inr H                           ;0FDFBH 
    mov A, C                        ;0FDFCH 
    xra M                           ;0FDFDH 
    mov M, A                        ;0FDFEH 
    ret                             ;0FDFFH 
ClearScreen:
    push PSW                        ;0FE00H 
    push H                          ;0FE01H 
    lda VAL_0C0H_ADDR               ;0FE02H Старший байт начала экранной области, начало 0C0H -> 0C000H
    mov H, A                        ;0FE05H 
    lda VAL_30H_ADDR                ;0FE06H Старший байт размера экранной области, размер 30H ->  3000H
    add H                           ;0FE09H 
    mov C, A                        ;0FE0AH Запоминаем старший байт конца экранной области, до этого адреса заполняем
    mvi L, 00H                      ;0FE0BH В HL начало экранной области 0C000H
    lda INVERSE_DISP_ADDR           ;0FE0DH 
    mov B, A                        ;0FE10H 
ClearScreen_Loop:
    mov M, B                        ;0FE11H 
    inx H                           ;0FE12H 
    mov A, H                        ;0FE13H 
    cmp C                           ;0FE14H Проверяем на выход за пределы экранной области
    jnz ClearScreen_Loop            ;0FE15H 
    pop H                           ;0FE18H 
    pop psw                         ;0FE19H 
    ret                             ;0FE1AH 
    lxi B, 4014H                    ;0FE1BH 
    mov A, B                        ;0FE1EH 
    ei                              ;0FE1FH 
    dcr A                           ;0FE20H 
    jnz 0FE1FH                      ;0FE21H 
    mov A, B                        ;0FE24H 
    di                              ;0FE25H 
    dcr A                           ;0FE26H 
    jnz 0FE25H                      ;0FE27H 
    dcr C                           ;0FE2AH 
    jnz 0FE1EH                      ;0FE2BH 
    mov B, C                        ;0FE2EH 
    ret                             ;0FE2FH 
Label_Version:
    DB    1FH                       ;0FE30H 1FH -> Спец. символ для очистки экрана
    DB    ' orion-128.2', 0         ;0FE31H 
Label_Prompt:
    DB    0DH                       ;0FE3EH 0DH (13) -> Спец. символ в начало строки
    DB    0AH                       ;0FE3FH 0AH (10) -> Спец. символ новая строка
    DB    0AH                       ;0FE40H 0AH (10) -> Спец. символ новая строка
    DB    ' =>'                     ;0FE41H 
    DB    07H                       ;0FE44H 
    DB    0                         ;0FE45H 
Unknown_Data:
    DB    53H                       ;0FE46H 
    DB    56H                       ;0FE47H 
CodePageTable:
    DB    11000000B                 ;0FE48H  ' '
    DB    10000100B                 ;0FE49H  '!'
    DB    00000000B                 ;0FE4AH  '!'
    DB    00000100B                 ;0FE4BH  '!'
    DB    01001010B                 ;0FE4CH  '"'
    DB    01100000B                 ;0FE4DH  '"'
    DB    00101010B                 ;0FE4EH  '#'
    DB    00011111B                 ;0FE4FH  '#'
    DB    00001010B                 ;0FE50H  '#'
    DB    00011111B                 ;0FE51H  '#'
    DB    00101010B                 ;0FE52H  '#'
    DB    00000100B                 ;0FE53H  '$'
    DB    00001111B                 ;0FE54H  '$'
    DB    00010100B                 ;0FE55H  '$'
    DB    00001110B                 ;0FE56H  '$'
    DB    00000101B                 ;0FE57H  '$'
    DB    00011110B                 ;0FE58H  '$'
    DB    00000100B                 ;0FE59H  '$'
    DB    00011000B                 ;0FE5AH  '%'
    DB    00011001B                 ;0FE5BH  '%'
    DB    00000010B                 ;0FE5CH  '%'
    DB    00000100B                 ;0FE5DH  '%'
    DB    00001000B                 ;0FE5EH  '%'
    DB    00010011B                 ;0FE5FH  '%'
    DB    00000011B                 ;0FE60H  '%'
    DB    00000100B                 ;0FE61H  '&'
    DB    00101010B                 ;0FE62H  '&'
    DB    00001100B                 ;0FE63H  '&'
    DB    00010101B                 ;0FE64H  '&'
    DB    00010010B                 ;0FE65H  '&'
    DB    00001101B                 ;0FE66H  '&'
    DB    00100110B                 ;0FE67H  '&'
    DB    00000010B                 ;0FE68H  '''
    DB    00000100B                 ;0FE69H  '''
    DB    01000000B                 ;0FE6AH  '''
    DB    00000010B                 ;0FE6BH  '('
    DB    00000100B                 ;0FE6CH  '('
    DB    01001000B                 ;0FE6DH  '('
    DB    00000100B                 ;0FE6EH  '('
    DB    00000010B                 ;0FE6FH  '('
    DB    00001000B                 ;0FE70H  ')'
    DB    00000100B                 ;0FE71H  ')'
    DB    01000010B                 ;0FE72H  ')'
    DB    00000100B                 ;0FE73H  ')'
    DB    00001000B                 ;0FE74H  ')'
    DB    00000000B                 ;0FE75H  '*'
    DB    00000100B                 ;0FE76H  '*'
    DB    00010101B                 ;0FE77H  '*'
    DB    00001110B                 ;0FE78H  '*'
    DB    00010101B                 ;0FE79H  '*'
    DB    00000100B                 ;0FE7AH  '*'
    DB    00000000B                 ;0FE7BH  '*'
    DB    00000000B                 ;0FE7CH  '+'
    DB    00100100B                 ;0FE7DH  '+'
    DB    00011111B                 ;0FE7EH  '+'
    DB    00100100B                 ;0FE7FH  '+'
    DB    00000000B                 ;0FE80H  '+'
    DB    01000000B                 ;0FE81H  ','
    DB    00101100B                 ;0FE82H  ','
    DB    00000100B                 ;0FE83H  ','
    DB    00001000B                 ;0FE84H  ','
    DB    01000000B                 ;0FE85H  '-'
    DB    00011111B                 ;0FE86H  '-'
    DB    01000000B                 ;0FE87H  '-'
    DB    10000000B                 ;0FE88H  '.'
    DB    00101100B                 ;0FE89H  '.'
    DB    00000000B                 ;0FE8AH  '/'
    DB    00000001B                 ;0FE8BH  '/'
    DB    00000010B                 ;0FE8CH  '/'
    DB    00000100B                 ;0FE8DH  '/'
    DB    00001000B                 ;0FE8EH  '/'
    DB    00010000B                 ;0FE8FH  '/'
    DB    00000000B                 ;0FE90H  '/'
    DB    00001110B                 ;0FE91H  '0'
    DB    00010001B                 ;0FE92H  '0'
    DB    00010011B                 ;0FE93H  '0'
    DB    00010101B                 ;0FE94H  '0'
    DB    00011001B                 ;0FE95H  '0'
    DB    00010001B                 ;0FE96H  '0'
    DB    00001110B                 ;0FE97H  '0'
    DB    00000100B                 ;0FE98H  '1'
    DB    00001100B                 ;0FE99H  '1'
    DB    01100100B                 ;0FE9AH  '1'
    DB    00001110B                 ;0FE9BH  '1'
    DB    00001110B                 ;0FE9CH  '2'
    DB    00010001B                 ;0FE9DH  '2'
    DB    00000001B                 ;0FE9EH  '2'
    DB    00000110B                 ;0FE9FH  '2'
    DB    00001000B                 ;0FEA0H  '2'
    DB    00010000B                 ;0FEA1H  '2'
    DB    00011111B                 ;0FEA2H  '2'
    DB    00011111B                 ;0FEA3H  '3'
    DB    00000001B                 ;0FEA4H  '3'
    DB    00000010B                 ;0FEA5H  '3'
    DB    00000110B                 ;0FEA6H  '3'
    DB    00000001B                 ;0FEA7H  '3'
    DB    00010001B                 ;0FEA8H  '3'
    DB    00001110B                 ;0FEA9H  '3'
    DB    00000010B                 ;0FEAAH  '4'
    DB    00000110B                 ;0FEABH  '4'
    DB    00001010B                 ;0FEACH  '4'
    DB    00010010B                 ;0FEADH  '4'
    DB    00011111B                 ;0FEAEH  '4'
    DB    00100010B                 ;0FEAFH  '4'
    DB    00011111B                 ;0FEB0H  '5'
    DB    00010000B                 ;0FEB1H  '5'
    DB    00011110B                 ;0FEB2H  '5'
    DB    00100001B                 ;0FEB3H  '5'
    DB    00010001B                 ;0FEB4H  '5'
    DB    00001110B                 ;0FEB5H  '5'
    DB    00000111B                 ;0FEB6H  '6'
    DB    00001000B                 ;0FEB7H  '6'
    DB    00010000B                 ;0FEB8H  '6'
    DB    00011110B                 ;0FEB9H  '6'
    DB    00110001B                 ;0FEBAH  '6'
    DB    00001110B                 ;0FEBBH  '6'
    DB    00011111B                 ;0FEBCH  '7'
    DB    00000001B                 ;0FEBDH  '7'
    DB    00000010B                 ;0FEBEH  '7'
    DB    00000100B                 ;0FEBFH  '7'
    DB    01001000B                 ;0FEC0H  '7'
    DB    00001110B                 ;0FEC1H  '8'
    DB    00110001B                 ;0FEC2H  '8'
    DB    00001110B                 ;0FEC3H  '8'
    DB    00110001B                 ;0FEC4H  '8'
    DB    00001110B                 ;0FEC5H  '8'
    DB    00001110B                 ;0FEC6H  '9'
    DB    00110001B                 ;0FEC7H  '9'
    DB    00001111B                 ;0FEC8H  '9'
    DB    00000001B                 ;0FEC9H  '9'
    DB    00000010B                 ;0FECAH  '9'
    DB    00011100B                 ;0FECBH  '9'
    DB    00000000B                 ;0FECCH  двоеточие
    DB    00101100B                 ;0FECDH  двоеточие
    DB    00100000B                 ;0FECEH  двоеточие
    DB    00101100B                 ;0FECFH  двоеточие
    DB    00101100B                 ;0FED0H  ';'
    DB    00000000B                 ;0FED1H  ';'
    DB    00101100B                 ;0FED2H  ';'
    DB    00000100B                 ;0FED3H  ';'
    DB    00001000B                 ;0FED4H  ';'
    DB    00000010B                 ;0FED5H  '<'
    DB    00000100B                 ;0FED6H  '<'
    DB    00001000B                 ;0FED7H  '<'
    DB    00010000B                 ;0FED8H  '<'
    DB    00001000B                 ;0FED9H  '<'
    DB    00000100B                 ;0FEDAH  '<'
    DB    00000010B                 ;0FEDBH  '<'
    DB    00100000B                 ;0FEDCH  '='
    DB    00011111B                 ;0FEDDH  '='
    DB    00000000B                 ;0FEDEH  '='
    DB    00011111B                 ;0FEDFH  '='
    DB    00100000B                 ;0FEE0H  '='
    DB    00001000B                 ;0FEE1H  '>'
    DB    00000100B                 ;0FEE2H  '>'
    DB    00000010B                 ;0FEE3H  '>'
    DB    00000001B                 ;0FEE4H  '>'
    DB    00000010B                 ;0FEE5H  '>'
    DB    00000100B                 ;0FEE6H  '>'
    DB    00001000B                 ;0FEE7H  '>'
    DB    00001110B                 ;0FEE8H  '?'
    DB    00010001B                 ;0FEE9H  '?'
    DB    00000001B                 ;0FEEAH  '?'
    DB    00000010B                 ;0FEEBH  '?'
    DB    00000100B                 ;0FEECH  '?'
    DB    00000000B                 ;0FEEDH  '?'
    DB    00000100B                 ;0FEEEH  '?'
    DB    00001110B                 ;0FEEFH  '@'
    DB    00010001B                 ;0FEF0H  '@'
    DB    00010011B                 ;0FEF1H  '@'
    DB    00010101B                 ;0FEF2H  '@'
    DB    00010111B                 ;0FEF3H  '@'
    DB    00010000B                 ;0FEF4H  '@'
    DB    00001110B                 ;0FEF5H  '@'
    DB    00000100B                 ;0FEF6H  'A'
    DB    00001010B                 ;0FEF7H  'A'
    DB    00110001B                 ;0FEF8H  'A'
    DB    00011111B                 ;0FEF9H  'A'
    DB    00110001B                 ;0FEFAH  'A'
    DB    00011110B                 ;0FEFBH  'B'
    DB    00110001B                 ;0FEFCH  'B'
    DB    00011110B                 ;0FEFDH  'B'
    DB    00110001B                 ;0FEFEH  'B'
    DB    00011110B                 ;0FEFFH  'B'
    DB    00001110B                 ;0FF00H  'C'
    DB    00010001B                 ;0FF01H  'C'
    DB    01010000B                 ;0FF02H  'C'
    DB    00010001B                 ;0FF03H  'C'
    DB    00001110B                 ;0FF04H  'C'
    DB    00011110B                 ;0FF05H  'D'
    DB    10001001B                 ;0FF06H  'D'
    DB    00011110B                 ;0FF07H  'D'
    DB    00011111B                 ;0FF08H  'E'
    DB    00110000B                 ;0FF09H  'E'
    DB    00011110B                 ;0FF0AH  'E'
    DB    00110000B                 ;0FF0BH  'E'
    DB    00011111B                 ;0FF0CH  'E'
    DB    00011111B                 ;0FF0DH  'F'
    DB    00110000B                 ;0FF0EH  'F'
    DB    00011110B                 ;0FF0FH  'F'
    DB    01010000B                 ;0FF10H  'F'
    DB    00001110B                 ;0FF11H  'G'
    DB    00010001B                 ;0FF12H  'G'
    DB    00110000B                 ;0FF13H  'G'
    DB    00010011B                 ;0FF14H  'G'
    DB    00010001B                 ;0FF15H  'G'
    DB    00001111B                 ;0FF16H  'G'
    DB    01010001B                 ;0FF17H  'H'
    DB    00011111B                 ;0FF18H  'H'
    DB    01010001B                 ;0FF19H  'H'
    DB    00001110B                 ;0FF1AH  'I'
    DB    10000100B                 ;0FF1BH  'I'
    DB    00001110B                 ;0FF1CH  'I'
    DB    01100001B                 ;0FF1DH  'J'
    DB    00110001B                 ;0FF1EH  'J'
    DB    00001110B                 ;0FF1FH  'J'
    DB    00010001B                 ;0FF20H  'K'
    DB    00010010B                 ;0FF21H  'K'
    DB    00010100B                 ;0FF22H  'K'
    DB    00011000B                 ;0FF23H  'K'
    DB    00010100B                 ;0FF24H  'K'
    DB    00010010B                 ;0FF25H  'K'
    DB    00010001B                 ;0FF26H  'K'
    DB    10010000B                 ;0FF27H  'L'
    DB    00010001B                 ;0FF28H  'L'
    DB    00011111B                 ;0FF29H  'L'
    DB    00010001B                 ;0FF2AH  'M'
    DB    00011011B                 ;0FF2BH  'M'
    DB    00110101B                 ;0FF2CH  'M'
    DB    01010001B                 ;0FF2DH  'M'
    DB    00110001B                 ;0FF2EH  'N'
    DB    00011001B                 ;0FF2FH  'N'
    DB    00010101B                 ;0FF30H  'N'
    DB    00010011B                 ;0FF31H  'N'
    DB    00110001B                 ;0FF32H  'N'
    DB    00001110B                 ;0FF33H  'O'
    DB    10010001B                 ;0FF34H  'O'
    DB    00001110B                 ;0FF35H  'O'
    DB    00011110B                 ;0FF36H  'P'
    DB    00110001B                 ;0FF37H  'P'
    DB    00011110B                 ;0FF38H  'P'
    DB    01010000B                 ;0FF39H  'P'
    DB    00001110B                 ;0FF3AH  'Q'
    DB    01010001B                 ;0FF3BH  'Q'
    DB    00010101B                 ;0FF3CH  'Q'
    DB    00010010B                 ;0FF3DH  'Q'
    DB    00001101B                 ;0FF3EH  'Q'
    DB    00011110B                 ;0FF3FH  'R'
    DB    00110001B                 ;0FF40H  'R'
    DB    00011110B                 ;0FF41H  'R'
    DB    00010100B                 ;0FF42H  'R'
    DB    00010010B                 ;0FF43H  'R'
    DB    00010001B                 ;0FF44H  'R'
    DB    00001110B                 ;0FF45H  'S'
    DB    00010001B                 ;0FF46H  'S'
    DB    00010000B                 ;0FF47H  'S'
    DB    00001110B                 ;0FF48H  'S'
    DB    00000001B                 ;0FF49H  'S'
    DB    00010001B                 ;0FF4AH  'S'
    DB    00001110B                 ;0FF4BH  'S'
    DB    00011111B                 ;0FF4CH  'T'
    DB    10100100B                 ;0FF4DH  'T'
    DB    10110001B                 ;0FF4EH  'U'
    DB    00001110B                 ;0FF4FH  'U'
    DB    01010001B                 ;0FF50H  'Y'
    DB    00101010B                 ;0FF51H  'Y'
    DB    00100100B                 ;0FF52H  'Y'
    DB    01010001B                 ;0FF53H  'W'
    DB    01010101B                 ;0FF54H  'W'
    DB    00001010B                 ;0FF55H  'W'
    DB    00110001B                 ;0FF56H  'X'
    DB    00001010B                 ;0FF57H  'X'
    DB    00000100B                 ;0FF58H  'X'
    DB    00001010B                 ;0FF59H  'X'
    DB    00110001B                 ;0FF5AH  'X'
    DB    00110001B                 ;0FF5BH  'Y'
    DB    00001010B                 ;0FF5CH  'Y'
    DB    01100100B                 ;0FF5DH  'Y'
    DB    00011111B                 ;0FF5EH  'Z'
    DB    00000001B                 ;0FF5FH  'Z'
    DB    00000010B                 ;0FF60H  'Z'
    DB    00001110B                 ;0FF61H  'Z'
    DB    00001000B                 ;0FF62H  'Z'
    DB    00010000B                 ;0FF63H  'Z'
    DB    00011111B                 ;0FF64H  'Z'
    DB    00001110B                 ;0FF65H  '['
    DB    10001000B                 ;0FF66H  '['
    DB    00001110B                 ;0FF67H  '['
    DB    00000000B                 ;0FF68H  '\'
    DB    00010000B                 ;0FF69H  '\'
    DB    00001000B                 ;0FF6AH  '\'
    DB    00000100B                 ;0FF6BH  '\'
    DB    00000010B                 ;0FF6CH  '\'
    DB    00000001B                 ;0FF6DH  '\'
    DB    00000000B                 ;0FF6EH  '\'
    DB    00001110B                 ;0FF6FH  ']'
    DB    10000010B                 ;0FF70H  ']'
    DB    00001110B                 ;0FF71H  ']'
    DB    00001110B                 ;0FF72H  '^'
    DB    00010001B                 ;0FF73H  '^'
    DB    10000000B                 ;0FF74H  '^'
    DB    10100000B                 ;0FF75H  '_'
    DB    00011111B                 ;0FF76H  '_'
    DB    00010010B                 ;0FF77H  'Ю'
    DB    00110101B                 ;0FF78H  'Ю'
    DB    00011101B                 ;0FF79H  'Ю'
    DB    00110101B                 ;0FF7AH  'Ю'
    DB    00010010B                 ;0FF7BH  'Ю'
    DB    00000100B                 ;0FF7CH  'А'
    DB    00001010B                 ;0FF7DH  'А'
    DB    00110001B                 ;0FF7EH  'А'
    DB    00011111B                 ;0FF7FH  'А'
    DB    00110001B                 ;0FF80H  'А'
    DB    00011111B                 ;0FF81H  'Б'
    DB    00110000B                 ;0FF82H  'Б'
    DB    00011110B                 ;0FF83H  'Б'
    DB    00110001B                 ;0FF84H  'Б'
    DB    00011110B                 ;0FF85H  'Б'
    DB    10010010B                 ;0FF86H  'Ц'
    DB    00011111B                 ;0FF87H  'Ц'
    DB    00000001B                 ;0FF88H  'Ц'
    DB    00000110B                 ;0FF89H  'Д'
    DB    01101010B                 ;0FF8AH  'Д'
    DB    00011111B                 ;0FF8BH  'Д'
    DB    00010001B                 ;0FF8CH  'Д'
    DB    00011111B                 ;0FF8DH  'Е'
    DB    00110000B                 ;0FF8EH  'Е'
    DB    00011110B                 ;0FF8FH  'Е'
    DB    00110000B                 ;0FF90H  'Е'
    DB    00011111B                 ;0FF91H  'Е'
    DB    00000100B                 ;0FF92H  'Ф'
    DB    00011111B                 ;0FF93H  'Ф'
    DB    00110101B                 ;0FF94H  'Ф'
    DB    00011111B                 ;0FF95H  'Ф'
    DB    00100100B                 ;0FF96H  'Ф'
    DB    00011111B                 ;0FF97H  'Г'
    DB    00010001B                 ;0FF98H  'Г'
    DB    10010000B                 ;0FF99H  'Г'
    DB    00110001B                 ;0FF9AH  'Х'
    DB    00001010B                 ;0FF9BH  'Х'
    DB    00000100B                 ;0FF9CH  'Х'
    DB    00001010B                 ;0FF9DH  'Х'
    DB    00110001B                 ;0FF9EH  'Х'
    DB    00110001B                 ;0FF9FH  'И'
    DB    00010011B                 ;0FFA0H  'И'
    DB    00010101B                 ;0FFA1H  'И'
    DB    00011001B                 ;0FFA2H  'И'
    DB    00110001B                 ;0FFA3H  'И'
    DB    00010101B                 ;0FFA4H  'Й'
    DB    00010001B                 ;0FFA5H  'Й'
    DB    00010011B                 ;0FFA6H  'Й'
    DB    00010101B                 ;0FFA7H  'Й'
    DB    00011001B                 ;0FFA8H  'Й'
    DB    00110001B                 ;0FFA9H  'Й'
    DB    00010001B                 ;0FFAAH  'К'
    DB    00010010B                 ;0FFABH  'К'
    DB    00010100B                 ;0FFACH  'К'
    DB    00011000B                 ;0FFADH  'К'
    DB    00010100B                 ;0FFAEH  'К'
    DB    00010010B                 ;0FFAFH  'К'
    DB    00010001B                 ;0FFB0H  'К'
    DB    00000111B                 ;0FFB1H  'Л'
    DB    10001001B                 ;0FFB2H  'Л'
    DB    00011001B                 ;0FFB3H  'Л'
    DB    00010001B                 ;0FFB4H  'М'
    DB    00011011B                 ;0FFB5H  'М'
    DB    00110101B                 ;0FFB6H  'М'
    DB    01010001B                 ;0FFB7H  'М'
    DB    01010001B                 ;0FFB8H  'Н'
    DB    00011111B                 ;0FFB9H  'Н'
    DB    01010001B                 ;0FFBAH  'Н'
    DB    00001110B                 ;0FFBBH  'О'
    DB    10010001B                 ;0FFBCH  'О'
    DB    00001110B                 ;0FFBDH  'О'
    DB    00011111B                 ;0FFBEH  'П'
    DB    10110001B                 ;0FFBFH  'П'
    DB    00001111B                 ;0FFC0H  'Я'
    DB    00110001B                 ;0FFC1H  'Я'
    DB    00001111B                 ;0FFC2H  'Я'
    DB    00000101B                 ;0FFC3H  'Я'
    DB    00001001B                 ;0FFC4H  'Я'
    DB    00010001B                 ;0FFC5H  'Я'
    DB    00011110B                 ;0FFC6H  'Р'
    DB    00110001B                 ;0FFC7H  'Р'
    DB    00011110B                 ;0FFC8H  'Р'
    DB    01010000B                 ;0FFC9H  'Р'
    DB    00001110B                 ;0FFCAH  'С'
    DB    00010001B                 ;0FFCBH  'С'
    DB    01010000B                 ;0FFCCH  'С'
    DB    00010001B                 ;0FFCDH  'С'
    DB    00001110B                 ;0FFCEH  'С'
    DB    00011111B                 ;0FFCFH  'Т'
    DB    10100100B                 ;0FFD0H  'Т'
    DB    01010001B                 ;0FFD1H  'У'
    DB    00001010B                 ;0FFD2H  'У'
    DB    00000100B                 ;0FFD3H  'У'
    DB    00001000B                 ;0FFD4H  'У'
    DB    00010000B                 ;0FFD5H  'У'
    DB    00010001B                 ;0FFD6H  'Ж'
    DB    00110101B                 ;0FFD7H  'Ж'
    DB    00001110B                 ;0FFD8H  'Ж'
    DB    00110101B                 ;0FFD9H  'Ж'
    DB    00010001B                 ;0FFDAH  'Ж'
    DB    00011110B                 ;0FFDBH  'В'
    DB    00110001B                 ;0FFDCH  'В'
    DB    00011110B                 ;0FFDDH  'В'
    DB    00110001B                 ;0FFDEH  'В'
    DB    00011110B                 ;0FFDFH  'В'
    DB    01010000B                 ;0FFE0H  'Ь'
    DB    00011110B                 ;0FFE1H  'Ь'
    DB    00110001B                 ;0FFE2H  'Ь'
    DB    00011110B                 ;0FFE3H  'Ь'
    DB    01010001B                 ;0FFE4H  'Ы'
    DB    00011001B                 ;0FFE5H  'Ы'
    DB    00110101B                 ;0FFE6H  'Ы'
    DB    00011001B                 ;0FFE7H  'Ы'
    DB    00001110B                 ;0FFE8H  'З'
    DB    00010001B                 ;0FFE9H  'З'
    DB    00000001B                 ;0FFEAH  'З'
    DB    00000110B                 ;0FFEBH  'З'
    DB    00000001B                 ;0FFECH  'З'
    DB    00010001B                 ;0FFEDH  'З'
    DB    00001110B                 ;0FFEEH  'З'
    DB    00010001B                 ;0FFEFH  'Ш'
    DB    10010101B                 ;0FFF0H  'Ш'
    DB    00011111B                 ;0FFF1H  'Ш'
    DB    00001110B                 ;0FFF2H  'Э'
    DB    00010001B                 ;0FFF3H  'Э'
    DB    00000001B                 ;0FFF4H  'Э'
    DB    00000111B                 ;0FFF5H  'Э'
    DB    00000001B                 ;0FFF6H  'Э'
    DB    00010001B                 ;0FFF7H  'Э'
    DB    00001110B                 ;0FFF8H  'Э'
    DB    10010101B                 ;0FFF9H  'Щ'
    DB    00011111B                 ;0FFFAH  'Щ'
    DB    00000001B                 ;0FFFBH  'Щ'
    DB    01010001B                 ;0FFFCH  'Ч'
    DB    00011111B                 ;0FFFDH  'Ч'
    DB    01000001B                 ;0FFFEH  'Ч'
    DB    11011111B                 ;0FFFFH  черный прямоугольник
