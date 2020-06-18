include "8085.inc"
include "bru.inc"

BRU_BEGIN

ORG 0H

SCREEN_ADDR		EQU 0C000H
SCREEN_SIZE		EQU 3000H
SCREEN_ROW		EQU 256

StartCode:
	hlt
	xra A                           ;0F845H Обнуляем A
    sta 0F800H                      ;0F846H Порт - Управление цветным режимом, записываем 00H
    sta 0FA00H                      ;0F84CH Порт - Управление переключением экранов, записываем 00H
	;mvi A, 1FH
	;call 0F80FH
	call ClearScreen

	lxi H, 0CA00H
	lxi D, Starship1
	call DrawSprite

	lxi H, 0C110H
	lxi D, Starship2
	call DrawSprite

	lxi H, 0CB40H
	lxi D, Starship3
	call DrawSprite
	
Exit:
	jmp Exit

ClearScreen:
	push H
	push B

	lxi H, SCREEN_ADDR
	lxi B, SCREEN_SIZE

ClearScreenLoop:
	xra A
	mov M, A
	inx H
	dcx B
	mov A, B
	ora C
	jnz ClearScreenLoop

	pop B
	pop H
	ret

DrawSprite:
	push H
	push D
	push B

	mvi B, 02H
DrawSprite2:
	mvi C, 09H
DrawSprite1:
	ldax D
	mov M, A
	inx H
	inx D
	dcr C
	jnz DrawSprite1

	inr H
	mov A, L
	adi 247
	mov L, A
	dcr B
	jnz DrawSprite2
	
	pop B
	pop D
	pop H
	ret

Starship1:

DB	00000000B
DB	00000001B
DB	00101011B
DB	00111110B
DB	00000110B
DB	00000011B
DB	00000001B
DB	00000011B
DB	00000000B

DB	00000000B
DB	00000000B
DB	10101000B
DB	11111000B
DB	11000000B
DB	10000000B
DB	00000000B
DB	10000000B
DB	00000000B

Starship2:

DB	00000000B
DB	00000001B
DB	00000001B
DB	00000011B
DB	00001010B
DB	01001110B
DB	01111101B
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

BRU_END
