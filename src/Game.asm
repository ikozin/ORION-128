include "8085.inc"
include "bru.inc"
include "M1.inc"

BRU_BEGIN

ORG 0H

SCREEN_ADDR		EQU 0C000H
SCREEN_SIZE		EQU 3000H
SCREEN_ROW		EQU 256


StartCode:
	;hlt
	xra  A                           ; Обнуляем A
    sta  0F800H                      ; Порт - Управление цветным режимом, записываем 00H
    sta  0FA00H                      ; Порт - Управление переключением экранов, записываем 00H

	call StartScreen

	lxi  H, 0CA80H
	lxi  D, Starship1
	lxi  B, 0209H
	call DrawSprite

	lxi  H, 0CD80H
	lxi  D, Starship2
	lxi  B, 0209H
	call DrawSprite

	lxi  H, 0D080H
	lxi  D, Starship3
	lxi  B, 0209H
	call DrawSprite
	
	lxi  H, 0D380H
	lxi  D, Starship4
	lxi  B, 030DH
	call DrawSprite
	
	lxi  H, 0D780H
	lxi  D, Starship5
	lxi  B, 020CH
	call DrawSprite
	
	lxi  H, 0DA80H
	lxi  D, Starship6
	lxi  B, 020CH
	call DrawSprite
	
	lxi  H, 0DD80H
	lxi  D, Starship7
	lxi  B, 020CH
	call DrawSprite

	call WaitAnyKey

	call GameOver
	jmp  0F800H


ClearScreen:
	push H
	push B
	lxi  H, SCREEN_ADDR
	lxi  B, SCREEN_SIZE
ClearScreenLoop:
	xra  A
	mov  M, A
	inx  H
	dcx  B
	mov  A, B
	ora  C
	jnz  ClearScreenLoop
	pop  B
	pop  H
	ret


StartScreen:
	call ClearScreen
	lxi  H, 0A18H
	call ROM_SetPosCursor
	lxi  H, PressAnyKayMessage
	call ROM_DisplayTextHL
	call WaitAnyKey
	call ClearScreen
	ret


GameOver:
	call ClearScreen
	lxi  H, 0A1AH
	call ROM_SetPosCursor
	lxi  H, GameOverMessage
	call ROM_DisplayTextHL
	lxi  H, 0B18H
	call ROM_SetPosCursor
	lxi  H, PressAnyKayMessage
	call ROM_DisplayTextHL
	call WaitAnyKey
	call ClearScreen
	ret


DrawSprite:
	push H
	push D
	push B
DrawSpriteLoopCol:
	push B
DrawSpriteLoopRow:
	ldax D
	mov  M, A
	inx  H
	inx  D
	dcr  C
	jnz  DrawSpriteLoopRow
	pop  B
	inr  H
	mov  A, L
	stc
	sbb  C
	inr  A
	mov  L, A
	dcr  B
	jnz  DrawSpriteLoopCol
	pop  B
	pop  D
	pop  H
	ret

WaitAnyKey:
	lxi	B, 0000H
WaitAnyKeyLoop:
	call ROM_GetKeyStateA
	inx	B
	ora  A
	jz   WaitAnyKeyLoop
	ret


PressAnyKayMessage:

	DB	'PRESS ANY KEY', 0

GameOverMessage:
	DB	'GAME OVER', 0

DisplayStack:
	DW	0
	DW	0
	DW	0
	DW	0
	DW	0
	DW	0
	DW	0
	DW	0


Starship1:

DB	00000000B
DB	00000001B
DB	00000011B
DB	00000010B
DB	00101010B
DB	00111110B
DB	00000110B
DB	00000011B
DB	00000000B

DB	00000000B
DB	00000000B
DB	10000000B
DB	10000000B
DB	10101000B
DB	11111000B
DB	11000000B
DB	10000000B
DB	00000000B

Starship2:

DB	00000000B
DB	00000001B
DB	00000001B
DB	00000011B
DB	00001010B
DB	01001110B
DB	01111100B
DB	00000111B
DB	00000000B

DB	00000000B
DB	00000000B
DB	00000000B
DB	10000000B
DB	10100000B
DB	11100100B
DB	01111100B
DB	11000000B
DB	00000000B

Starship3:

DB	00000000B
DB	00000011B
DB	00000001B
DB	00000001B
DB	00000011B
DB	01010100B
DB	01111100B
DB	00000111B
DB	00000000B

DB	00000000B
DB	10000000B
DB	00000000B
DB	00000000B
DB	10000000B
DB	01010100B
DB	01111100B
DB	11000000B
DB	00000000B


Starship4:
DB	00000000B
DB	00000000B
DB	00000000B
DB	00001000B
DB	00001000B
DB	00011111B
DB	00010000B
DB	00011111B
DB	00011000B
DB	00100100B
DB	00000000B
DB	00000000B
DB	00000000B

DB	00001000B
DB	00111110B
DB	11000001B
DB	10001000B
DB	10001000B
DB	10110110B
DB	00100010B
DB	10111110B
DB	10000000B
DB	10000000B
DB	11100011B
DB	00111110B
DB	01000001B

DB	00000000B
DB	00000000B
DB	10000000B
DB	10001000B
DB	10001000B
DB	11111100B
DB	00000100B
DB	11111100B
DB	10001100B
DB	10010010B
DB	10000000B
DB	00000000B
DB	00000000B

Starship5:
;                
;                
;                
;       X        
;      X X       
;    X X X X     
;     XX XX      
;   XX X X XX    
;   X XX XX X    
;      XXX       
;                
;                
DB	00000000B
DB	00000000B
DB	00000000B
DB	00000001B
DB	00000010B
DB	00001010B
DB	00000110B
DB	00011010B
DB	00010110B
DB	00000011B
DB	00000000B
DB	00000000B

DB	00000000B
DB	00000000B
DB	00000000B
DB	00000000B
DB	10000000B
DB	10100000B
DB	11000000B
DB	10110000B
DB	11010000B
DB	10000000B
DB	00000000B
DB	00000000B

Starship6:
;                
;                
;                
;       X        
;      X X       
;    X X X X     
;   X XX XX X    
;  XX XX XX XX   
;    X  X  X     
;      XXX       
;                
;                
DB	00000000B
DB	00000000B
DB	00000000B
DB	00000001B
DB	00000010B
DB	00001010B
DB	00010110B
DB	00110110B
DB	00001001B
DB	00000011B
DB	00000000B
DB	00000000B

DB	00000000B
DB	00000000B
DB	00000000B
DB	00000000B
DB	10000000B
DB	10100000B
DB	11010000B
DB	11011000B
DB	00100000B
DB	10000000B
DB	00000000B
DB	00000000B

Starship7:
;                
;       X        
;      X X       
;      X X       
;     X X X      
;    X  X  X     
;   X X   X X    
;   X X   X X    
;    XX X XX     
;     X X X      
;    X XXX X     
;                

DB	00000000B
DB	00000001B
DB	00000010B
DB	00000010B
DB	00000101B
DB	00001001B
DB	00010100B
DB	00010100B
DB	00001101B
DB	00000101B
DB	00001011B
DB	00000000B

DB	00000000B
DB	00000000B
DB	10000000B
DB	10000000B
DB	01000000B
DB	00100000B
DB	01010000B
DB	01010000B
DB	01100000B
DB	01000000B
DB	10100000B
DB	00000000B








BRU_END
