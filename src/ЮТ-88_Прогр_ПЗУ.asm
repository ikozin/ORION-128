include "8085.inc"

MonitorF				EQU 0F800H
MonitorF_GetKeyCode		EQU 0F803H
MonitorF_LoadByteTape	EQU 0F806H
MonitorF_PrintChar		EQU 0F809H
MonitorF_SaveByteTape	EQU 0F80CH
MonitorF_GetKeyState	EQU 0F812H
MonitorF_PrintHex		EQU 0F815H
MonitorF_PrintStr		EQU 0F818H

ORG 0100H

    mvi A, 90H                      ;0100H 
    out 0FBH                        ;0102H 
    mvi A, 0C0H                     ;0104H 
    out 0FAH                        ;0106H 

Begin:
    lxi H, Msg_Welcom               ;0108H 
    call PrintString                ;010BH 
    call GetKey                     ;010EH 
    call PrintNewLine               ;0111H 
    lxi H, 056AH                    ;0114H 
    shld 0568H                      ;0117H 
    call GetKeyFilter               ;011AH 
    cpi 00H                         ;011DH 
    jz Begin                        ;011FH 
    mov A, C                        ;0122H 
    cpi 52H                         ;0123H 'R'
    jz Start_Ram                    ;0125H 
    cpi 57H                         ;0128H 'W'
    jz Start_Rom                    ;012AH 
    cpi 43H                         ;012DH 'C'
    jz 0000H                        ;012FH 
    cpi 50H                         ;0132H 'P'
    jz 0000H                        ;0134H 
    cpi 45H                         ;0137H 'E'
    jz MonitorF                     ;0139H 
    lxi H, Msg_Error                ;013CH 
    call PrintString                ;013FH 
    call ErrorDelay                 ;0142H 
    jmp Begin                       ;0145H 

Start_Ram:
    mvi A, 90H                      ;0148H 
    out 0FBH                        ;014AH 
    lxi H, Msg_Addr_RAM             ;014CH 
    call PrintString                ;014FH 
    call GetKey                     ;0152H 
    lxi H, 056AH                    ;0155H 
    shld 0568H                      ;0158H 
    call 030DH                      ;015BH 
    dcr A                           ;015EH 
    jnz 014CH                       ;015FH 
    push H                          ;0162H 
    lxi D, 0000H                    ;0163H 
    lxi B, 0800H                    ;0166H 
ReadRom_Next:
    call ReadByteRom                ;0169H 
    mov M, A                        ;016CH 
    inx D                           ;016DH 
    inx H                           ;016EH 
    dcx B                           ;016FH 
    mov A, B                        ;0170H 
    ora C                           ;0171H 
    jnz ReadRom_Next                ;0172H 
    pop D                           ;0175H 
    dcx H                           ;0176H 
    xchg                            ;0177H 
    call ControlSum                 ;0178H 
    push B                          ;017BH 
    call PrintNewLine               ;017CH 
    pop H                           ;017FH 
    call PrintHexWord               ;0180H 
    call PrintNewLine               ;0183H 
    call MonitorF_GetKeyCode        ;0186H 
    jmp Begin                       ;0189H 

Start_Rom:
    lxi H, Msg_Addr_ROM             ;018CH 
    call PrintString                ;018FH 
    call GetKey                     ;0192H 
    lxi H, 056AH                    ;0195H 
    shld 0568H                      ;0198H 
    call 030DH                      ;019BH 
    dcr A                           ;019EH 
    jnz Start_Rom                   ;019FH 
    push H                          ;01A2H 
    mvi A, 80H                      ;01A3H 
    out 0FBH                        ;01A5H 
    mvi A, 0DH                      ;01A7H 
    out 0FBH                        ;01A9H 
    lxi H, Msg_TurnOn_26V           ;01ABH 
    call PrintString                ;01AEH 
    call MonitorF_GetKeyCode        ;01B1H 
    call PrintNewLine               ;01B4H 
    lxi D, 0000H                    ;01B7H 
    lxi B, 0800H                    ;01BAH 
    pop H                           ;01BDH 
WriteLoop:
    mov A, M                        ;01BEH 
    out 0F8H                        ;01BFH 
    mov A, E                        ;01C1H 
    out 0F9H                        ;01C2H 
    mov A, D                        ;01C4H 
    xri 40H                         ;01C5H 
    out 0FAH                        ;01C7H 
    mvi A, 0FH                      ;01C9H 
    out 0FBH                        ;01CBH 
    call WriteDelay                 ;01CDH 
    mvi A, 0EH                      ;01D0H 
    out 0FBH                        ;01D2H 
    mvi A, 90H                      ;01D4H 
    out 0FBH                        ;01D6H 
    mov A, E                        ;01D8H 
    out 0F9H                        ;01D9H 
    mov A, D                        ;01DBH 
    out 0FAH                        ;01DCH 
    in 0F8H                         ;01DEH 
    cmp M                           ;01E0H 
    jz WriteLoop_NoError            ;01E1H 
    push B                          ;01E4H 
    mvi C, 23H                      ;01E5H 
    call MonitorF_PrintChar         ;01E7H 
    call PrintNewLine               ;01EAH 
    pop B                           ;01EDH 
    mvi A, 80H                      ;01EEH 
    out 0FBH                        ;01F0H 
    mvi A, 0DH                      ;01F2H 
    out 0FBH                        ;01F4H 
    jmp WriteLoop                   ;01F6H 
WriteLoop_NoError:
    inx H                           ;01F9H 
    inx D                           ;01FAH 
    dcx B                           ;01FBH 
    mvi A, 80H                      ;01FCH 
    out 0FBH                        ;01FEH 
    mvi A, 0DH                      ;0200H 
    out 0FBH                        ;0202H 
    mov A, B                        ;0204H 
    ora C                           ;0205H 
    jnz WriteLoop                   ;0206H 
    lxi H, 03C0H                    ;0209H 
    call PrintString                ;020CH 
    call MonitorF_GetKeyCode        ;020FH 
    jmp Begin                       ;0212H 

ReadByteRom:
    mov A, E                        ;0215H 
    out 0F9H                        ;0216H 
    mov A, D                        ;0218H 
    out 0FAH                        ;0219H 
    in 0F8H                         ;021BH 
    push PSW                        ;021DH 
    mvi A, 0DH                      ;021EH 
    out 0FBH                        ;0220H 
    pop psw                         ;0222H 
    ret                             ;0223H 

ErrorDelay:
    push B                          ;0224H 
    lxi B, 0FFFFH                   ;0225H 
ErrorDelay_Next:
    dcx B                           ;0228H 
    mov A, B                        ;0229H 
    ora C                           ;022AH 
    jnz ErrorDelay_Next             ;022BH 
    pop B                           ;022EH 
    ret                             ;022FH 

WriteDelay:
    push B                          ;0230H 
    lxi B, 0A000H                   ;0231H 
WriteDelay_Next:
    dcx B                           ;0234H 
    mov A, B                        ;0235H 
    ora C                           ;0236H 
    jnz WriteDelay_Next             ;0237H 
    pop B                           ;023AH 
    ret                             ;023BH 

GetKey:
    push B                          ;023CH 
    push H                          ;023DH 
    mvi B, 00H                      ;023EH 
    lxi H, 056AH                    ;0240H 
GetKey_Loop:
    call MonitorF_GetKeyCode        ;0243H 
    cpi 08H                         ;0246H 
    jnz 0256H                       ;0248H 
    mov A, B                        ;024BH 
    ora A                           ;024CH 
    jz GetKey_Loop                  ;024DH 
    call 0281H                      ;0250H 
    jmp GetKey_Loop                 ;0253H 
    cpi 18H                         ;0256H 
    jnz 0266H                       ;0258H 
    mov A, B                        ;025BH 
    ora A                           ;025CH 
    jz GetKey_Loop                  ;025DH 
    call 0281H                      ;0260H 
    jmp 025BH                       ;0263H 
    mov M, A                        ;0266H 
    mov C, A                        ;0267H 
    call MonitorF_PrintChar         ;0268H 
    cpi 0DH                         ;026BH 
    jz 027DH                        ;026DH 
    inx H                           ;0270H 
    inr B                           ;0271H 
    mov A, B                        ;0272H 
    cpi 32H                         ;0273H 
    jnz GetKey_Loop                 ;0275H 
    mvi A, 0FFH                     ;0278H 
    jmp 027EH                       ;027AH 
    xra A                           ;027DH 
    pop H                           ;027EH 
    pop B                           ;027FH 
    ret                             ;0280H 
    dcr B                           ;0281H 
    dcx H                           ;0282H 
    mvi C, 08H                      ;0283H 
    call MonitorF_PrintChar         ;0285H 
    mvi C, 20H                      ;0288H 
    call MonitorF_PrintChar         ;028AH 
    mvi C, 08H                      ;028DH 
    call MonitorF_PrintChar         ;028FH 
    ret                             ;0292H 

GetKeyFilter:
    push H                          ;0293H 
    lhld 0568H                      ;0294H 
    mov A, M                        ;0297H 
    mov C, A                        ;0298H 
    cpi 20H                         ;0299H 
    jnz 02A2H                       ;029BH 
    xra A                           ;029EH 
    jmp 02AEH                       ;029FH 
    cpi 0DH                         ;02A2H 
    jnz 02ACH                       ;02A4H 
    mvi A, 01H                      ;02A7H 
    jmp 02AEH                       ;02A9H 
    mvi A, 0FFH                     ;02ACH 
    inx H                           ;02AEH 
    shld 0568H                      ;02AFH 
    pop H                           ;02B2H 
    ret                             ;02B3H 
    push D                          ;02B4H 
    lxi D, 0000H                    ;02B5H 
    call GetKeyFilter               ;02B8H 
    ora A                           ;02BBH 
    jm 02CFH                        ;02BCH 
    push PSW                        ;02BFH 
    mov A, D                        ;02C0H 
    ora A                           ;02C1H 
    jnz 02CAH                       ;02C2H 
    pop psw                         ;02C5H 
    mvi A, 0FFH                     ;02C6H 
    pop D                           ;02C8H 
    ret                             ;02C9H 
    pop psw                         ;02CAH 
    mov C, E                        ;02CBH 
    jmp 02C8H                       ;02CCH 
    inr D                           ;02CFH 
    mov A, D                        ;02D0H 
    cpi 03H                         ;02D1H 
    jnc 02C6H                       ;02D3H 
    mov A, E                        ;02D6H 
    rlc                             ;02D7H 
    rlc                             ;02D8H 
    rlc                             ;02D9H 
    rlc                             ;02DAH 
    ani 0F0H                        ;02DBH 
    mov E, A                        ;02DDH 
    call 02EBH                      ;02DEH 
    ora A                           ;02E1H 
    jnz 02C6H                       ;02E2H 
    mov A, C                        ;02E5H 
    ora E                           ;02E6H 
    mov E, A                        ;02E7H 
    jmp 02B8H                       ;02E8H 
    mov A, C                        ;02EBH 
    cpi 30H                         ;02ECH 
    jc 030AH                        ;02EEH 
    cpi 47H                         ;02F1H 
    jnc 030AH                       ;02F3H 
    cpi 41H                         ;02F6H 
    jc 0300H                        ;02F8H 
    sui 37H                         ;02FBH 
    jmp 0307H                       ;02FDH 
    cpi 3AH                         ;0300H 
    jnc 030AH                       ;0302H 
    ani 0FH                         ;0305H 
    mov C, A                        ;0307H 
    xra A                           ;0308H 
    ret                             ;0309H 
    mvi A, 0FFH                     ;030AH 
    ret                             ;030CH 
    push B                          ;030DH 
    push D                          ;030EH 
    lxi H, 0000H                    ;030FH 
    mvi B, 00H                      ;0312H 
    call GetKeyFilter               ;0314H 
    ora A                           ;0317H 
    jm 032BH                        ;0318H 
    push PSW                        ;031BH 
    mov A, B                        ;031CH 
    ora A                           ;031DH 
    jnz 0327H                       ;031EH 
    pop psw                         ;0321H 
    mvi A, 0FFH                     ;0322H 
    pop D                           ;0324H 
    pop B                           ;0325H 
    ret                             ;0326H 
    pop psw                         ;0327H 
    jmp 0324H                       ;0328H 
    inr B                           ;032BH 
    mov A, B                        ;032CH 
    cpi 05H                         ;032DH 
    jnc 0322H                       ;032FH 
    mvi D, 04H                      ;0332H 
    xra A                           ;0334H 
    mov A, L                        ;0335H 
    ral                             ;0336H 
    mov L, A                        ;0337H 
    mov A, H                        ;0338H 
    ral                             ;0339H 
    mov H, A                        ;033AH 
    dcr D                           ;033BH 
    jnz 0334H                       ;033CH 
    call 02EBH                      ;033FH 
    ora A                           ;0342H 
    jnz 0322H                       ;0343H 
    mov A, C                        ;0346H 
    ora L                           ;0347H 
    mov L, A                        ;0348H 
    jmp 0314H                       ;0349H 

PrintHexByte:
    push B                          ;034CH 
    mov B, A                        ;034DH 
    ani 0F0H                        ;034EH 
    rrc                             ;0350H 
    rrc                             ;0351H 
    rrc                             ;0352H 
    rrc                             ;0353H 
    call PrintHex                   ;0354H 
    mov A, B                        ;0357H 
    ani 0FH                         ;0358H 
    call PrintHex                   ;035AH 
    pop B                           ;035DH 
    ret                             ;035EH 

PrintHex:
    cpi 0AH                         ;035FH 
    jc 0366H                        ;0361H 
    adi 07H                         ;0364H 
    adi 30H                         ;0366H 
    mov C, A                        ;0368H 
    call MonitorF_PrintChar         ;0369H 
    ret                             ;036CH 

PrintHexWord:
    push PSW                        ;036DH 
    mov A, H                        ;036EH 
    call PrintHexByte               ;036FH 
    mov A, L                        ;0372H 
    call PrintHexByte               ;0373H 
    pop psw                         ;0376H 
    ret                             ;0377H 

PrintNewLine:
    push B                          ;0378H 
    mvi C, 0DH                      ;0379H 
    call MonitorF_PrintChar         ;037BH 
    mvi C, 0AH                      ;037EH 
    call MonitorF_PrintChar         ;0380H 
    pop B                           ;0383H 
    ret                             ;0384H 

PrintSpace:
    push B                          ;0385H 
    mvi C, 20H                      ;0386H 
    call MonitorF_PrintChar         ;0388H 
    pop B                           ;038BH 
    ret                             ;038CH 

PrintString:
    push PSW                        ;038DH 
    push B                          ;038EH 
PrintString_Next:
    mov A, M                        ;038FH 
    ora A                           ;0390H 
    jz PrintString_End              ;0391H 
    mov C, A                        ;0394H 
    call MonitorF_PrintChar         ;0395H 
    inx H                           ;0398H 
    jmp PrintString_Next            ;0399H 
PrintString_End:
    pop B                           ;039CH 
    pop psw                         ;039DH 
    ret                             ;039EH 

ControlSum:
    push PSW                        ;039FH 
    push H                          ;03A0H 
    lxi B, 0000H                    ;03A1H 
    mov A, C                        ;03A4H 
    add M                           ;03A5H 
    mov C, A                        ;03A6H 
    mov A, B                        ;03A7H 
    aci 00H                         ;03A8H 
    mov B, A                        ;03AAH 
    inx H                           ;03ABH 
    mov A, H                        ;03ACH 
    cmp D                           ;03ADH 
    jnz 03A4H                       ;03AEH 
    mov A, L                        ;03B1H 
    cmp E                           ;03B2H 
    jnz 03A4H                       ;03B3H 
    mov A, C                        ;03B6H 
    add M                           ;03B7H 
    mov C, A                        ;03B8H 
    mov A, B                        ;03B9H 
    aci 00H                         ;03BAH 
    mov B, A                        ;03BCH 
    pop H                           ;03BDH 
    pop psw                         ;03BEH 
    ret                             ;03BFH 
    nop                             ;03C0H 
    nop                             ;03C1H 
    nop                             ;03C2H 
    nop                             ;03C3H 
    nop                             ;03C4H 
    nop                             ;03C5H 
    nop                             ;03C6H 
    nop                             ;03C7H 
    nop                             ;03C8H 
    nop                             ;03C9H 
    nop                             ;03CAH 
    nop                             ;03CBH 
    nop                             ;03CCH 
    nop                             ;03CDH 
    nop                             ;03CEH 
    nop                             ;03CFH 
    nop                             ;03D0H 
    nop                             ;03D1H 
    nop                             ;03D2H 
    nop                             ;03D3H 
    nop                             ;03D4H 
    nop                             ;03D5H 
Msg_Welcom:
    DB    13,10,'     programmator  pzu 573rf2-rf5     ',13,10,13,10,'     pere~enx komand   :    ',13,10,' R - ~tenie ',13,10,' W - zapisx ',13,10,' E - wyhod w monitor   ',13,10,13,10,' komanda >', 0;03D6H 
Msg_Error:
    DB    13,10,13,10,'   *  o { i b k a  *  ',13,10, 0;0462H 
Msg_TurnOn_26V:
    DB    13,10,13,10,' wkl`~ite naprqvenie +26 wolxt ', 0;047FH 
Msg_TurnOff_26V:
    DB    13,10,' wykl`~ite naprqvenie +26 wolxt ', 0;04A3H 
Msg_Addr_RAM:
    DB    13,10,'        revim ~teniq       ',13,10,13,10,' zadajte na~alxnyj adres ozu  ', 0;04C6H 
Msg_Addr_ROM:
    DB    13,10,'        revim zapisi       ',13,10,13,10,' zadajte na~alxnyj adres ozu  ', 0;0506H 
    nop                             ;0546H 
    nop                             ;0547H 
    nop                             ;0548H 
    nop                             ;0549H 
    nop                             ;054AH 
    nop                             ;054BH 
    nop                             ;054CH 
    nop                             ;054DH 
    nop                             ;054EH 
    nop                             ;054FH 
