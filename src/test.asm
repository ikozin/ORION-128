include "8085.inc"

MODE0		EQU 0
MODE1		EQU 1
;MODE2		EQU 2
;MODE3		EQU 3
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
    lxi  D, M0
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




