include "8085.inc"

MODE0		EQU 0
MODE1		EQU 1
MODE2		EQU 2
MODE3		EQU 3
MODE4		EQU 4
MODE5		EQU 5
MODE6		EQU 6
MODE7		EQU 7

PAGE0		EQU 0
PAGE1		EQU 1


ORG 0F800H

	jmp  Start
Start:
	xra  A
    sta  0F800H
    sta  0F900H
    sta  0FA00H

    mvi  A, MODE2
    sta  0F800H


	lxi  B, 0F33H
	lxi  D, M0
	jmp  FillScreen

M0:
    mvi  A, MODE0
    sta  0F800H
    lxi  D, M1
    jmp  Pause

M1:
    mvi  A, MODE1
    sta  0F800H
    lxi  D, M4
    jmp  Pause
M4:
    mvi  A, MODE4
    sta  0F800H
    lxi  D, M5
    jmp  Pause
M5:
    mvi  A, MODE5
    sta  0F800H
    lxi  D, Part2
    jmp  Pause

Part2:	
    mvi  A, MODE3
    sta  0F800H
	
	lxi  H, 0C000H
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

	lxi  H, 0C000H
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
    sta  0F800H
    lxi  D, M_1
    jmp  Pause
M_1:
    mvi  A, MODE1
    sta  0F800H
    lxi  D, M_4
    jmp  Pause
M_4:
    mvi  A, MODE4
    sta  0F800H
    lxi  D, M_5
    jmp  Pause
M_5:
    mvi  A, MODE5
    sta  0F800H
    lxi  D, Start
    jmp  Pause

	
;------------------------------------------
; Вход B = значение для страницы 0
; Вход C = значение для страницы 1
; Вход DE = адрес возврата
;------------------------------------------ 
FillScreen:
	lxi  H, 0C000H
FillScreen_0_Loop:
	mov  M, B
    inx  H
    mov  A, H
    cpi  0F0H
    jnz  FillScreen_0_Loop
	mvi  A, 1
    sta  0F900H
    dcx  H			;HL = 0EFFFH
FillScreen_1_Loop:
	mov  M, C
    dcx  H
    mov  A, H
    cpi  0BFH
    jnz  FillScreen_1_Loop
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




