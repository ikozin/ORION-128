;http://www.danbigras.ru/Orion/DspMem/VideoMem.html

include "8085.inc"

PORT_MODE	EQU	0F800H
PORT_PAGE	EQU	0F900H
PORT_VIEW	EQU	0FA00H

MODE0		EQU 0	; 2 color
MODE1		EQU 1	; 2 color
MODE2		EQU 2	; off
MODE3		EQU 3	; off
MODE4		EQU 4	; 4 color
MODE5		EQU 5	; 4 color
MODE6		EQU 6	; 8 color
MODE7		EQU 7	; 8 color

PAGE0		EQU 0
PAGE1		EQU 1


VIEW0		EQU	0	; 0В000Н-0BFFFH
VIEW1		EQU	1	; 7000Н-7FFFH
VIEW2		EQU	2	; З000Н-3FFFH


ORG 0F800H

	jmp  Start
Start:
	xra  A
    sta  PORT_PAGE

    mvi  A, MODE2
    sta  PORT_MODE


	lxi  B, 0F33H
	lxi  D, M0_V0
	jmp  FillMemory

M0_V0:
    mvi  A, MODE0
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M1_V0
    jmp  Pause

M1_V0:
    mvi  A, MODE1
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M0_V1
    jmp  Pause

M0_V1:
    mvi  A, MODE0
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M1_V1
    jmp  Pause

M1_V1:
    mvi  A, MODE1
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M0_V2
    jmp  Pause

M0_V2:
    mvi  A, MODE0
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, M1_V2
    jmp  Pause

M1_V2:
    mvi  A, MODE1
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, M4_V0
    jmp  Pause

M4_V0:
    mvi  A, MODE4
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M5_V0
    jmp  Pause
M5_V0:
    mvi  A, MODE5
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M4_V1
    jmp  Pause

M4_V1:
    mvi  A, MODE4
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M5_V1
    jmp  Pause
M5_V1:
    mvi  A, MODE5
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M4_V2
    jmp  Pause

M4_V2:
    mvi  A, MODE4
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, M5_V2
    jmp  Pause

M5_V2:
    mvi  A, MODE5
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, M3
    jmp  Pause

M3:	
    mvi  A, MODE3
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW
	
	lxi  H, 0H
	mvi  A, 1
    sta  0F900H
r0:
	mvi	 B, 64
	mvi  C, 0	
	lxi  D, r1
	jmp  FillScreenBlock
r1:
	xchg
	mvi	 B, 64
	mvi  C, 0FFH	
	lxi  D, r2
	jmp  FillScreenBlock
r2:
	xchg
	mvi	 B, 64
	mvi  C, 0	
	lxi  D, r3
	jmp  FillScreenBlock
r3:
	xchg
	mvi	 B, 64
	mvi  C, 0FFH	
	lxi  D, r4
	jmp  FillScreenBlock
r4:
	xchg
	mov  A, H
    cpi  0F0H
    jnz  r0

	lxi  H, 0H
	xra  A
    sta  0F900H
r5:
	mvi	 B, 128
	mvi  C, 0	
	lxi  D, r6
	jmp  FillScreenBlock
r6:
	xchg
	mvi	 B, 128
	mvi  C, 0FFH	
	lxi  D, r7
	jmp  FillScreenBlock
r7:
	xchg
	mov  A, H
    cpi  0F0H
    jnz  r5

M_0:
    mvi  A, MODE0
    sta  PORT_MODE
    lxi  D, M_1
    jmp  Pause
M_1:
    mvi  A, MODE1
    sta  PORT_MODE
    lxi  D, M_4
    jmp  Pause
M_4:
    mvi  A, MODE4
    sta  PORT_MODE
    lxi  D, M_5
    jmp  Pause
M_5:
    mvi  A, MODE5
    sta  PORT_MODE
    lxi  D, M6_Init_00
    jmp  Pause

M6_Init_00:
    mvi  A, MODE2
    sta  PORT_MODE

	lxi  D, M6_V0_00
	jmp  FillScreenRow00

M6_V0_00:
    mvi  A, MODE6
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M6_V1_00
    jmp  Pause

M6_V1_00:
    mvi  A, MODE6
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M6_V2_00
    jmp  Pause

M6_V2_00:
    mvi  A, MODE6
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, M7_V0_00
    jmp  Pause

M7_V0_00:
    mvi  A, MODE7
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M7_V1_00
    jmp  Pause

M7_V1_00:
    mvi  A, MODE7
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M7_V2_00
    jmp  Pause

M7_V2_00:
    mvi  A, MODE7
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, M6_Init_FF
    jmp  Pause

M6_Init_FF:
    mvi  A, MODE2
    sta  PORT_MODE

	lxi  D, M6_V0_FF
	jmp  FillScreenRow00

M6_V0_FF:
    mvi  A, MODE6
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M6_V1_FF
    jmp  Pause

M6_V1_FF:
    mvi  A, MODE6
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M6_V2_FF
    jmp  Pause

M6_V2_FF:
    mvi  A, MODE6
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, M7_V0_FF
    jmp  Pause

M7_V0_FF:
    mvi  A, MODE7
    sta  PORT_MODE
    mvi  A, VIEW0
    sta  PORT_VIEW

    lxi  D, M7_V1_FF
    jmp  Pause

M7_V1_FF:
    mvi  A, MODE7
    sta  PORT_MODE
    mvi  A, VIEW1
    sta  PORT_VIEW

    lxi  D, M7_V2_FF
    jmp  Pause

M7_V2_FF:
    mvi  A, MODE7
    sta  PORT_MODE
    mvi  A, VIEW2
    sta  PORT_VIEW

    lxi  D, Start
    jmp  Pause

	
;------------------------------------------
; Вход B = значение для страницы 0
; Вход C = значение для страницы 1
; Вход DE = адрес возврата
;------------------------------------------ 
FillMemory:
	lxi  H, 0H
FillMemory_0_Loop:
	mov  M, B
    inx  H
    mov  A, H
    cpi  0F0H
    jnz  FillMemory_0_Loop
	mvi  A, 1
    sta  0F900H
    dcx  H			;HL = 0EFFFH
FillMemory_1_Loop:
	mov  M, C
    dcx  H
    mov  A, H
    cpi  0FFH
    jnz  FillMemory_1_Loop
	xra  A
    sta  0F900H
    xchg
    pchl

;------------------------------------------
; Вход B = кол-во записей
; Вход C = значение
; Вход HL = адрес экранной области
; Вход DE = адрес возврата
;------------------------------------------ 
FillScreenBlock:
	mov  A, B
FillScreenBlock_Loop:
	mov  M, C
    inx  H
    dcr  A
    jnz  FillScreenBlock_Loop
    xchg
    pchl


;------------------------------------------
FillScreenRow00:
	lxi  H, 0H
FillScreenRow00_0_Loop:
	mvi  M, 0H
    inx  H
    mov  A, H
    cpi  0F0H
    jnz  FillScreenRow00_0_Loop
	mvi  A, 1
    sta  0F900H
    dcx  H			;HL = 0EFFFH
FillScreenRow00_1_Loop:
	mov  M, L
    dcx  H
    mov  A, H
    cpi  0FFH
    jnz  FillScreenRow00_1_Loop
	xra  A
    sta  0F900H
    xchg
    pchl
;------------------------------------------
FillScreenRowFF:
	lxi  H, 0H
FillScreenRowFF_0_Loop:
	mvi  M, 0FFH
    inx  H
    mov  A, H
    cpi  0F0H
    jnz  FillScreenRowFF_0_Loop
	mvi  A, 1
    sta  0F900H
    dcx  H			;HL = 0EFFFH
FillScreenRowFF_1_Loop:
	mov  M, L
    dcx  H
    mov  A, H
    cpi  0FFH
    jnz  FillScreenRowFF_1_Loop
	xra  A
    sta  0F900H
    xchg
    pchl
	
	
;------------------------------------------
; Вход DE = адрес возврата
;------------------------------------------ 
Pause:
    mvi  B, 02H
    lxi  H, 0000H
Pause_Loop:
    dcx  H
    mov  A, L
    ora  H
    jnz  Pause_Loop
    dcr  B
    jnz  Pause_Loop
    xchg
    pchl

macro ROM_END
	fillSize = 2048 - ($ - $$)
	repeat fillSize
		DB 0FFH
	end repeat	
end macro

	ROM_END




