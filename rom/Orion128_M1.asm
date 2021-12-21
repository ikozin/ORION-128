include "8085.inc"

DisplayModePort	    EQU 0F800H	    ; Порт видеорежима
DisplayPagePort	    EQU 0F900H	    ; Порт банков ОЗУ
DisplayViewPort	    EQU 0FA00H	    ; Порт экранов

Reserv_JMP_ADDR     EQU 0F3C9H      ; XX   =   0C3H (код команды JMP)
Reserv_ADDR	        EQU 0F3CAH      ; XXXX = Вектор п/п F821h (NotImplemented_Entry)
DispSymC_JMP_ADDR   EQU 0F3CCH      ; XX   =   0C3H (код команды JMP)
DispSymC_ADDR       EQU 0F3CDH      ; XXXX = Вектор п/п F809h (DispSymC_JMP_ADDR)
SCREEN_ADDR_HI		EQU 0F3CFH		; XX   =   0C0H (старший байт начала видеопамяти 0C000H)
SCREEN_SIZE_HI		EQU 0F3D0H		; XX   =    30H, Ширина экрана (старший байт размера видеопамяти 3000H = 12К)
CODEPAGE_ADDR		EQU 0F3D1H		; XXXX = 0F000H, Адрес знакогенератора
INVERSE_DISP_ADDR	EQU 0F3D3H		; XX   =    00H, Признак ввода (00-прямой, FF-инверсный)
X_POS_ADDR			EQU 0F3D4H		; XX   = Позиция курсора
Y_POS_ADDR			EQU 0F3D5H		; XX   = Позиция курсора
HOT_RESTART			EQU	0F3D6H		; ???
RESTART_ADDR        EQU 0F3D8H		; XXXX = Адрес возврата из подпрограммы чтения байта (OF806H) при “зависании” или выпадании сигнала.
									; МОНИТОР заносит в эту ячейку адрес “теплого старта”.
									; Программа пользователя должна заносить в эту ячейку свой адрес возврата, 
									; в противном случае при невозможности чтения байта программа осуществит возврат в МОНИТОР.
PAUSE_SAVE_ADDR		EQU 0F3DAH		; XX   =    40H (константа записи на магнитофон - 1200 бод)
PAUSE_LOAD_ADDR		EQU 0F3DBH		; XX   =    60H (константа чтения c магнитофонa)
LOADBYTE_ADDR	    EQU 0F3DCH		; XXXX = Переменная п/п LoadByteA
USER_MAX_RAM_ADDR   EQU 0F3E3H      ; XXXX = 0BFFFH
KEY_LED             EQU 0F3E5H      ; XX   = 00H - LAT, 0FFH - РУС
KEY_CODE            EQU 0F3E6H      ; XX   = Автоповтор клавиатуры
Cmd_Param           EQU 0F3EEH      ; XXXX = Сохранение адреса (CMDL)
Cmd_Buffer_Start    EQU 0F3F0H		; Буфер для ввода команды = 16 символов
Cmd_Buffer          EQU 0F3F1H		; Буфер для ввода команды = 15 символов
Run_0BFFDH			EQU 0BFFDH

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
;Коды клавиш    00H 08H 10H 18H 20H 28H 30H 38H
;               PA0 PA1 PA2 PA3 PA4 PA5 PA6 PA7
;               01H 02H 04H 08H 10H 20H 40H 80H
;00H  PB0  01H   \  TAB  0   8   @   H   P   X 
;01H  PB1  02H  СТР  ПС  1   9   A   I   Q   Y 
;02H  PB2  04H  АР2  ВК  2   *   B   J   R   Z 
;03H  PB3  08H   F1  ЗБ  3   +   C   K   S   [ 
;04H  PB4  10H   F2  ←   4   ,   D   L   T   \ 
;05H  PB5  20H   F3  ↑   5   -   E   M   U   ] 
;06H  PB6  40H   F4  →   6   .   F   N   V   ^ 
;07H  PB7  80H   F5  ↓   7   /   G   O   W   _ 
;-----------------------------------------------------------------------------------------------------------------------------------

ORG 0F800H

    jmp  StartCode                  ;0F800H 

InputKeyA_Entry:
;------------------------------------------
; Ввод символа с клавиатуры
;  вх:  нет
;  вых: A  = введенный символ
;------------------------------------------
    jmp  InputKeyA                  ;0F803H

LoadByteA_Entry:
;------------------------------------------
; Ввод байта с магнитофона
;  вх:  A  = 0FFH - с поиском синхробайта
;       A  = 08H  - без поиска
;  вых: A  = введенный символ
;------------------------------------------
    jmp  LoadByteA                  ;0F806H

DisplaySymC_Entry:
;------------------------------------------
; Вывод символа на экран
;  вх:  C  = выводимый символ
;  вых: нет
;------------------------------------------
    jmp  DispSymC_JMP_ADDR          ;0F809H

SaveByteC_Entry:
;------------------------------------------
; Запись байта на магнитофон
;  вх:  C  = записываемый байт
;  вых: нет
;------------------------------------------
    jmp  SaveByteC                  ;0F80CH

DisplaySymA_Entry:
;------------------------------------------
; Вывод символа на экран
;  вх:  A  = выводимый символ
;  вых: нет
;------------------------------------------
    jmp  DispSymA                   ;0F80FH

GetKeyStateA_Entry:
;------------------------------------------
; Опрос состояния клавиатуры
;  вх:  нет
;  вых: A  = 00H  - не нажата
;       A  = 0FFH - нажата
;------------------------------------------
    jmp  GetKeyStateA               ;0F812H

DisplayHexA_Entry:
;------------------------------------------
; Вывод байта на экран в HEX-коде
;  вх:  A  = выводимый символ
;  вых: нет
;------------------------------------------
    jmp  DisplayHexA                ;0F815H

DisplayTextHL_Entry:
;------------------------------------------
; Вывод на экран сообщений
;  вх:  HL = адрес начала сообщения, конечный байт - 00H
;  вых: нет
;------------------------------------------
    jmp  DisplayTextHL              ;0F818H

InputkeyCodeA_Entry:
;------------------------------------------
; Ввод кода нажатой клавиши inkey
;  вх:  нет
;  вых: A  = 0FFH - не нажата
;       A  = 0FEH - РУС/ЛАТ
;       A  = код клавиши
;------------------------------------------
    jmp  InputKeyCodeA              ;0F81BH

GetPosCursor_Entry:
;------------------------------------------
; Запрос положения курсора
;  вх:  нет
;  вых: H  = номер строки  Y (0—18Н)
;       L  = номер позиции X (0—3FH)
;------------------------------------------
    jmp  GetPosCursor               ;0F81EH

NotImplemented_Entry:
;------------------------------------------
; Не используется
;------------------------------------------
    jmp  Reserv_JMP_ADDR            ;0F821H

LoadFile_Entry:
;------------------------------------------
; Чтение файла из магнитной ленты
;------------------------------------------
    jmp  LoadFile                   ;0F824H

SaveFile_Entry:
;------------------------------------------
; Запись файла на магнитную ленту
;  вх:  HL = нач. адрес массива
;       DE = конечный адрес
;  вых: нет
;------------------------------------------
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
;------------------------------------------
; Установить положение курсора
;  вх:  H  = номер строки  Y (0—18Н)
;       L  = номер позиции X (0—3FH)
;  вых: нет
;------------------------------------------
    jmp  SetPosCursor               ;0F83CH
    ret                             ;0F83FH 
    nop                             ;0F840H 
    nop                             ;0F841H 

StartCode:
    lxi  SP, Reserv_JMP_ADDR        ;0F842H 
    xra  A                          ;0F845H Обнуляем A
    sta  0F800H                     ;0F846H Порт - Управление цветным режимом, записываем 00H
    sta  0F900H                     ;0F849H Порт - Управление переключением страниц памяти, записываем 00H
    sta  0FA00H                     ;0F84CH Порт - Управление переключением экранов, записываем 00H
    sta  INVERSE_DISP_ADDR          ;0F84FH Устанавливаем признак инверсионного вывода, записываем 00H (00H - нормальный вывод, 0FFH - инверсионный вывод)
    sta  0F402H                     ;0F852H 
    mvi  A, 0C3H                    ;0F855H Код команды безусловного перехода JMP
    sta  DispSymC_JMP_ADDR          ;0F857H 
    sta  Reserv_JMP_ADDR            ;0F85AH 
    call InitializeCodePage         ;0F85DH 
    lxi  H, 6040H                   ;0F860H Значение 6040H (запись - 1200 бод = 40H, чтение - для стандартной скорости = 60H)
    shld PAUSE_SAVE_ADDR            ;0F863H сохраняем в ячейке. 0F3DAH - ячейка в которой хранится константа записи на магнитную 40H. 0F3DBH - ячейка в которой хранится константа чтения с магнитной ленты = 60H
    lxi  H, Label_Version           ;0F866H 
    call DisplayTextHL              ;0F869H Выводим "orion-128.2"
HandleCmd:
    lxi  SP, Reserv_JMP_ADDR        ;0F86CH Начало цикла обработки команд
    mvi  A, 8AH                     ;0F86FH 
    sta  0F403H                     ;0F871H 
    lxi  H, Label_Prompt            ;0F874H 
    call DisplayTextHL              ;0F877H Выводим приглашение для ввода команды "=>"
    sta  KEY_LED                    ;0F87AH 
    lxi  H, HotReset                ;0F87DH 
    shld RESTART_ADDR               ;0F880H 
    lxi  H, HandleCmd               ;0F883H Сохраняем начало цикла обработки команд в HL
    push H                          ;0F886H 
    call Handle_Loop_Start          ;0F887H 
    call DisplayNewLine             ;0F88AH 
    call Handle_Parse_Cmd_Params    ;0F88DH 
    lda  Cmd_Buffer_Start           ;0F890H 
    cpi  4DH                        ;0F893H M<адрес><ВК>                     - Модификация ячеек ОЗУ
    jz   EditMemory                 ;0F895H 
    cpi  44H                        ;0F898H D<нач. адрес>,<номер стр.><ВК>   - Вывод дампа памяти
    jz   DumpMemory                 ;0F89AH 
    cpi  49H                        ;0F89DH I<ВК>                            - Ввод с магнитофона
    jz   LoadFile                   ;0F89FH 
    cpi  4FH                        ;0F8A2H O<нач. адрес>,<конеч. адрес><ВК> - Вывод на магнитофон
    jz   SaveFile                   ;0F8A4H 
    cpi  52H                        ;0F8A7H R<ВК>
    jz   CMD_ROM_BOOT               ;0F8A9H 
    cpi  5AH                        ;0F8ACH Z<ВК>                            - Передача управления по адресу 0BFFDH
    jz   Run_0BFFDH                 ;0F8AEH 
    cpi  43H                        ;0F8B1H C<байт цвета><ВК>                - Включение цветного режима дисплея
    jz   SetColorMode               ;0F8B3H 
    cpi  47H                        ;0F8B6H G<адрес><ВК>                     - Передача управления по адресу
    jnz  HotReset                   ;0F8B8H 
    pchl                            ;0F8BBH Переходим на начало цикла обработки команд (см 0F883H)

InitializeCodePage:
    lxi  H, 0F000H                  ;0F8BCH Начальный адрес знакогенератора
    shld CODEPAGE_ADDR              ;0F8BFH сохраняем в ячейке 0F3D1H
    call LoadCodePage               ;0F8C2H загружаем знакогенератор
    lxi  H, 30C0H                   ;0F8C5H Значение 30C0H
    shld SCREEN_ADDR_HI             ;0F8C8H сохраняем в ячейках: 0C0H -> 0F3CFH (старший байт начала видеопамяти 0C000H), 30H -> 0F3D0H (старший байт размера видеопамяти 3000H = 12К)
    lxi  H, DispSymC                ;0F8CBH Адрес 0FCD0H (0F809H Вывод символа на экран, 0F855H Код команды безусловного перехода JMP)
    shld DispSymC_ADDR              ;0F8CEH сохраняем в ячейке 0F3CDH
    lxi  H, Stub                    ;0F8D1H Значение 0F8DDH
    shld Reserv_ADDR                ;0F8D4H сохраняем в ячейке 0F3CAH
    lxi  H, 0BFFFH                  ;0F8D7H Значение 0BFFFH
    shld USER_MAX_RAM_ADDR          ;0F8DAH сохраняем в ячейке 0F3E3H
Stub:
    ret                             ;0F8DDH 

Handle_Loop_Start:
    lxi  D, Cmd_Buffer_Start        ;0F8DEH 
Handle_Loop:
    call InputKeyA                  ;0F8E1H 
    cpi  2EH                        ;0F8E4H 
    jz   HotReset                   ;0F8E6H 
    cpi  7FH                        ;0F8E9H 7FH -> Спец. символ - инверсия вывода
    jz   Handle_Inverse             ;0F8EBH 
    cpi  18H                        ;0F8EEH 18H -> Спец. символ - вправо
    jz   Handle_DispSymA            ;0F8F0H 
    cpi  08H                        ;0F8F3H 08H -> Спец. символ - влево 
    jnz  0F907H                     ;0F8F5H 
    mvi  A, 0F0H                    ;0F8F8H 
    cmp  E                          ;0F8FAH 
    jz   Handle_Loop                ;0F8FBH 
Handle_KeyLeft:
    mvi  A, 08H                     ;0F8FEH 08H -> Спец. символ - влево, перемещаем курсор влево (для исправления ввода)
    dcx  D                          ;0F900H Адрес в DE тоже сдвигаем на символ вперед (для исправления ввода)
Handle_Inverse:
    call DispSymA                   ;0F901H 
    jmp  Handle_Loop                ;0F904H 
    stax D                          ;0F907H 
Handle_DispSymA:
    call DispSymA                   ;0F908H 
    cpi  0DH                        ;0F90BH Проверяем на код клавиши Enter (0DH)
    rz                              ;0F90DH Если Enter (0DH) нажали, то выходим, иначе продолжаем обработку
    inx  D                          ;0F90EH 
    mov  A, E                       ;0F90FH 
    cpi  0FFH                       ;0F910H 
    jnz  Handle_Loop                ;0F912H 
    jmp  Handle_KeyLeft             ;0F915H 

Handle_Parse_Cmd_Params:
    lxi  D, Cmd_Buffer              ;0F918H Разбираем введенные параметры команды (без пробелов), сама команда по адресу Cmd_Buffer_Start
    call Handle_ParseParam          ;0F91BH 
    shld Cmd_Param                  ;0F91EH 
    rc                              ;0F921H Если нет признака конца команды, то обрабатываем следующий параметр
    call Handle_ParseParam          ;0F922H 
    xchg                            ;0F925H 
    lhld Cmd_Param                  ;0F926H 
    ret                             ;0F929H 

Handle_ParseParam:
    lxi  H, 0000H                   ;0F92AH В HL будет значение текущего введенного параметра
    mov  B, L                       ;0F92DH 
    mov  C, L                       ;0F92EH 
Handle_ParseNextHex:
    dad  B                          ;0F92FH Сохраняем в HL младшую тетраду из BC
    ldax D                          ;0F930H Загружаем обрабатываемый символ по адресу DE
    inx  D                          ;0F931H Переходим к следующему символу
    cpi  0DH                        ;0F932H 0DH -> Спец. символ - Enter (ВК)
    jz   Handle_EnterCommand        ;0F934H Ввод команды
    cpi  2CH                        ;0F937H ','
    rz                              ;0F939H Завершаем обрабатывать текущий параметр введенной команды
    sui  30H                        ;0F93AH ------------------------------
    jm   HotReset                   ;0F93CH Проверяем что символ является HEX значением 0-9 или A-F
    cpi  0AH                        ;0F93FH Если символ меньше '0', то идем на горячий сброс
    jm   Handle_HexC                ;0F941H Проверяем это цифра или буква 
    cpi  11H                        ;0F944H Если буква, то проверяем дальше
    jm   HotReset                   ;0F946H Проверяем что введенный
    cpi  17H                        ;0F949H символ в диапазоне A-F
    jp   HotReset                   ;0F94BH Если буква больше F, то идем на горячий сброс
    sui  07H                        ;0F94EH Приводим символ к числу и сохраняем в C
Handle_HexC:
    mov  C, A                       ;0F950H ------------------------------
    dad  H                          ;0F951H Сдвигаем 
    dad  H                          ;0F952H на 4 бита
    dad  H                          ;0F953H (тетраду [полубайт])
    dad  H                          ;0F954H влево
    jnc  Handle_ParseNextHex        ;0F955H 
HotReset:
    mvi  A, 3FH                     ;0F958H '?'
    call DispSymA                   ;0F95AH 
    jmp  HandleCmd                  ;0F95DH 

Handle_EnterCommand:
    lxi  D, 0000H                   ;0F960H 
    stc                             ;0F963H Признак конца команды
    ret                             ;0F964H 

DisplayHexM:
    mov  A, M                       ;0F965H 
DisplayHexA:
    push PSW                        ;0F966H сохраняем аккумулятор и слово состояния
    rrc                             ;0F967H Старшие 4 бита загоняем в младшие
    rrc                             ;0F968H Старшие 4 бита загоняем в младшие
    rrc                             ;0F969H Старшие 4 бита загоняем в младшие
    rrc                             ;0F96AH Старшие 4 бита загоняем в младшие
    call DisplayTetrasHex           ;0F96BH Показываем старшие 4 бита (которые загнали в младшие) в HEX формате
    pop  psw                        ;0F96EH Восстанавливаем аккумулятор
DisplayTetrasHex:
    ani  0FH                        ;0F96FH Отображаем тетраду (4 младших бита) в HEX формате
    cpi  0AH                        ;0F971H 
    jm   DisplayTetrasHex_1         ;0F973H 
    adi  07H                        ;0F976H A -> 'A' (+ 07H + 30H), 'A'=41H, 'B'=42H, 'C'=43H, 'D'=44H, 'E'=45H, 'F'=46H
DisplayTetrasHex_1:
    adi  30H                        ;0F978H 0 -> '0' (+ 30H), '0'=30H,'1'=31H,'2'=32H,'3'=33H,'4'=34H,'5'=35H,'6'=36H,'7'=37H,'8'=38H,'9'=39H
    push B                          ;0F97AH 
    mov  C, A                       ;0F97BH 
    call DisplaySymC_Entry          ;0F97CH Отображаем HEX символ
    pop  B                          ;0F97FH 
    ret                             ;0F980H 

DisplayTextHL:
    mov  A, M                       ;0F981H Загружаем очередной символ из памяти по адресу в HL
    ana  A                          ;0F982H Проверяем его на 0 (признак конца строки)
    rz                              ;0F983H Выходим если достигли признака конца строки
    push B                          ;0F984H 
    mov  C, A                       ;0F985H 
    call DisplaySymC_Entry          ;0F986H Отображаем очередной символ
    pop  B                          ;0F989H 
    inx  H                          ;0F98AH Переходим к следующему символу
    jmp  DisplayTextHL              ;0F98BH 

CalcControlSum:
    lxi  B, 0000H                   ;0F98EH Обнуляем BC
CalcSumLoop:
    mov  A, C                       ;0F991H 
    add  M                          ;0F992H 
    mov  C, A                       ;0F993H 
    push PSW                        ;0F994H Сохраняем флаги
    call CheckBlockEnd              ;0F995H 
    jz   Ret_Pop_PSW                ;0F998H 
    pop  psw                        ;0F99BH Восстанавливаем флаги
    mov  A, B                       ;0F99CH 
    adc  M                          ;0F99DH 
    mov  B, A                       ;0F99EH 
    inx  H                          ;0F99FH 
    jmp  CalcSumLoop                ;0F9A0H 

DisplayAddr:
    call DisplayNewLine             ;0F9A3H 
    call DisplaySpace               ;0F9A6H 
DisplayHL:
    mov  A, H                       ;0F9A9H 
    call DisplayHexA                ;0F9AAH Отображаем адрес (H)
    mov  A, L                       ;0F9ADH 
    call DisplayHexA                ;0F9AEH Отображаем адрес (L)
DisplaySpace:
    mvi  A, 20H                     ;0F9B1H ' '
    jmp  DispSymA                   ;0F9B3H 

CheckBlockEnd:
    mov  A, H                       ;0F9B6H ----------------------------------------
    cmp  D                          ;0F9B7H Проверяем на конец блока
    rnz                             ;0F9B8H в HL - начало блока
    mov  A, L                       ;0F9B9H в DE - конец блока
    cmp  E                          ;0F9BAH ----------------------------------------
    ret                             ;0F9BBH 

GetPosCursor:
;------------------------------------------
; Запрос положения курсора
;  вх:  нет
;  вых: H  = номер строки  Y (0—18Н)
;       L  = номер позиции X (0—3FH)
;------------------------------------------
    lhld X_POS_ADDR                 ;0F9BCH
    mov  A, L                       ;0F9BFH 0F3D4H -> L (X)
    rrc                             ;0F9C0H 0F3D5H -> H (Y)
    rrc                             ;0F9C1H L делим на 4 
    mov  L, A                       ;0F9C2H 
    ret                             ;0F9C3H 

SetPosCursor:
;------------------------------------------
; Установить положение курсора
;  вх:  H  = номер строки  Y (0—18Н)
;       L  = номер позиции X (0—3FH)
;  вых: нет
;------------------------------------------
    mov  A, L                       ;0F9C4H
    rlc                             ;0F9C5H L умножаем на 4 
    rlc                             ;0F9C6H L -> 0F3D4H (X)
    mov  L, A                       ;0F9C7H H -> 0F3D5H (Y)
    shld X_POS_ADDR                 ;0F9C8H 
    ret                             ;0F9CBH 

SaveRamAddr:
    shld USER_MAX_RAM_ADDR          ;0F9CCH 
LoadRamAddr:
    lhld USER_MAX_RAM_ADDR          ;0F9CFH 
    ret                             ;0F9D2H 

LoadCodePage:
    lxi  H, CodePageTable           ;0F9D3H Адрес начала знакогенератора в ПЗУ (0FE48H - 0FFFFH)
    lxi  D, 0F000H                  ;0F9D6H Адрес знакогенератора в ОЗУ (0F000H - 0F2FFH)
LoadCodePage_NextSymbol:
    mvi  C, 07H                     ;0F9D9H Знакогенератор содержит символы 5х7 точек
    xra  A                          ;0F9DBH символы распаковываются в матрицу 8х8
    stax D                          ;0F9DCH первая строка всегда = 0 (пустая)
    inx  D                          ;0F9DDH далее 7 строк символа в формате | XXX | XXXXX |
LoadCodePage_Extract:
    mov  A, M                       ;0F9DEH где старшие 3 бита кол-во строк + 1, т.е. значение 0 = 1 строка
    rlc                             ;0F9DFH младшие 5 бит, строка символа.
    rlc                             ;0F9E0H Значение 0С00H -> 11000000, где кол-во строк = 7, строка = 0 -> символ пробела
    rlc                             ;0F9E1H Значения 84H, 00H, 04H распаковывается в '!'
    ani  07H                        ;0F9E2H 00000000 - всегда пусто
    mov  B, A                       ;0F9E4H 00000100 - 84H => 5 раз 00100
LoadCodePage_ExtractLine:
    mov  A, M                       ;0F9E5H 00000100 - 84H => 5 раз 00100
    ani  1FH                        ;0F9E6H 00000100 - 84H => 5 раз 00100
    stax D                          ;0F9E8H 00000100 - 84H => 5 раз 00100
    inx  D                          ;0F9E9H 00000100 - 84H => 5 раз 00100
    dcr  C                          ;0F9EAH 00000000 - 00H
    dcr  B                          ;0F9EBH 00000100 - 04H => 1 раз 00100
    jp   LoadCodePage_ExtractLine   ;0F9ECH 
    inx  H                          ;0F9EFH Увеличиваем HL
    mov  A, H                       ;0F9F0H проверяем на выход за предел границу адреса
    ana  A                          ;0F9F1H т.е. как перескочим с 0FFFFH на 0000H
    rz                              ;0F9F2H завершаем работу
    mov  A, C                       ;0F9F3H 
    ana  A                          ;0F9F4H 
    jnz  LoadCodePage_Extract       ;0F9F5H 
    jmp  LoadCodePage_NextSymbol    ;0F9F8H 

LoadByteDisplayPage:
    sta  0F900H                     ;0F9FBH 
    mov  C, M                       ;0F9FEH 
SetZeroDisplayPage:
    xra  A                          ;0F9FFH 
    sta  0F900H                     ;0FA00H 
    ret                             ;0FA03H 

SaveByteDisplayPage:
    sta  0F900H                     ;0FA04H 
    mov  M, C                       ;0FA07H 
    jmp  SetZeroDisplayPage         ;0FA08H 

LoadByteA_WithoutSync:
    mvi  A, 08H                     ;0FA0BH 
LoadByteA:
    push B                          ;0FA0DH 
    push D                          ;0FA0EH 
    push H                          ;0FA0FH 
    mvi  C, 00H                     ;0FA10H 
    mov  D, A                       ;0FA12H 
    lda  0F402H                     ;0FA13H 
    rrc                             ;0FA16H 
    rrc                             ;0FA17H 
    rrc                             ;0FA18H 
    rrc                             ;0FA19H 
    ani  01H                        ;0FA1AH 
    mov  E, A                       ;0FA1CH 
    mov  A, C                       ;0FA1DH 
    ani  7FH                        ;0FA1EH 
    rlc                             ;0FA20H 
    mov  C, A                       ;0FA21H 
    mvi  B, 00H                     ;0FA22H 
    dcr  B                          ;0FA24H 
    jnz  0FA2CH                     ;0FA25H 
Load_Error:
    lhld RESTART_ADDR               ;0FA28H 
    pchl                            ;0FA2BH 
    lda  0F402H                     ;0FA2CH 
    rrc                             ;0FA2FH 
    rrc                             ;0FA30H 
    rrc                             ;0FA31H 
    rrc                             ;0FA32H 
    ani  01H                        ;0FA33H 
    cmp  E                          ;0FA35H 
    jz   0FA24H                     ;0FA36H 
    ora  C                          ;0FA39H 
    mov  C, A                       ;0FA3AH 
    call Pause_Load                 ;0FA3BH 
    lda  0F402H                     ;0FA3EH 
    rrc                             ;0FA41H 
    rrc                             ;0FA42H 
    rrc                             ;0FA43H 
    rrc                             ;0FA44H 
    ani  01H                        ;0FA45H 
    mov  E, A                       ;0FA47H 
    mov  A, D                       ;0FA48H 
    ora  A                          ;0FA49H 
    jp   0FA66H                     ;0FA4AH 
    mov  A, C                       ;0FA4DH 
    cpi  0E6H                       ;0FA4EH 
    jnz  0FA5AH                     ;0FA50H 
    xra  A                          ;0FA53H 
    sta  LOADBYTE_ADDR              ;0FA54H 
    jmp  0FA64H                     ;0FA57H 
    cpi  19H                        ;0FA5AH 
    jnz  0FA1DH                     ;0FA5CH 
    mvi  A, 0FFH                    ;0FA5FH 
    sta  LOADBYTE_ADDR              ;0FA61H 
    mvi  D, 09H                     ;0FA64H 
    dcr  D                          ;0FA66H 
    jnz  0FA1DH                     ;0FA67H 
    lda  LOADBYTE_ADDR              ;0FA6AH 
    xra  C                          ;0FA6DH 
Ret_Pop_HDB:
    pop  H                          ;0FA6EH 
    pop D                           ;0FA6FH 
    pop  B                          ;0FA70H 
    ret                             ;0FA71H 

SaveFile_HL:
    mov  C, H                       ;0FA72H 
    call SaveByteC                  ;0FA73H 
    mov  C, L                       ;0FA76H 
SaveByteC:
    push PSW                        ;0FA77H Запись байта, каждый бит кодируется двумя сигналами 0 = 10, 1 = 01
    push D                          ;0FA78H        Пример записи 00H
    push B                          ;0FA79H  _   _   _   _   _   _   _   _   
    mvi  D, 08H                     ;0FA7AH | |_| |_| |_| |_| |_| |_| |_| |_|
SaveByteC_Loop:
    mov  A, C                       ;0FA7CH  1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
    rlc                             ;0FA7DH |___|___|___|___|___|___|___|___|
    mov  C, A                       ;0FA7EH   0   0   0   0   0   0   0   0  
    mvi  A, 01H                     ;0FA7FH |_______________|_______________|
    xra  C                          ;0FA81H         0               0        
    sta  0F402H                     ;0FA82H 
    call Pause_Save                 ;0FA85H        Пример записи 0AAH
    xra  A                          ;0FA88H    ___     ___     ___     ___   
    xra  C                          ;0FA89H |_|   |___|   |___|   |___|   |_|
    sta  0F402H                     ;0FA8AH  0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 
    call Pause_Save                 ;0FA8DH |___|___|___|___|___|___|___|___|
    dcr  D                          ;0FA90H   1   0   1   0   1   0   1   0  
    jnz  SaveByteC_Loop             ;0FA91H |_______________|_______________|
    pop  B                          ;0FA94H         A               A        
    pop D                           ;0FA95H 
Ret_Pop_PSW:
    pop  psw                        ;0FA96H 
    ret                             ;0FA97H 

Pause_Save:
    lda  PAUSE_SAVE_ADDR            ;0FA98H Загружаем значение паузы для записи на магнитную ленту
    jmp  Pause_Loop                 ;0FA9BH 

Pause_Load:
    lda  PAUSE_LOAD_ADDR            ;0FA9EH Загружаем значение паузы для чтения с магнитной ленты

Pause_Loop:
    dcr  A                          ;0FAA1H 
    jnz  Pause_Loop                 ;0FAA2H 
    ret                             ;0FAA5H 

DisplayNextAddr:
    inx  H                          ;0FAA6H 
EditMemory:
    call DisplayAddr                ;0FAA7H 
    call DisplayHexM                ;0FAAAH 
    call DisplaySpace               ;0FAADH 
    call Handle_Loop_Start          ;0FAB0H 
    lxi  D, Cmd_Buffer_Start        ;0FAB3H 
    ldax D                          ;0FAB6H 
    cpi  0DH                        ;0FAB7H 
    jz   DisplayNextAddr            ;0FAB9H 
    push H                          ;0FABCH 
    call Handle_ParseParam          ;0FABDH 
    xchg                            ;0FAC0H 
    pop  H                          ;0FAC1H 
    mov  M, E                       ;0FAC2H 
    jmp  DisplayNextAddr            ;0FAC3H 

DumpMemory:
    mov  B, E                       ;0FAC6H 
DumpMemory_NextLine:
    call DisplayAddr                ;0FAC7H 
DumpMemory_NextByte:
    call DisplaySpace               ;0FACAH 
    mov  A, B                       ;0FACDH 
    ana  A                          ;0FACEH 
    jz   DumpMemory_HexA_M          ;0FACFH 
    call LoadByteDisplayPage        ;0FAD2H 
    mov  A, C                       ;0FAD5H 
    jmp  DumpMemory_HexA            ;0FAD6H 

DumpMemory_HexA_M:
    mov  A, M                       ;0FAD9H 
DumpMemory_HexA:
    call DisplayHexA                ;0FADAH 
    inx  H                          ;0FADDH 
    mov  A, L                       ;0FADEH 
    ani  0FH                        ;0FADFH 
    jnz  DumpMemory_NextByte        ;0FAE1H 
    mov  A, L                       ;0FAE4H 
    ana  A                          ;0FAE5H 
    jnz  DumpMemory_NextLine        ;0FAE6H 
    call Handle_Loop_Start          ;0FAE9H 
    jmp  DumpMemory_NextLine        ;0FAECH 

LoadFile:
    mvi  A, 0FFH                    ;0FAEFH Ввод байта с магнитофона (вх: A = 0FFH - с поиском синхробайта)
    call LoadFile_HL_sync           ;0FAF1H Загружаем адрес начала блока
    xchg                            ;0FAF4H 
    call LoadFile_HL                ;0FAF5H Загружаем адрес конца блока
    xchg                            ;0FAF8H HL - адрес начала блока, DE - адрес конца блока
    push H                          ;0FAF9H 
LoadFile_Loop:
    call LoadByteA_WithoutSync      ;0FAFAH 
    mov  M, A                       ;0FAFDH 
    call CheckBlockEnd              ;0FAFEH 
    inx  H                          ;0FB01H 
    jnz  LoadFile_Loop              ;0FB02H 
    mvi  A, 0FFH                    ;0FB05H Ввод байта с магнитофона (вх: A = 0FFH - с поиском синхробайта)
    call LoadFile_HL_sync           ;0FB07H Загружаем контрольную сумму
    mov  B, H                       ;0FB0AH 
    mov  C, L                       ;0FB0BH 
    pop  H                          ;0FB0CH HL - адрес начала блока, DE - адрес конца блока, BC - контрольная сумма
    call DisplayHL                  ;0FB0DH 
    xchg                            ;0FB10H 
    call DisplayHL                  ;0FB11H 
    xchg                            ;0FB14H 
    push B                          ;0FB15H Помещаем в стек контрольную сумму
    call CalcControlSum             ;0FB16H 
    pop D                           ;0FB19H Извлекаем из стека контрольную сумму
    mov  H, B                       ;0FB1AH 
    mov  L, C                       ;0FB1BH 
    call DisplayHL                  ;0FB1CH 
    call CheckBlockEnd              ;0FB1FH Проверяем на совпадение загруженную и посчитанную контрольную сумму
    rz                              ;0FB22H Выходим если контрольная сумма совпала
    jmp  Load_Error                 ;0FB23H 

LoadFile_HL:
    mvi  A, 08H                     ;0FB26H 
LoadFile_HL_sync:
    call LoadByteA                  ;0FB28H 
    mov  H, A                       ;0FB2BH 
    call LoadByteA_WithoutSync      ;0FB2CH 
    mov  L, A                       ;0FB2FH 
    ret                             ;0FB30H 

SaveFile:
    push H                          ;0FB31H Запись файла на магнитную ленту (вх: HL - нач. адрес массива, DE - конечный адрес)
    call CalcControlSum             ;0FB32H Вычисляем контрольную сумму записываемого блока
    pop  H                          ;0FB35H 
    push B                          ;0FB36H Помещаем в стек контрольную сумму
    push H                          ;0FB37H 
    lxi  B, 0000H                   ;0FB38H Запись заголовка: 0 записываем 255 раз
SaveFile_Header:
    call SaveByteC                  ;0FB3BH 
    dcr  B                          ;0FB3EH 
    jnz  SaveFile_Header            ;0FB3FH 
    mvi  C, 0E6H                    ;0FB42H Маркер начала данных
    call SaveByteC                  ;0FB44H Записываем маркер
    call SaveFile_HL                ;0FB47H Записываем адрес начала блока
    xchg                            ;0FB4AH 
    call SaveFile_HL                ;0FB4BH Записываем адрес конца блока
    xchg                            ;0FB4EH 
    pop  H                          ;0FB4FH 
SaveFile_Loop:
    mov  C, M                       ;0FB50H 
    call SaveByteC                  ;0FB51H 
    call CheckBlockEnd              ;0FB54H 
    inx  H                          ;0FB57H 
    jnz  SaveFile_Loop              ;0FB58H 
    lxi  H, 0000H                   ;0FB5BH 
    call SaveFile_HL                ;0FB5EH После данных записываем 2 байта нулей
    mvi  C, 0E6H                    ;0FB61H Маркер конца данных
    call SaveByteC                  ;0FB63H Записываем маркер
    pop  H                          ;0FB66H Извлекаем из стека контрольную сумму
    call SaveFile_HL                ;0FB67H Записываем контрольную сумму записываемого блока
    jmp  DisplayHL                  ;0FB6AH 

SetColorMode:
    mov  C, L                       ;0FB6DH 
    mvi  A, 06H                     ;0FB6EH 
    sta  0F800H                     ;0FB70H 
    mvi  A, 01H                     ;0FB73H 
    sta  0F900H                     ;0FB75H 
    lxi  H, INVERSE_DISP_ADDR       ;0FB78H 
    mov  D, M                       ;0FB7BH 
    mov  M, C                       ;0FB7CH 
    call ClearScreen                ;0FB7DH 
    mov  M, D                       ;0FB80H 
    xra  A                          ;0FB81H 
    sta  0F900H                     ;0FB82H 
    ret                             ;0FB85H 

GetKeyStateA:
    xra  A                          ;0FB86H Опрос состояния клавиатуры (вых: A = 00H - не нажата, A = 0FFH - нажата)
    sta  0F400H                     ;0FB87H 
    lda  0F401H                     ;0FB8AH 
    xri 0FFH                        ;0FB8DH 
    rz                              ;0FB8FH 
    mvi  A, 0FFH                    ;0FB90H 
    ret                             ;0FB92H 

CMD_ROM_BOOT:
    lxi  D, 0B800H                  ;0FB93H --------------------------------------------
    mov  H, E                       ;0FB96H --------------------------------------------
    mov  L, E                       ;0FB97H --------------------------------------------
    mvi  A, 90H                     ;0FB98H --------------------------------------------
    sta  0F503H                     ;0FB9AH Загружаем ROM диск 
ROM_LoopLoad:
    shld 0F501H                     ;0FB9DH в ОЗУ по адресу 0B800H до 0BFFFH
    lda  0F500H                     ;0FBA0H т.е. до начала видеопамяти 0C000H.
    stax D                          ;0FBA3H В конце загруженного блока
    inx  D                          ;0FBA4H в последних 3-х байтах (начиная с 0BFFDH)
    inx  H                          ;0FBA5H должна быть команда jmp на начало программы
    mov  A, H                       ;0FBA6H --------------------------------------------
    cpi  08H                        ;0FBA7H --------------------------------------------
    jnz  ROM_LoopLoad               ;0FBA9H --------------------------------------------
    jmp  Run_0BFFDH                 ;0FBACH --------------------------------------------

InputKeyA:
    push B                          ;0FBAFH 
    push D                          ;0FBB0H 
    push H                          ;0FBB1H 
    call InputKeyCodeA              ;0FBB2H A =0FFH (не нажата) =0FEH (РУС/ЛАТ) =код клавиши
    cpi  0FFH                       ;0FBB5H 
    jnz  InputKeyA_WaitStart        ;0FBB7H 
    sta  KEY_CODE                   ;0FBBAH Сохраняем код нажатой клавиши
InputKeyA_WaitStart:
    mvi  D, 00H                     ;0FBBDH 
InputKeyA_WaitLoop:
    inx  D                          ;0FBBFH 
    dcr  E                          ;0FBC0H 
    inr  E                          ;0FBC1H 
    cz   _BlinkCurret_              ;0FBC2H 
    call InputKeyCodeA              ;0FBC5H A =0FFH (не нажата) =0FEH (РУС/ЛАТ) =код клавиши
    inr  A                          ;0FBC8H 
    jz   InputKeyA_WaitLoop         ;0FBC9H 
    push PSW                        ;0FBCCH 
    mov  A, D                       ;0FBCDH 
    rrc                             ;0FBCEH 
    cnc  _BlinkCurret_              ;0FBCFH 
    pop  psw                        ;0FBD2H 
    dcr  A                          ;0FBD3H 
    jp   0FBEDH                     ;0FBD4H 
    lxi  H, KEY_LED                 ;0FBD7H 
    mov  A, M                       ;0FBDAH 
    cma                             ;0FBDBH 
    mov  M, A                       ;0FBDCH 
    sta  0F402H                     ;0FBDDH 
    call InputKeyCodeA              ;0FBE0H A =0FFH (не нажата) =0FEH (РУС/ЛАТ) =код клавиши
    inr  A                          ;0FBE3H 
    jnz  0FBE0H                     ;0FBE4H 
    call _BlinkCurret_              ;0FBE7H 
    jmp  InputKeyA_WaitStart        ;0FBEAH 
    mov  E, A                       ;0FBEDH 
    mvi  D, 14H                     ;0FBEEH 
    lxi  H, KEY_CODE                ;0FBF0H 
    cmp  M                          ;0FBF3H 
    jz   0FC02H                     ;0FBF4H 
    dcr  D                          ;0FBF7H 
    jz   0FC02H                     ;0FBF8H 
    call InputKeyCodeA              ;0FBFBH A =0FFH (не нажата) =0FEH (РУС/ЛАТ) =код клавиши
    cmp  E                          ;0FBFEH 
    jz   0FBF7H                     ;0FBFFH 
    call Sound                      ;0FC02H 
    mov  M, E                       ;0FC05H 
    call _BlinkCurret_              ;0FC06H 
    mov  A, E                       ;0FC09H 
    jmp  Ret_Pop_HDB                ;0FC0AH 

InputKeyCodeA:
    push B                          ;0FC0DH 
    push D                          ;0FC0EH 
    push H                          ;0FC0FH 
    lxi  H, Ret_Pop_HDB             ;0FC10H Адрес кода для восстановления регистров (pop H; pop D; pop B; ret)
    push H                          ;0FC13H Помещаем адрес в стек, имитируя вызов call, для того чтоб выйти из функции просто по команде RET
    mvi  B, 00H                     ;0FC14H Вычислаемый код из матрицы клавиш
    mvi  D, 09H                     ;0FC16H Счетчик цикла опроса линий - 8 раз, от 9 до 1
    mvi  C, 0FEH                    ;0FC18H Опрашаваемая линия, уровень = 0 опрашиваемая линия
InputKeyCodeA_Loop:
    mov  A, C                       ;0FC1AH 
    sta  0F400H                     ;0FC1BH Записываем в порт опрашиваемую линию
    rlc                             ;0FC1EH Получаем следующую опрашиваемую линию
    mov  C, A                       ;0FC1FH 
    lda  0F401H                     ;0FC20H Считываем код клавиши на опрашиваемой линии, уровень 0 на линии = клавиша нажата
    cpi  0FFH                       ;0FC23H 
    jz   InputKeyCodeA_NextRow      ;0FC25H 
    mov  E, A                       ;0FC28H 
    call InputKey_Delay             ;0FC29H Задержка для исключения дребезга
    lda  0F401H                     ;0FC2CH Считываем код клавиши на опрашиваемой линии, уровень 0 на линии = клавиша нажата
    cmp  E                          ;0FC2FH Проверяем что код нажатой клавиши не изменился
    jz   InputKeyCodeA_Calc         ;0FC30H Клавиша нажата, переходми к вычислению колонки клавиши в матрице клавиатуры
InputKeyCodeA_NextRow:
    mov  A, B                       ;0FC33H 
    adi  08H                        ;0FC34H 
    mov  B, A                       ;0FC36H 
    dcr  D                          ;0FC37H 
    jnz  InputKeyCodeA_Loop         ;0FC38H 
    lda  0F402H                     ;0FC3BH Читаем из порта C, маски для кнопок: [РУС/ЛАТ] = 0x80, [УС] = 0x40, [СС] = 0x20
    ani  80H                        ;0FC3EH Проверяем нажатие [РУС/ЛАТ] = 0x80
    mvi  A, 0FEH                    ;0FC40H =0FEH (РУС/ЛАТ)
    rz                              ;0FC42H 
    inr  A                          ;0FC43H =0FFH (не нажата)
    ret                             ;0FC44H 
InputKeyCodeA_NextCol:
    inr  B                          ;0FC45H 
InputKeyCodeA_Calc:
    rar                             ;0FC46H 
    jc   InputKeyCodeA_NextCol      ;0FC47H 0=признак нажатой клавиши, цикл пока не найдем 0
    mov  A, B                       ;0FC4AH Запоминаем вычисленный код клавиши
    ani  3FH                        ;0FC4BH 
    cpi  10H                        ;0FC4DH Проверяем не явлается ли клавиша управляющей, код меньше 10H
    jc   GetKeyCodeMap              ;0FC4FH 
    cpi  3FH                        ;0FC52H Сравниваем с кодом клавиши ЗБ (Del)
    mov  B, A                       ;0FC54H 
    mvi  A, 20H                     ;0FC55H 
    rz                              ;0FC57H Если была нажата ЗБ, возвращаем код пробела
    lda  0F402H                     ;0FC58H Читаем из порта C, маски для кнопок: [РУС/ЛАТ] = 0x80, [УС] = 0x40, [СС] = 0x20
    mov  C, A                       ;0FC5BH 
    ani  40H                        ;0FC5CH Проверяем на нажатие [УС] = 0x40
    jnz  0FC65H                     ;0FC5EH 
    mov  A, B                       ;0FC61H 
    ani  1FH                        ;0FC62H 
    ret                             ;0FC64H 
    lda  KEY_LED                    ;0FC65H 
    ana  A                          ;0FC68H 
    jnz  0FCA6H                     ;0FC69H 
    mov  A, C                       ;0FC6CH 
    ani  20H                        ;0FC6DH Проверяем на нажатие [СС] = 0x20
    mov  A, B                       ;0FC6FH 
    jz   0FC80H                     ;0FC70H 
    cpi  1CH                        ;0FC73H 
    jm   0FC85H                     ;0FC75H 
    cpi  20H                        ;0FC78H 
    jm   0FC87H                     ;0FC7AH 
    jmp  0FC85H                     ;0FC7DH 
    cpi  1CH                        ;0FC80H 
    jc   0FC87H                     ;0FC82H 
    adi  10H                        ;0FC85H 
    adi  10H                        ;0FC87H 
    pop  H                          ;0FC89H 
    jmp  Ret_Pop_HDB                ;0FC8AH 

GetKeyCodeMap:
    lxi  H, KeyCodeMap              ;0FC8DH 
    mov  C, A                       ;0FC90H 
    mvi  B, 00H                     ;0FC91H 
    dad  B                          ;0FC93H 
    mov  A, M                       ;0FC94H 
    ret                             ;0FC95H 

KeyCodeMap:
    DB    12                        ;0FC96H Код клавиши \ (Home)
    DB    31                        ;0FC97H Код клавиши СТР (Очистить экран)
    DB    27                        ;0FC98H Код клавиши АР2 (Esc)
    DB    0                         ;0FC99H Код клавиши F1
    DB    1                         ;0FC9AH Код клавиши F2
    DB    2                         ;0FC9BH Код клавиши F3
    DB    3                         ;0FC9CH Код клавиши F4
    DB    4                         ;0FC9DH Код клавиши F5
    DB    9                         ;0FC9EH Код клавиши TAB
    DB    10                        ;0FC9FH Код клавиши ПС
    DB    13                        ;0FCA0H Код клавиши ВК
    DB    127                       ;0FCA1H Код клавиши ЗБ
    DB    8                         ;0FCA2H Код клавиши ←
    DB    25                        ;0FCA3H Код клавиши ↑
    DB    24                        ;0FCA4H Код клавиши →
    DB    26                        ;0FCA5H Код клавиши ↓
    mov  A, C                       ;0FCA6H 
    ani  20H                        ;0FCA7H 
    mov  A, B                       ;0FCA9H 
    jz   0FC80H                     ;0FCAAH 
    cpi  1CH                        ;0FCADH 
    jm   0FC85H                     ;0FCAFH 
    cpi  20H                        ;0FCB2H 
    jm   0FC87H                     ;0FCB4H 
    adi  40H                        ;0FCB7H 
    ret                             ;0FCB9H 

InputKey_Delay:
    lxi  H, 0B00H                   ;0FCBAH 
InputKey_DelayLoop:
    dcx  H                          ;0FCBDH 
    mov  A, H                       ;0FCBEH 
    ora  L                          ;0FCBFH 
    jnz  InputKey_DelayLoop         ;0FCC0H 
    ret                             ;0FCC3H 

DisplayNewLine:
    mvi  A, 0DH                     ;0FCC4H 
    call DispSymA                   ;0FCC6H 
    mvi  A, 0AH                     ;0FCC9H 
DispSymA:
    push B                          ;0FCCBH 
    mov  C, A                       ;0FCCCH 
    jmp  DispSymC_0                 ;0FCCDH 

DispSymC:
    push B                          ;0FCD0H 
DispSymC_0:
    push D                          ;0FCD1H 
    push H                          ;0FCD2H 
    push PSW                        ;0FCD3H 
    mov  A, C                       ;0FCD4H 
    cpi  7FH                        ;0FCD5H ----------------------------------------------------------
    jnz  DispSymC_Not_7FH           ;0FCD7H При выводе символа 7F переключаем признак инверсии вывода
    lda  INVERSE_DISP_ADDR          ;0FCDAH Загружаем признак инверсии вывода
    cma                             ;0FCDDH инвертируем (переключаем)
    sta  INVERSE_DISP_ADDR          ;0FCDEH Сохраняем признак инверсии вывода
    jmp  DispSymC_Ret               ;0FCE1H ----------------------------------------------------------
DispSymC_Not_7FH:
    mvi  H, 20H                     ;0FCE4H ----------------------------------------------------------
    sub  H                          ;0FCE6H Проверяем, что код символа меньше пробела (такие не выводим)
    jc   DispSymC_Hidden            ;0FCE7H ----------------------------------------------------------
    mov  L, A                       ;0FCEAH В A индекс символа, для ' ' = 0
    dad  H                          ;0FCEBH H = 20H, L = A (индекс символа)
    dad  H                          ;0FCECH так как символ состоит из 8 строк, сдвигаем HL влево (т.е. умножаем на 8)
    dad  H                          ;0FCEDH H - обнулится, таким образом HL содержит смещение символа от начала знакогенератора
    xchg                            ;0FCEEH сохраняем смещение в DE
    lhld CODEPAGE_ADDR              ;0FCEFH 
    dad  D                          ;0FCF2H 
    xchg                            ;0FCF3H 
    call 0FDC4H                     ;0FCF4H 
    xchg                            ;0FCF7H 
    mvi  A, 16H                     ;0FCF8H 
    push PSW                        ;0FCFAH 
    push H                          ;0FCFBH 
    lda  INVERSE_DISP_ADDR          ;0FCFCH 
    xra  M                          ;0FCFFH 
    ani  3FH                        ;0FD00H 
    mov  L, A                       ;0FD02H 
    lda  0F3DDH                     ;0FD03H 
    dcr  A                          ;0FD06H 
    mvi  H, 00H                     ;0FD07H 
    dad  H                          ;0FD09H 
    dad  H                          ;0FD0AH 
    inr  A                          ;0FD0BH 
    jnz  0FD09H                     ;0FD0CH 
    xchg                            ;0FD0FH 
    mov  A, B                       ;0FD10H 
    xra  M                          ;0FD11H 
    ana  M                          ;0FD12H 
    ora  D                          ;0FD13H 
    mov  M, A                       ;0FD14H 
    inr  H                          ;0FD15H 
    mov  A, C                       ;0FD16H 
    xra  M                          ;0FD17H 
    ana  M                          ;0FD18H 
    ora  E                          ;0FD19H 
    mov  M, A                       ;0FD1AH 
    dcr  H                          ;0FD1BH 
    inr  L                          ;0FD1CH 
    xchg                            ;0FD1DH 
    pop  H                          ;0FD1EH 
    inx  H                          ;0FD1FH 
    pop  psw                        ;0FD20H 
    sui  03H                        ;0FD21H 
    jp   0FCFAH                     ;0FD23H 
    lxi  H, 0FD85H                  ;0FD26H 
    cpi  0F8H                       ;0FD29H 
    jnz  0FCFAH                     ;0FD2BH 
DispSymC_Hidden:
    lhld X_POS_ADDR                 ;0FD2EH 
    call 0FD84H                     ;0FD31H 
    dad  B                          ;0FD34H 
    mov  A, H                       ;0FD35H 
    cpi  19H                        ;0FD36H 
    jc   0FD7DH                     ;0FD38H 
    jnz  0FD7BH                     ;0FD3BH 
    inr  D                          ;0FD3EH 
    mov  H, D                       ;0FD3FH 
    jz   0FD7DH                     ;0FD40H 
    push H                          ;0FD43H 
    lxi  H, 0000H                   ;0FD44H 
    dad  SP                         ;0FD47H 
    shld 0F3DFH                     ;0FD48H 
    lda  SCREEN_SIZE_HI             ;0FD4BH 
    mov  B, A                       ;0FD4EH 
    lda  SCREEN_ADDR_HI             ;0FD4FH 
    mov  H, A                       ;0FD52H 
    mvi  L, 0AH                     ;0FD53H 
    sphl                            ;0FD55H 
    mvi  L, 00H                     ;0FD56H 
    mvi  C, 3CH                     ;0FD58H 
    pop D                           ;0FD5AH 
    mov  M, E                       ;0FD5BH 
    inr  L                          ;0FD5CH 
    mov  M, D                       ;0FD5DH 
    inr  L                          ;0FD5EH 
    pop D                           ;0FD5FH 
    mov  M, E                       ;0FD60H 
    inr  L                          ;0FD61H 
    mov  M, D                       ;0FD62H 
    inr  L                          ;0FD63H 
    dcr  C                          ;0FD64H 
    jnz  0FD5AH                     ;0FD65H 
    lda  INVERSE_DISP_ADDR          ;0FD68H 
    inx  SP                         ;0FD6BH 
    mov  M, A                       ;0FD6CH 
    inr  L                          ;0FD6DH 
    jnz  0FD6BH                     ;0FD6EH 
    inr  H                          ;0FD71H 
    dcr  B                          ;0FD72H 
    jnz  0FD58H                     ;0FD73H 
    lhld 0F3DFH                     ;0FD76H 
    sphl                            ;0FD79H 
    pop  H                          ;0FD7AH 
    mvi  H, 18H                     ;0FD7BH 
    shld X_POS_ADDR                 ;0FD7DH 
DispSymC_Ret:
    pop  psw                        ;0FD80H 
    jmp  Ret_Pop_HDB                ;0FD81H 
    lxi  B, 0100H                   ;0FD84H 
    mov  D, C                       ;0FD87H 
    inr  A                          ;0FD88H 
    cz   ClearScreen                ;0FD89H 
    jz   Ret_Zero_HB                ;0FD8CH 
    cpi  0EBH                       ;0FD8FH 
    rz                              ;0FD91H 
    dcr  D                          ;0FD92H 
    adi  05H                        ;0FD93H 
    rz                              ;0FD95H 
    inr  D                          ;0FD96H 
    mvi  B, 0FFH                    ;0FD97H 
    inr  A                          ;0FD99H 
    rz                              ;0FD9AH 
    mvi  C, 0FCH                    ;0FD9BH 
    cpi  0EFH                       ;0FD9DH 
    rz                              ;0FD9FH 
    lxi  B, 0000H                   ;0FDA0H 
    cpi  0F0H                       ;0FDA3H 
    jnz  0FDAFH                     ;0FDA5H 
    mov  A, L                       ;0FDA8H 
    ani  0E0H                       ;0FDA9H 
    adi  20H                        ;0FDABH 
    mov  L, A                       ;0FDADH 
    ret                             ;0FDAEH 
    mvi  C, 04H                     ;0FDAFH 
    inr  A                          ;0FDB1H 
    rz                              ;0FDB2H 
    cpi  0EFH                       ;0FDB3H 
    jz   Sound                      ;0FDB5H 
    adi  0BH                        ;0FDB8H 
    jz   0FDC0H                     ;0FDBAH 
    inr  A                          ;0FDBDH 
    rnz                             ;0FDBEH 
Ret_Zero_HB:
    mov  H, D                       ;0FDBFH 
    mov  L, D                       ;0FDC0H 
    mov  B, D                       ;0FDC1H 
    mov  C, D                       ;0FDC2H 
    ret                             ;0FDC3H 
    lhld X_POS_ADDR                 ;0FDC4H Загружаеем координаты курсора L = X, H = Y
    mov  A, L                       ;0FDC7H 
    rrc                             ;0FDC8H 
    mov  L, A                       ;0FDC9H 
    rrc                             ;0FDCAH 
    add  L                          ;0FDCBH 
    mov  B, A                       ;0FDCCH 
    mov  L, H                       ;0FDCDH 
    lda  SCREEN_ADDR_HI             ;0FDCEH 
    mov  H, A                       ;0FDD1H 
    mov  A, B                       ;0FDD2H 
    dcr  H                          ;0FDD3H 
    inr  H                          ;0FDD4H 
    sui  04H                        ;0FDD5H 
    jnc  0FDD4H                     ;0FDD7H 
    sta  0F3DDH                     ;0FDDAH 
    push H                          ;0FDDDH 
    lxi  H, 00FCH                   ;0FDDEH 
    dad  H                          ;0FDE1H 
    dad  H                          ;0FDE2H 
    inr  A                          ;0FDE3H 
    jnz  0FDE1H                     ;0FDE4H 
    mov  B, H                       ;0FDE7H 
    mov  C, L                       ;0FDE8H 
    pop  H                          ;0FDE9H 
    mov  A, L                       ;0FDEAH 
    rlc                             ;0FDEBH 
    rlc                             ;0FDECH 
    rlc                             ;0FDEDH 
    add  L                          ;0FDEEH 
    add  L                          ;0FDEFH 
    mov  L, A                       ;0FDF0H 
    ret                             ;0FDF1H 

_BlinkCurret_:
    call 0FDC4H                     ;0FDF2H  Похоже на курсор (_)
    adi  09H                        ;0FDF5H 
    mov  L, A                       ;0FDF7H 
    mov  A, B                       ;0FDF8H 
    xra  M                          ;0FDF9H 
    mov  M, A                       ;0FDFAH 
    inr  H                          ;0FDFBH 
    mov  A, C                       ;0FDFCH 
    xra  M                          ;0FDFDH 
    mov  M, A                       ;0FDFEH 
    ret                             ;0FDFFH 

ClearScreen:
    push PSW                        ;0FE00H 
    push H                          ;0FE01H 
    lda  SCREEN_ADDR_HI             ;0FE02H Старший байт начала экранной области, начало 0C0H -> 0C000H
    mov  H, A                       ;0FE05H 
    lda  SCREEN_SIZE_HI             ;0FE06H Старший байт размера экранной области, размер 30H ->  3000H
    add  H                          ;0FE09H 
    mov  C, A                       ;0FE0AH Запоминаем старший байт конца экранной области, до этого адреса заполняем
    mvi  L, 00H                     ;0FE0BH В HL начало экранной области 0C000H
    lda  INVERSE_DISP_ADDR          ;0FE0DH 
    mov  B, A                       ;0FE10H 
ClearScreen_Loop:
    mov  M, B                       ;0FE11H 
    inx  H                          ;0FE12H 
    mov  A, H                       ;0FE13H 
    cmp  C                          ;0FE14H Проверяем на выход за пределы экранной области
    jnz  ClearScreen_Loop           ;0FE15H 
    pop  H                          ;0FE18H 
    pop  psw                        ;0FE19H 
    ret                             ;0FE1AH 

Sound:
    lxi  B, 4014H                   ;0FE1BH 
Sound_Loop:
    mov  A, B                       ;0FE1EH 
Sound_EI:
    ei                              ;0FE1FH 
    dcr  A                          ;0FE20H 
    jnz  Sound_EI                   ;0FE21H 
    mov  A, B                       ;0FE24H 
Sound_DI:
    di                              ;0FE25H 
    dcr  A                          ;0FE26H 
    jnz  Sound_DI                   ;0FE27H 
    dcr  C                          ;0FE2AH 
    jnz  Sound_Loop                 ;0FE2BH 
    mov  B, C                       ;0FE2EH 
    ret                             ;0FE2FH 

Label_Version:
    DB    31,' orion-128.2', 0      ;0FE30H 31 (1FH) -> Спец. символ для очистки экрана
Label_Prompt:
    DB    13,10,10,' =>',7, 0       ;0FE3EH 
Unknown_Data:
    DB    53H                       ;0FE46H 
    DB    56H                       ;0FE47H 

CodePageTable:
;0FE48H-0FE48H ' '
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
    DB    11000000B                 ;0FE48H
;0FE49H-0FE4BH '!'
;░░░░░░░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░█░░
;░░░░░░░░
;░░░░░█░░
    DB    10000100B                 ;0FE49H
    DB    00000000B                 ;0FE4AH 
    DB    00000100B                 ;0FE4BH 
;0FE4CH-0FE4DH '"'
;░░░░░░░░
;░░░░█░█░
;░░░░█░█░
;░░░░█░█░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
;░░░░░░░░
    DB    01001010B                 ;0FE4CH
    DB    01100000B                 ;0FE4DH 
;0FE4EH-0FE52H '#'
;░░░░░░░░
;░░░░█░█░
;░░░░█░█░
;░░░█████
;░░░░█░█░
;░░░█████
;░░░░█░█░
;░░░░█░█░
    DB    00101010B                 ;0FE4EH
    DB    00011111B                 ;0FE4FH 
    DB    00001010B                 ;0FE50H 
    DB    00011111B                 ;0FE51H 
    DB    00101010B                 ;0FE52H 
;0FE53H-0FE59H '$'
;░░░░░░░░
;░░░░░█░░
;░░░░████
;░░░█░█░░
;░░░░███░
;░░░░░█░█
;░░░████░
;░░░░░█░░
    DB    00000100B                 ;0FE53H
    DB    00001111B                 ;0FE54H 
    DB    00010100B                 ;0FE55H 
    DB    00001110B                 ;0FE56H 
    DB    00000101B                 ;0FE57H 
    DB    00011110B                 ;0FE58H 
    DB    00000100B                 ;0FE59H 
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
;0FF50H-0FF52H 'Y'
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
;0FFFFH '█'
;░░░░░░░░
;░░░█████
;░░░█████
;░░░█████
;░░░█████
;░░░█████
;░░░█████
;░░░█████
    DB    11011111B                 ;0FFFFH
