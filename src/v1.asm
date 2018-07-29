include "8085.inc"

ORG 0H

    mvi C, 1FH
	call 0F809H
	lxi H, 0D06FH
	lxi B, META
MET1:
	call MET5
MET2:
	call 0F81BH
	cpi 0FFH
	jz MET2
	cpi 19H
	jz MET3
	cpi 1AH
	jz MET4
	cpi 03H
	jz MET2
	jmp 0F86CH
MET3:
	dcx H
	jmp MET1
MET4:
	inx H
	jmp MET1
MET5:
	mov D, B                        ;lxi D, META
	mov E, C                        ;lxi D, META
	push B
	mvi c, 00H
MET6:
	mvi B, 00H
	push H
MET7:
    ldax D
	mov M, A
	inr B
	mov A, B
	cpi 12H
	jz MET8
	inx H
	inx D
	jmp MET7
MET8:
    inr C
	mov A, C
	cpi 02H
	jz MET9
	pop H
	inr H
	inx D
	jmp MET6
MET9:
    pop H
	dcr H
	pop B
	ret                             ;jmp MET2
META:	
    DB    000H, 003H, 003H
    DB    001H, 001H, 001H
    DB    011H, 019H, 01FH
    DB    01FH, 019H, 011H
    DB    001H, 001H, 001H
    DB    003H, 003H, 000H
    DB    000H, 000H, 080H
    DB    080H, 0C0H, 0E0H
    DB    0F0H, 0F0H, 0FFH
    DB    0FFH, 0F0H, 0F0H
    DB    0E0H, 0C0H, 080H
    DB    080H, 000H, 000H
