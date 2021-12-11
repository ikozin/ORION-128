;http://www.danbigras.ru/Orion/DspMem/VideoMem.html

include "8085.inc"

PORT_MODE	EQU	0F800H
PORT_PAGE	EQU	0F900H
PORT_VIEW	EQU	0FA00H

SCREEN_ADDR		EQU 0C000H
SCREEN_SIZE		EQU 3000H


ORG 0F800H

	jmp  Start
Start:
	xra  A                          ;Обнуляем регистр аккамулятора
	out  0F8H                       ;Записываем 0 в порт 0F800H - системный порт №1 (управление цветным режимом) 
	out  0F9H                       ;Записываем 0 в порт 0F900H - системный порт №2 (управление переключением страниц)
	out  0FAH                       ;Записываем 0 в порт 0FA00H - системный порт №3 (управление переключением экранов)
Beep:
    mvi  C, 0FFH                    ;0F806H 
    mov  A, C                       ;0F808H 
BeepLoop:
    ei                              ;0F809H 
    mov  B, A                       ;0F80AH 
    mov  A, C                       ;0F80BH 
Beep_On:
    dcr  A                          ;0F80CH 
    jnz  Beep_On                    ;0F80DH 
    di                              ;0F810H 
    mvi  A, 90H                     ;0F811H 
Beep_Off:
    dcr  A                          ;0F813H 
    jnz  Beep_Off                   ;0F814H 
    mov  A, B                       ;0F817H 
    dcr  C                          ;0F818H 
    jnz  BeepLoop
	

EmptyScreen:
	lxi  D, 0
	lxi  H, EmptyScreen_Next
	jmp	 FillScreen
EmptyScreen_Next:
	lxi  D, FillScreen_01
	jmp	 Pause

FillScreen_01:
	lxi  D, 0101H
	lxi  H, FillScreen_01_Next
	jmp	 FillScreen
FillScreen_01_Next:
	lxi  D, FillScreen_02
	jmp	 Pause

FillScreen_02:
	lxi  D, 0202H
	lxi  H, FillScreen_02_Next
	jmp	 FillScreen
FillScreen_02_Next:
	lxi  D, FillScreen_04
	jmp	 Pause

FillScreen_04:
	lxi  D, 0404H
	lxi  H, FillScreen_04_Next
	jmp	 FillScreen
FillScreen_04_Next:
	lxi  D, FillScreen_08
	jmp	 Pause

FillScreen_08:
	lxi  D, 0808H
	lxi  H, FillScreen_08_Next
	jmp	 FillScreen
FillScreen_08_Next:
	lxi  D, FillScreen_10
	jmp	 Pause

FillScreen_10:
	lxi  D, 1010H
	lxi  H, FillScreen_10_Next
	jmp	 FillScreen
FillScreen_10_Next:
	lxi  D, FillScreen_20
	jmp	 Pause

FillScreen_20:
	lxi  D, 2020H
	lxi  H, FillScreen_20_Next
	jmp	 FillScreen
FillScreen_20_Next:
	lxi  D, FillScreen_40
	jmp	 Pause

FillScreen_40:
	lxi  D, 4040H
	lxi  H, FillScreen_40_Next
	jmp	 FillScreen
FillScreen_40_Next:
	lxi  D, FillScreen_80
	jmp	 Pause

FillScreen_80:
	lxi  D, 8080H
	lxi  H, FillScreen_80_Next
	jmp	 FillScreen
FillScreen_80_Next:
	lxi  D, Stop
	jmp	 Pause

Stop:
	jmp  Start

;------------------------------------------
; Вход HL = адрес возврата
; Вход DE = значение
;------------------------------------------ 
FillScreen:
	lxi  SP, 0EFFFH
	mvi  C, 24
FillScreenLoop:
	xra  A
FillScreenLoopCol:
	push D
	dcr  A
	ora  A
	jnz  FillScreenLoopCol
	mov  A, C
	dcr  A
	mov  C, A
	ora  A
	jnz  FillScreenLoop
	pchl
;------------------------------------------
; Вход DE = адрес возврата
;------------------------------------------ 
Pause:
    lxi  B, 08H
    lxi  H, 0000H
Pause_Loop:
    dcx  H
    mov  A, L
    ora  H
    jnz  Pause_Loop
    dcx  B
    mov  A, C
    ora  B	
    jnz  Pause_Loop
    xchg
    pchl

;------------------------------------------
; Вход HL = адрес возврата
;------------------------------------------ 

	pchl


macro ROM_END
	fillSize = 2048 - ($ - $$)
	repeat fillSize
		DB 0FFH
	end repeat	
end macro

	ROM_END




