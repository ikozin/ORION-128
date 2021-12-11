include "8085.inc"

ORG 0F800H

    jmp  StartCode                  ;0F800H 
InputKey_Entry:
    jmp  0F3C6H                     ;0F803H 
LoadByte_Entry:
    jmp  0F9D7H                     ;0F806H 
DisplayC_Entry:
    jmp  0FC2EH                     ;0F809H 
SaveByte_Entry:
    jmp  0FA25H                     ;0F80CH 
DisplayA_Entry:
    jmp  0FC34H                     ;0F80FH 
    jmp  0FA78H                     ;0F812H 
DisplayHex_Entry:
    jmp  0F91CH                     ;0F815H 
DisplayText_Entry:
    jmp  0F937H                     ;0F818H 
    jmp  0FAE7H                     ;0F81BH 
    jmp  0F963H                     ;0F81EH 
    jmp  0F3C9H                     ;0F821H 
    jmp  0F990H                     ;0F824H 
    jmp  0F8F5H                     ;0F827H 
    jmp  0F941H                     ;0F82AH 
    jmp  0F8F6H                     ;0F82DH 
    jmp  0F96EH                     ;0F830H 
    jmp  0F96BH                     ;0F833H 
    jmp  0F978H                     ;0F836H 
    jmp  0F972H                     ;0F839H 
    jmp  0F95CH                     ;0F83CH 
    jmp  0F3C3H                     ;0F83FH 
StartCode:
    mov  D, M                       ;0F842H 
    inx  SP                         ;0F843H 
    mvi  L, 31H                     ;0F844H 
    lxi  SP, 0F3C0H                 ;0F846H 
    xra  A                          ;0F849H 
    out  0F8H                       ;0F84AH 
    out  0F9H                       ;0F84CH 
    out  0FAH                       ;0F84EH 
    lxi  H, 0FA41H                  ;0F850H 
    lxi  D, 0FA69H                  ;0F853H 
    lxi  B, 0F3C3H                  ;0F856H 
    mov  A, M                       ;0F859H 
    stax B                          ;0F85AH 
    call 0F956H                     ;0F85BH 
    inx  H                          ;0F85EH 
    inx  B                          ;0F85FH 
    jnz  0F859H                     ;0F860H 
    call 0F8F6H                     ;0F863H 
    lxi  H, 0FA6AH                  ;0F866H 
    call 0F937H                     ;0F869H 
    lxi  SP, 0F3C0H                 ;0F86CH 
    lxi  H, 0F403H                  ;0F86FH 
    mvi  M, 8AH                     ;0F872H 
    dcx  H                          ;0F874H 
    mov  A, M                       ;0F875H 
    ani  60H                        ;0F876H 
    jpo  0F8B6H                     ;0F878H 
    lxi  H, 0B7FFH                  ;0F87BH 
    lxi  D, 07FFH                   ;0F87EH 
    xra  A                          ;0F881H 
    inx  H                          ;0F882H 
    xra  M                          ;0F883H 
    dcx  D                          ;0F884H 
    dcr  D                          ;0F885H 
    inr  D                          ;0F886H 
    jp   0F882H                     ;0F887H 
    cpi  0E6H                       ;0F88AH 
    jz   0BFFDH                     ;0F88CH 
    xchg                            ;0F88FH 
    mvi  A, 90H                     ;0F890H 
    sta  0F503H                     ;0F892H 
    lxi  H, 07FDH                   ;0F895H 
    call 0FE23H                     ;0F898H 
    cpi  0C3H                       ;0F89BH 
    jnz  0F8B6H                     ;0F89DH 
    inx  H                          ;0F8A0H 
    inx  H                          ;0F8A1H 
    call 0FE23H                     ;0F8A2H 
    stax D                          ;0F8A5H 
    dcx  D                          ;0F8A6H 
    dcx  H                          ;0F8A7H 
    mov  A, H                       ;0F8A8H 
    ora  A                          ;0F8A9H 
    jp   0F8A2H                     ;0F8AAH 
    jmp  0BFFDH                     ;0F8ADH 
    lxi  H, 0FB7DH                  ;0F8B0H 
    call 0F937H                     ;0F8B3H 
    lxi  SP, 0F3C0H                 ;0F8B6H 
    lxi  H, 0F8B0H                  ;0F8B9H 
    shld 0F3D8H                     ;0F8BCH 
    lxi  H, 0F8B6H                  ;0F8BFH 
    push H                          ;0F8C2H 
    lxi  H, 0F3E5H                  ;0F8C3H 
    mvi  M, 00H                     ;0F8C6H 
    inx  H                          ;0F8C8H 
    inx  H                          ;0F8C9H 
    mvi  M, 48H                     ;0F8CAH 
    call 0FB88H                     ;0F8CCH 
    lxi  B, 0F301H                  ;0F8CFH 
    inx  D                          ;0F8D2H 
    call 0FBC6H                     ;0F8D3H 
    call 0FBC6H                     ;0F8D6H 
    call 0FBC6H                     ;0F8D9H 
    call 0FBC6H                     ;0F8DCH 
    pop  H                          ;0F8DFH 
    pop  B                          ;0F8E0H 
    pop D                           ;0F8E1H 
    pop  H                          ;0F8E2H 
    lda  0F300H                     ;0F8E3H 
    cpi  49H                        ;0F8E6H 
    jz   0F985H                     ;0F8E8H 
    cpi  47H                        ;0F8EBH 
    jz   0F97FH                     ;0F8EDH 
    push H                          ;0F8F0H 
    lhld 0F3E3H                     ;0F8F1H 
    xthl                            ;0F8F4H 
    ret                             ;0F8F5H 
    lxi  D, CodePageTable           ;0F8F6H 
    lhld 0F3D1H                     ;0F8F9H 
    mvi  C, 07H                     ;0F8FCH 
    mvi  M, 00H                     ;0F8FEH 
    inx  H                          ;0F900H 
    inx  D                          ;0F901H 
    mov  A, D                       ;0F902H 
    ora  E                          ;0F903H 
    rz                              ;0F904H 
    ldax D                          ;0F905H 
    rlc                             ;0F906H 
    rlc                             ;0F907H 
    rlc                             ;0F908H 
    ani  07H                        ;0F909H 
    mov  B, A                       ;0F90BH 
    ldax D                          ;0F90CH 
    ani  1FH                        ;0F90DH 
    mov  M, A                       ;0F90FH 
    inx  H                          ;0F910H 
    dcr  C                          ;0F911H 
    jz   0F8FCH                     ;0F912H 
    dcr  B                          ;0F915H 
    jp   0F90FH                     ;0F916H 
    jmp  0F901H                     ;0F919H 
    push PSW                        ;0F91CH 
    rrc                             ;0F91DH 
    rrc                             ;0F91EH 
    rrc                             ;0F91FH 
    rrc                             ;0F920H 
    call 0F925H                     ;0F921H 
    pop  psw                        ;0F924H 
    ani  0FH                        ;0F925H 
    cpi  0AH                        ;0F927H 
    jm   0F92EH                     ;0F929H 
    adi  07H                        ;0F92CH 
    adi  30H                        ;0F92EH 
    push B                          ;0F930H 
    mov  C, A                       ;0F931H 
    call DisplayC_Entry             ;0F932H 
    pop  B                          ;0F935H 
    ret                             ;0F936H 
    mov  A, M                       ;0F937H 
    ana  A                          ;0F938H 
    rz                              ;0F939H 
    call 0F930H                     ;0F93AH 
    inx  H                          ;0F93DH 
    jmp  0F937H                     ;0F93EH 
    lxi  B, 0000H                   ;0F941H 
    mov  A, C                       ;0F944H 
    add  M                          ;0F945H 
    mov  C, A                       ;0F946H 
    push PSW                        ;0F947H 
    call 0F956H                     ;0F948H 
    jz   0FA3FH                     ;0F94BH 
    pop  psw                        ;0F94EH 
    mov  A, B                       ;0F94FH 
    adc  M                          ;0F950H 
    mov  B, A                       ;0F951H 
    inx  H                          ;0F952H 
    jmp  0F944H                     ;0F953H 
    mov  A, H                       ;0F956H 
    cmp  D                          ;0F957H 
    rnz                             ;0F958H 
    mov  A, L                       ;0F959H 
    cmp  E                          ;0F95AH 
    ret                             ;0F95BH 
    mov  A, L                       ;0F95CH 
    add  A                          ;0F95DH 
    add  A                          ;0F95EH 
    mov  L, A                       ;0F95FH 
    shld 0F3D6H                     ;0F960H 
    lhld 0F3D6H                     ;0F963H 
    mov  A, L                       ;0F966H 
    rrc                             ;0F967H 
    rrc                             ;0F968H 
    mov  L, A                       ;0F969H 
    ret                             ;0F96AH 
    shld 0F3ECH                     ;0F96BH 
    lhld 0F3ECH                     ;0F96EH 
    ret                             ;0F971H 
    out  0F9H                       ;0F972H 
    mov  M, C                       ;0F974H 
    jmp  0F97BH                     ;0F975H 
    out  0F9H                       ;0F978H 
    mov  C, M                       ;0F97AH 
    xra  A                          ;0F97BH 
    out  0F9H                       ;0F97CH 
    ret                             ;0F97EH 
    inr  H                          ;0F97FH 
    jz   0F8B0H                     ;0F980H 
    dcr  H                          ;0F983H 
    pchl                            ;0F984H 
    push H                          ;0F985H 
    call 0F990H                     ;0F986H 
    jnz  0F8B0H                     ;0F989H 
    pop  psw                        ;0F98CH 
    ora  A                          ;0F98DH 
    rnz                             ;0F98EH 
    pchl                            ;0F98FH 
    call 0F9B9H                     ;0F990H 
    shld 0F3EEH                     ;0F993H 
    xchg                            ;0F996H 
    mvi  A, 08H                     ;0F997H 
    call 0F9BBH                     ;0F999H 
    xchg                            ;0F99CH 
    push H                          ;0F99DH 
    push H                          ;0F99EH 
    call 0F9D5H                     ;0F99FH 
    mov  M, A                       ;0F9A2H 
    call 0F956H                     ;0F9A3H 
    inx  H                          ;0F9A6H 
    jnz  0F99FH                     ;0F9A7H 
    call 0F9B9H                     ;0F9AAH 
    xthl                            ;0F9ADH 
    call 0F941H                     ;0F9AEH 
    pop D                           ;0F9B1H 
    mov  H, B                       ;0F9B2H 
    mov  L, C                       ;0F9B3H 
    call 0F956H                     ;0F9B4H 
    pop  H                          ;0F9B7H 
    ret                             ;0F9B8H 
    mvi  A, 0FFH                    ;0F9B9H 
    call 0F9D7H                     ;0F9BBH 
    mov  H, A                       ;0F9BEH 
    call 0F9D5H                     ;0F9BFH 
    mov  L, A                       ;0F9C2H 
    ret                             ;0F9C3H 
    sta  0F402H                     ;0F9C4H 
    lda  0F3DAH                     ;0F9C7H 
    jmp  0F9D0H                     ;0F9CAH 
    lda  0F3DBH                     ;0F9CDH 
    dcr  A                          ;0F9D0H 
    jnz  0F9D0H                     ;0F9D1H 
    ret                             ;0F9D4H 
    mvi  A, 08H                     ;0F9D5H 
    push H                          ;0F9D7H 
    lhld 0F3E8H                     ;0F9D8H 
    xthl                            ;0F9DBH 
    ret                             ;0F9DCH 
    push B                          ;0F9DDH 
    push D                          ;0F9DEH 
    mov  D, A                       ;0F9DFH 
    mvi  C, 00H                     ;0F9E0H 
    call 0FA17H                     ;0F9E2H 
    mov  E, A                       ;0F9E5H 
    mov  B, A                       ;0F9E6H 
    inr  B                          ;0F9E7H 
    jz   0FA21H                     ;0F9E8H 
    call 0FA17H                     ;0F9EBH 
    cmp  E                          ;0F9EEH 
    jz   0F9E7H                     ;0F9EFH 
    rrc                             ;0F9F2H 
    mov  A, C                       ;0F9F3H 
    ral                             ;0F9F4H 
    mov  C, A                       ;0F9F5H 
    call 0F9CDH                     ;0F9F6H 
    xra  A                          ;0F9F9H 
    ora  D                          ;0F9FAH 
    jp   0FA0CH                     ;0F9FBH 
    mov  A, C                       ;0F9FEH 
    xri 0E6H                        ;0F9FFH 
    sta  0F3DCH                     ;0FA01H 
    inr  A                          ;0FA04H 
    cpi  02H                        ;0FA05H 
    jnc  0F9E2H                     ;0FA07H 
    mvi  D, 09H                     ;0FA0AH 
    dcr  D                          ;0FA0CH 
    jnz  0F9E2H                     ;0FA0DH 
    lda  0F3DCH                     ;0FA10H 
    xra  C                          ;0FA13H 
    pop D                           ;0FA14H 
    pop  B                          ;0FA15H 
    ret                             ;0FA16H 
    lda  0F402H                     ;0FA17H 
    rlc                             ;0FA1AH 
    rlc                             ;0FA1BH 
    rlc                             ;0FA1CH 
    rlc                             ;0FA1DH 
    ani  01H                        ;0FA1EH 
    ret                             ;0FA20H 
    lhld 0F3D8H                     ;0FA21H 
    pchl                            ;0FA24H 
    push H                          ;0FA25H 
    lhld 0F3EAH                     ;0FA26H 
    xthl                            ;0FA29H 
    ret                             ;0FA2AH 
    push PSW                        ;0FA2BH 
    push B                          ;0FA2CH 
    mvi  B, 08H                     ;0FA2DH 
    mov  A, C                       ;0FA2FH 
    rlc                             ;0FA30H 
    mov  C, A                       ;0FA31H 
    cma                             ;0FA32H 
    call 0F9C4H                     ;0FA33H 
    mov  A, C                       ;0FA36H 
    call 0F9C4H                     ;0FA37H 
    dcr  B                          ;0FA3AH 
    jnz  0FA2FH                     ;0FA3BH 
    pop  B                          ;0FA3EH 
    pop  psw                        ;0FA3FH 
    ret                             ;0FA40H 
    jmp  0FE33H                     ;0FA41H 
    jmp  0FA84H                     ;0FA44H 
    jmp  0FB94H                     ;0FA47H 
    jmp  0FC3AH                     ;0FA4AH 
    rnz                             ;0FA4DH 
    DB    48                        ;0FA4EH 
    DB    0                         ;0FA4FH 
    DB    240                       ;0FA50H 
    DB    0                         ;0FA51H 
    DB    0                         ;0FA52H 
    DB    25                        ;0FA53H 
    DB    0                         ;0FA54H 
    DB    0                         ;0FA55H 
    DB    108                       ;0FA56H 
    DB    248                       ;0FA57H 
    DB    64                        ;0FA58H 
    DB    96                        ;0FA59H 
    DB    0                         ;0FA5AH 
    DB    0                         ;0FA5BH 
    DB    0                         ;0FA5CH 
    DB    245                       ;0FA5DH 
    DB    248                       ;0FA5EH 
    DB    58                        ;0FA5FH 
    DB    252                       ;0FA60H 
    DB    176                       ;0FA61H 
    DB    248                       ;0FA62H 
    DB    0                         ;0FA63H 
    DB    0                         ;0FA64H 
    DB    72                        ;0FA65H 
    DB    221                       ;0FA66H 
    DB    249                       ;0FA67H 
    DB    43                        ;0FA68H 
    DB    250                       ;0FA69H 
    DB    31                        ;0FA6AH 
    DB    7                         ;0FA6BH 
    DB    66                        ;0FA6CH 
    DB    73                        ;0FA6DH 
    DB    79                        ;0FA6EH 
    DB    83                        ;0FA6FH 
    DB    32                        ;0FA70H 
    DB    86                        ;0FA71H 
    DB    51                        ;0FA72H 
    DB    46                        ;0FA73H 
    DB    49                        ;0FA74H 
    DB    10                        ;0FA75H 
    DB    7                         ;0FA76H 
    DB    0                         ;0FA77H 
    DB    175                       ;0FA78H 
    DB    50                        ;0FA79H 
    DB    0                         ;0FA7AH 
    DB    244                       ;0FA7BH 
    DB    58                        ;0FA7CH 
    DB    1                         ;0FA7DH 
    DB    244                       ;0FA7EH 
    DB    60                        ;0FA7FH 
    DB    200                       ;0FA80H 
    DB    62                        ;0FA81H 
    DB    255                       ;0FA82H 
    DB    201                       ;0FA83H 
    DB    197                       ;0FA84H 
    DB    213                       ;0FA85H 
    DB    229                       ;0FA86H 
    DB    33                        ;0FA87H 
    DB    244                       ;0FA88H 
    DB    252                       ;0FA89H 
    DB    229                       ;0FA8AH 
    DB    17                        ;0FA8BH 
    DB    255                       ;0FA8CH 
    DB    0                         ;0FA8DH 
    DB    205                       ;0FA8EH 
    DB    225                       ;0FA8FH 
    DB    250                       ;0FA90H 
    DB    71                        ;0FA91H 
    DB    33                        ;0FA92H 
    DB    230                       ;0FA93H 
    DB    243                       ;0FA94H 
    DB    60                        ;0FA95H 
    DB    194                       ;0FA96H 
    DB    158                       ;0FA97H 
    DB    250                       ;0FA98H 
    DB    54                        ;0FA99H 
    DB    1                         ;0FA9AH 
    DB    195                       ;0FA9BH 
    DB    142                       ;0FA9CH 
    DB    250                       ;0FA9DH 
    DB    78                        ;0FA9EH 
    DB    175                       ;0FA9FH 
    DB    61                        ;0FAA0H 
    DB    194                       ;0FAA1H 
    DB    160                       ;0FAA2H 
    DB    250                       ;0FAA3H 
    DB    205                       ;0FAA4H 
    DB    225                       ;0FAA5H 
    DB    250                       ;0FAA6H 
    DB    184                       ;0FAA7H 
    DB    194                       ;0FAA8H 
    DB    153                       ;0FAA9H 
    DB    250                       ;0FAAAH 
    DB    13                        ;0FAABH 
    DB    194                       ;0FAACH 
    DB    159                       ;0FAADH 
    DB    250                       ;0FAAEH 
    DB    53                        ;0FAAFH 
    DB    54                        ;0FAB0H 
    DB    63                        ;0FAB1H 
    DB    202                       ;0FAB2H 
    DB    183                       ;0FAB3H 
    DB    250                       ;0FAB4H 
    DB    54                        ;0FAB5H 
    DB    2                         ;0FAB6H 
    DB    197                       ;0FAB7H 
    DB    122                       ;0FAB8H 
    DB    15                        ;0FAB9H 
    DB    220                       ;0FABAH 
    DB    117                       ;0FABBH 
    DB    253                       ;0FABCH 
    DB    205                       ;0FABDH 
    DB    63                        ;0FABEH 
    DB    248                       ;0FABFH 
    DB    241                       ;0FAC0H 
    DB    254                       ;0FAC1H 
    DB    254                       ;0FAC2H 
    DB    192                       ;0FAC3H 
    DB    33                        ;0FAC4H 
    DB    231                       ;0FAC5H 
    DB    243                       ;0FAC6H 
    DB    126                       ;0FAC7H 
    DB    47                        ;0FAC8H 
    DB    198                       ;0FAC9H 
    DB    129                       ;0FACAH 
    DB    119                       ;0FACBH 
    DB    33                        ;0FACCH 
    DB    229                       ;0FACDH 
    DB    243                       ;0FACEH 
    DB    126                       ;0FACFH 
    DB    47                        ;0FAD0H 
    DB    119                       ;0FAD1H 
    DB    33                        ;0FAD2H 
    DB    2                         ;0FAD3H 
    DB    244                       ;0FAD4H 
    DB    119                       ;0FAD5H 
    DB    126                       ;0FAD6H 
    DB    183                       ;0FAD7H 
    DB    242                       ;0FAD8H 
    DB    214                       ;0FAD9H 
    DB    250                       ;0FADAH 
    DB    205                       ;0FADBH 
    DB    63                        ;0FADCH 
    DB    248                       ;0FADDH 
    DB    195                       ;0FADEH 
    DB    139                       ;0FADFH 
    DB    250                       ;0FAE0H 
    DB    19                        ;0FAE1H 
    DB    28                        ;0FAE2H 
    DB    29                        ;0FAE3H 
    DB    204                       ;0FAE4H 
    DB    117                       ;0FAE5H 
    DB    253                       ;0FAE6H 
    DB    205                       ;0FAE7H 
    DB    5                         ;0FAE8H 
    DB    252                       ;0FAE9H 
    DB    197                       ;0FAEAH 
    DB    213                       ;0FAEBH 
    DB    229                       ;0FAECH 
    DB    33                        ;0FAEDH 
    DB    244                       ;0FAEEH 
    DB    252                       ;0FAEFH 
    DB    229                       ;0FAF0H 
    DB    33                        ;0FAF1H 
    DB    1                         ;0FAF2H 
    DB    244                       ;0FAF3H 
    DB    1                         ;0FAF4H 
    DB    0                         ;0FAF5H 
    DB    254                       ;0FAF6H 
    DB    43                        ;0FAF7H 
    DB    112                       ;0FAF8H 
    DB    35                        ;0FAF9H 
    DB    94                        ;0FAFAH 
    DB    62                        ;0FAFBH 
    DB    255                       ;0FAFCH 
    DB    187                       ;0FAFDH 
    DB    202                       ;0FAFEH 
    DB    16                        ;0FAFFH 
    DB    251                       ;0FB00H 
    DB    22                        ;0FB01H 
    DB    5                         ;0FB02H 
    DB    61                        ;0FB03H 
    DB    194                       ;0FB04H 
    DB    3                         ;0FB05H 
    DB    251                       ;0FB06H 
    DB    21                        ;0FB07H 
    DB    194                       ;0FB08H 
    DB    3                         ;0FB09H 
    DB    251                       ;0FB0AH 
    DB    126                       ;0FB0BH 
    DB    187                       ;0FB0CH 
    DB    202                       ;0FB0DH 
    DB    34                        ;0FB0EH 
    DB    251                       ;0FB0FH 
    DB    121                       ;0FB10H 
    DB    198                       ;0FB11H 
    DB    8                         ;0FB12H 
    DB    79                        ;0FB13H 
    DB    120                       ;0FB14H 
    DB    7                         ;0FB15H 
    DB    71                        ;0FB16H 
    DB    218                       ;0FB17H 
    DB    247                       ;0FB18H 
    DB    250                       ;0FB19H 
    DB    35                        ;0FB1AH 
    DB    126                       ;0FB1BH 
    DB    183                       ;0FB1CH 
    DB    120                       ;0FB1DH 
    DB    240                       ;0FB1EH 
    DB    60                        ;0FB1FH 
    DB    201                       ;0FB20H 
    DB    12                        ;0FB21H 
    DB    31                        ;0FB22H 
    DB    218                       ;0FB23H 
    DB    33                        ;0FB24H 
    DB    251                       ;0FB25H 
    DB    121                       ;0FB26H 
    DB    254                       ;0FB27H 
    DB    16                        ;0FB28H 
    DB    218                       ;0FB29H 
    DB    96                        ;0FB2AH 
    DB    251                       ;0FB2BH 
    DB    22                        ;0FB2CH 
    DB    32                        ;0FB2DH 
    DB    254                       ;0FB2EH 
    DB    63                        ;0FB2FH 
    DB    122                       ;0FB30H 
    DB    200                       ;0FB31H 
    DB    35                        ;0FB32H 
    DB    126                       ;0FB33H 
    DB    230                       ;0FB34H 
    DB    64                        ;0FB35H 
    DB    194                       ;0FB36H 
    DB    61                        ;0FB37H 
    DB    251                       ;0FB38H 
    DB    121                       ;0FB39H 
    DB    230                       ;0FB3AH 
    DB    31                        ;0FB3BH 
    DB    201                       ;0FB3CH 
    DB    126                       ;0FB3DH 
    DB    162                       ;0FB3EH 
    DB    130                       ;0FB3FH 
    DB    111                       ;0FB40H 
    DB    121                       ;0FB41H 
    DB    162                       ;0FB42H 
    DB    202                       ;0FB43H 
    DB    79                        ;0FB44H 
    DB    251                       ;0FB45H 
    DB    58                        ;0FB46H 
    DB    229                       ;0FB47H 
    DB    243                       ;0FB48H 
    DB    47                        ;0FB49H 
    DB    230                       ;0FB4AH 
    DB    96                        ;0FB4BH 
    DB    173                       ;0FB4CH 
    DB    129                       ;0FB4DH 
    DB    201                       ;0FB4EH 
    DB    71                        ;0FB4FH 
    DB    121                       ;0FB50H 
    DB    254                       ;0FB51H 
    DB    28                        ;0FB52H 
    DB    218                       ;0FB53H 
    DB    88                        ;0FB54H 
    DB    251                       ;0FB55H 
    DB    6                         ;0FB56H 
    DB    48                        ;0FB57H 
    DB    125                       ;0FB58H 
    DB    146                       ;0FB59H 
    DB    31                        ;0FB5AH 
    DB    198                       ;0FB5BH 
    DB    16                        ;0FB5CH 
    DB    168                       ;0FB5DH 
    DB    129                       ;0FB5EH 
    DB    201                       ;0FB5FH 
    DB    33                        ;0FB60H 
    DB    104                       ;0FB61H 
    DB    251                       ;0FB62H 
    DB    6                         ;0FB63H 
    DB    0                         ;0FB64H 
    DB    9                         ;0FB65H 
    DB    126                       ;0FB66H 
    DB    201                       ;0FB67H 
    DB    12                        ;0FB68H 
    DB    31                        ;0FB69H 
    DB    27                        ;0FB6AH 
    DB    0                         ;0FB6BH 
    DB    1                         ;0FB6CH 
    DB    2                         ;0FB6DH 
    DB    3                         ;0FB6EH 
    DB    4                         ;0FB6FH 
    DB    9                         ;0FB70H 
    DB    10                        ;0FB71H 
    DB    13                        ;0FB72H 
    DB    127                       ;0FB73H 
    DB    8                         ;0FB74H 
    DB    25                        ;0FB75H 
    DB    24                        ;0FB76H 
    DB    26                        ;0FB77H 
    DB    10                        ;0FB78H 
    DB    7                         ;0FB79H 
    DB    13                        ;0FB7AH 
    DB    62                        ;0FB7BH 
    DB    0                         ;0FB7CH 
    DB    10                        ;0FB7DH 
    DB    13                        ;0FB7EH 
    DB    7                         ;0FB7FH 
    DB    69                        ;0FB80H 
    DB    82                        ;0FB81H 
    DB    82                        ;0FB82H 
    DB    79                        ;0FB83H 
    DB    82                        ;0FB84H 
    DB    7                         ;0FB85H 
    DB    7                         ;0FB86H 
    DB    0                         ;0FB87H 
    DB    33                        ;0FB88H 
    DB    120                       ;0FB89H 
    DB    251                       ;0FB8AH 
    DB    205                       ;0FB8BH 
    DB    55                        ;0FB8CH 
    DB    249                       ;0FB8DH 
    DB    33                        ;0FB8EH 
    DB    0                         ;0FB8FH 
    DB    243                       ;0FB90H 
    DB    17                        ;0FB91H 
    DB    31                        ;0FB92H 
    DB    243                       ;0FB93H 
    DB    6                         ;0FB94H 
    DB    0                         ;0FB95H 
    DB    4                         ;0FB96H 
    DB    205                       ;0FB97H 
    DB    3                         ;0FB98H 
    DB    248                       ;0FB99H 
    DB    254                       ;0FB9AH 
    DB    8                         ;0FB9BH 
    DB    202                       ;0FB9CH 
    DB    178                       ;0FB9DH 
    DB    251                       ;0FB9EH 
    DB    119                       ;0FB9FH 
    DB    79                        ;0FBA0H 
    DB    254                       ;0FBA1H 
    DB    13                        ;0FBA2H 
    DB    200                       ;0FBA3H 
    DB    205                       ;0FBA4H 
    DB    86                        ;0FBA5H 
    DB    249                       ;0FBA6H 
    DB    202                       ;0FBA7H 
    DB    151                       ;0FBA8H 
    DB    251                       ;0FBA9H 
    DB    205                       ;0FBAAH 
    DB    9                         ;0FBABH 
    DB    248                       ;0FBACH 
    DB    35                        ;0FBADH 
    DB    4                         ;0FBAEH 
    DB    194                       ;0FBAFH 
    DB    151                       ;0FBB0H 
    DB    251                       ;0FBB1H 
    DB    5                         ;0FBB2H 
    DB    202                       ;0FBB3H 
    DB    150                       ;0FBB4H 
    DB    251                       ;0FBB5H 
    DB    229                       ;0FBB6H 
    DB    33                        ;0FBB7H 
    DB    194                       ;0FBB8H 
    DB    251                       ;0FBB9H 
    DB    205                       ;0FBBAH 
    DB    55                        ;0FBBBH 
    DB    249                       ;0FBBCH 
    DB    225                       ;0FBBDH 
    DB    43                        ;0FBBEH 
    DB    195                       ;0FBBFH 
    DB    151                       ;0FBC0H 
    DB    251                       ;0FBC1H 
    DB    8                         ;0FBC2H 
    DB    32                        ;0FBC3H 
    DB    8                         ;0FBC4H 
    DB    0                         ;0FBC5H 
    DB    33                        ;0FBC6H 
    DB    0                         ;0FBC7H 
    DB    0                         ;0FBC8H 
    DB    205                       ;0FBC9H 
    DB    214                       ;0FBCAH 
    DB    251                       ;0FBCBH 
    DB    235                       ;0FBCCH 
    DB    115                       ;0FBCDH 
    DB    35                        ;0FBCEH 
    DB    114                       ;0FBCFH 
    DB    35                        ;0FBD0H 
    DB    235                       ;0FBD1H 
    DB    227                       ;0FBD2H 
    DB    233                       ;0FBD3H 
    DB    38                        ;0FBD4H 
    DB    255                       ;0FBD5H 
    DB    10                        ;0FBD6H 
    DB    254                       ;0FBD7H 
    DB    13                        ;0FBD8H 
    DB    200                       ;0FBD9H 
    DB    3                         ;0FBDAH 
    DB    254                       ;0FBDBH 
    DB    44                        ;0FBDCH 
    DB    200                       ;0FBDDH 
    DB    254                       ;0FBDEH 
    DB    32                        ;0FBDFH 
    DB    200                       ;0FBE0H 
    DB    36                        ;0FBE1H 
    DB    202                       ;0FBE2H 
    DB    212                       ;0FBE3H 
    DB    251                       ;0FBE4H 
    DB    37                        ;0FBE5H 
    DB    205                       ;0FBE6H 
    DB    245                       ;0FBE7H 
    DB    251                       ;0FBE8H 
    DB    218                       ;0FBE9H 
    DB    212                       ;0FBEAH 
    DB    251                       ;0FBEBH 
    DB    41                        ;0FBECH 
    DB    41                        ;0FBEDH 
    DB    41                        ;0FBEEH 
    DB    41                        ;0FBEFH 
    DB    133                       ;0FBF0H 
    DB    111                       ;0FBF1H 
    DB    195                       ;0FBF2H 
    DB    214                       ;0FBF3H 
    DB    251                       ;0FBF4H 
    DB    214                       ;0FBF5H 
    DB    48                        ;0FBF6H 
    DB    216                       ;0FBF7H 
    DB    254                       ;0FBF8H 
    DB    10                        ;0FBF9H 
    DB    63                        ;0FBFAH 
    DB    208                       ;0FBFBH 
    DB    254                       ;0FBFCH 
    DB    17                        ;0FBFDH 
    DB    216                       ;0FBFEH 
    DB    214                       ;0FBFFH 
    DB    7                         ;0FC00H 
    DB    254                       ;0FC01H 
    DB    16                        ;0FC02H 
    DB    63                        ;0FC03H 
    DB    201                       ;0FC04H 
    DB    245                       ;0FC05H 
    DB    205                       ;0FC06H 
    DB    11                        ;0FC07H 
    DB    252                       ;0FC08H 
    DB    241                       ;0FC09H 
    DB    201                       ;0FC0AH 
    DB    58                        ;0FC0BH 
    DB    2                         ;0FC0CH 
    DB    244                       ;0FC0DH 
    DB    230                       ;0FC0EH 
    DB    96                        ;0FC0FH 
    DB    192                       ;0FC10H 
    DB    205                       ;0FC11H 
    DB    234                       ;0FC12H 
    DB    250                       ;0FC13H 
    DB    254                       ;0FC14H 
    DB    255                       ;0FC15H 
    DB    202                       ;0FC16H 
    DB    11                        ;0FC17H 
    DB    252                       ;0FC18H 
    DB    254                       ;0FC19H 
    DB    3                         ;0FC1AH 
    DB    202                       ;0FC1BH 
    DB    108                       ;0FC1CH 
    DB    248                       ;0FC1DH 
    DB    254                       ;0FC1EH 
    DB    19                        ;0FC1FH 
    DB    202                       ;0FC20H 
    DB    42                        ;0FC21H 
    DB    254                       ;0FC22H 
    DB    254                       ;0FC23H 
    DB    32                        ;0FC24H 
    DB    202                       ;0FC25H 
    DB    182                       ;0FC26H 
    DB    248                       ;0FC27H 
    DB    229                       ;0FC28H 
    DB    42                        ;0FC29H 
    DB    223                       ;0FC2AH 
    DB    243                       ;0FC2BH 
    DB    227                       ;0FC2CH 
    DB    201                       ;0FC2DH 
    DB    205                       ;0FC2EH 
    DB    5                         ;0FC2FH 
    DB    252                       ;0FC30H 
    DB    195                       ;0FC31H 
    DB    204                       ;0FC32H 
    DB    243                       ;0FC33H 
    DB    205                       ;0FC34H 
    dcr  B                          ;0FC35H 
    cm   4FC5H                      ;0FC36H 
    mvi  B, 0C5H                    ;0FC39H 
    push D                          ;0FC3BH 
    push H                          ;0FC3CH 
    push PSW                        ;0FC3DH 
    lxi  H, 0F3DEH                  ;0FC3EH 
    mov  A, C                       ;0FC41H 
    cpi  1BH                        ;0FC42H 
    mvi  A, 0F0H                    ;0FC44H 
    jz   0FD90H                     ;0FC46H 
    mov  A, M                       ;0FC49H 
    ana  A                          ;0FC4AH 
    jnz  0FD94H                     ;0FC4BH 
    mov  A, C                       ;0FC4EH 
    cpi  7FH                        ;0FC4FH 
    jnz  0FC5DH                     ;0FC51H 
    lxi  H, 0F3D3H                  ;0FC54H 
    mov  A, M                       ;0FC57H 
    cma                             ;0FC58H 
    mov  M, A                       ;0FC59H 
    jmp  0FCF3H                     ;0FC5AH 
    mvi  H, 20H                     ;0FC5DH 
    sub  H                          ;0FC5FH 
    jc   0FCA3H                     ;0FC60H 
    mov  L, A                       ;0FC63H 
    dad  H                          ;0FC64H 
    dad  H                          ;0FC65H 
    dad  H                          ;0FC66H 
    xchg                            ;0FC67H 
    lhld 0F3D1H                     ;0FC68H 
    dad  D                          ;0FC6BH 
    xchg                            ;0FC6CH 
    call 0FD47H                     ;0FC6DH 
    xchg                            ;0FC70H 
    mvi  A, 09H                     ;0FC71H 
    push PSW                        ;0FC73H 
    push H                          ;0FC74H 
    lda  0F3D3H                     ;0FC75H 
    xra  M                          ;0FC78H 
    ani  3FH                        ;0FC79H 
    mov  L, A                       ;0FC7BH 
    lda  0F3DDH                     ;0FC7CH 
    dcr  A                          ;0FC7FH 
    mvi  H, 00H                     ;0FC80H 
    dad  H                          ;0FC82H 
    dad  H                          ;0FC83H 
    inr  A                          ;0FC84H 
    jnz  0FC82H                     ;0FC85H 
    xchg                            ;0FC88H 
    mov  A, B                       ;0FC89H 
    xra  M                          ;0FC8AH 
    ana  M                          ;0FC8BH 
    ora  D                          ;0FC8CH 
    mov  M, A                       ;0FC8DH 
    inr  H                          ;0FC8EH 
    mov  A, C                       ;0FC8FH 
    xra  M                          ;0FC90H 
    ana  M                          ;0FC91H 
    ora  E                          ;0FC92H 
    mov  M, A                       ;0FC93H 
    dcr  H                          ;0FC94H 
    inr  L                          ;0FC95H 
    xchg                            ;0FC96H 
    pop  H                          ;0FC97H 
    inx  H                          ;0FC98H 
    pop  psw                        ;0FC99H 
    cpi  02H                        ;0FC9AH 
    cz   0FCF8H                     ;0FC9CH 
    dcr  A                          ;0FC9FH 
    jnz  0FC73H                     ;0FCA0H 
    lhld 0F3D6H                     ;0FCA3H 
    call 0FD07H                     ;0FCA6H 
    dad  B                          ;0FCA9H 
    mov  A, H                       ;0FCAAH 
    cpi  19H                        ;0FCABH 
    jc   0FCF0H                     ;0FCADH 
    jnz  0FCEEH                     ;0FCB0H 
    inr  D                          ;0FCB3H 
    mov  H, D                       ;0FCB4H 
    jz   0FCF0H                     ;0FCB5H 
    push H                          ;0FCB8H 
    lxi  H, 0000H                   ;0FCB9H 
    dad  SP                         ;0FCBCH 
    shld 0F3C1H                     ;0FCBDH 
    lda  0F3D4H                     ;0FCC0H 
    call 0FCFCH                     ;0FCC3H 
    mov  A, C                       ;0FCC6H 
    adi  0AH                        ;0FCC7H 
    mov  L, A                       ;0FCC9H 
    sphl                            ;0FCCAH 
    mov  L, C                       ;0FCCBH 
    mvi  A, 0F0H                    ;0FCCCH 
    pop D                           ;0FCCEH 
    mov  M, E                       ;0FCCFH 
    inr  L                          ;0FCD0H 
    mov  M, D                       ;0FCD1H 
    inr  L                          ;0FCD2H 
    pop D                           ;0FCD3H 
    mov  M, E                       ;0FCD4H 
    inr  L                          ;0FCD5H 
    mov  M, D                       ;0FCD6H 
    inr  L                          ;0FCD7H 
    cmp  L                          ;0FCD8H 
    jnc  0FCCEH                     ;0FCD9H 
    lda  0F3D3H                     ;0FCDCH 
    mov  M, A                       ;0FCDFH 
    inr  L                          ;0FCE0H 
    jnz  0FCDFH                     ;0FCE1H 
    inr  H                          ;0FCE4H 
    dcr  B                          ;0FCE5H 
    jnz  0FCC6H                     ;0FCE6H 
    lhld 0F3C1H                     ;0FCE9H 
    sphl                            ;0FCECH 
    pop  H                          ;0FCEDH 
    mvi  H, 18H                     ;0FCEEH 
    shld 0F3D6H                     ;0FCF0H 
    pop  psw                        ;0FCF3H 
    pop  H                          ;0FCF4H 
    pop D                           ;0FCF5H 
    pop  B                          ;0FCF6H 
    ret                             ;0FCF7H 
    lxi  H, 0FD08H                  ;0FCF8H 
    ret                             ;0FCFBH 
    mov  L, A                       ;0FCFCH 
    call 0FD6DH                     ;0FCFDH 
    mov  C, A                       ;0FD00H 
    lhld 0F3CFH                     ;0FD01H 
    mov  B, H                       ;0FD04H 
    mov  H, L                       ;0FD05H 
    ret                             ;0FD06H 
    lxi  B, 0100H                   ;0FD07H 
    mov  D, C                       ;0FD0AH 
    inr  A                          ;0FD0BH 
    cz   0FDE6H                     ;0FD0CH 
    jz   0FD42H                     ;0FD0FH 
    cpi  0EBH                       ;0FD12H 
    rz                              ;0FD14H 
    dcr  D                          ;0FD15H 
    adi  05H                        ;0FD16H 
    rz                              ;0FD18H 
    inr  D                          ;0FD19H 
    mvi  B, 0FFH                    ;0FD1AH 
    inr  A                          ;0FD1CH 
    rz                              ;0FD1DH 
    mvi  C, 0FCH                    ;0FD1EH 
    cpi  0EFH                       ;0FD20H 
    rz                              ;0FD22H 
    lxi  B, 0000H                   ;0FD23H 
    cpi  0F0H                       ;0FD26H 
    jnz  0FD32H                     ;0FD28H 
    mov  A, L                       ;0FD2BH 
    ani  0E0H                       ;0FD2CH 
    adi  20H                        ;0FD2EH 
    mov  L, A                       ;0FD30H 
    ret                             ;0FD31H 
    mvi  C, 04H                     ;0FD32H 
    inr  A                          ;0FD34H 
    rz                              ;0FD35H 
    cpi  0EFH                       ;0FD36H 
    jz   0F83FH                     ;0FD38H 
    adi  0BH                        ;0FD3BH 
    jz   0FD43H                     ;0FD3DH 
    inr  A                          ;0FD40H 
    rnz                             ;0FD41H 
    mov  H, D                       ;0FD42H 
    mov  L, D                       ;0FD43H 
    mov  B, D                       ;0FD44H 
    mov  C, D                       ;0FD45H 
    ret                             ;0FD46H 
    lhld 0F3D6H                     ;0FD47H 
    mov  A, L                       ;0FD4AH 
    rrc                             ;0FD4BH 
    mov  L, A                       ;0FD4CH 
    rrc                             ;0FD4DH 
    add  L                          ;0FD4EH 
    mov  B, A                       ;0FD4FH 
    mov  L, H                       ;0FD50H 
    lda  0F3CFH                     ;0FD51H 
    mov  H, A                       ;0FD54H 
    mov  A, B                       ;0FD55H 
    dcr  H                          ;0FD56H 
    inr  H                          ;0FD57H 
    sui  04H                        ;0FD58H 
    jnc  0FD57H                     ;0FD5AH 
    sta  0F3DDH                     ;0FD5DH 
    push H                          ;0FD60H 
    lxi  H, 00FCH                   ;0FD61H 
    dad  H                          ;0FD64H 
    dad  H                          ;0FD65H 
    inr  A                          ;0FD66H 
    jnz  0FD64H                     ;0FD67H 
    mov  B, H                       ;0FD6AH 
    mov  C, L                       ;0FD6BH 
    pop  H                          ;0FD6CH 
    mov  A, L                       ;0FD6DH 
    add  A                          ;0FD6EH 
    add  A                          ;0FD6FH 
    add  A                          ;0FD70H 
    add  L                          ;0FD71H 
    add  L                          ;0FD72H 
    mov  L, A                       ;0FD73H 
    ret                             ;0FD74H 
    push B                          ;0FD75H 
    push H                          ;0FD76H 
    call 0FD47H                     ;0FD77H 
    adi  09H                        ;0FD7AH 
    mov  L, A                       ;0FD7CH 
    mov  A, B                       ;0FD7DH 
    xra  M                          ;0FD7EH 
    mov  M, A                       ;0FD7FH 
    inr  H                          ;0FD80H 
    mov  A, C                       ;0FD81H 
    xra  M                          ;0FD82H 
    mov  M, A                       ;0FD83H 
    pop  H                          ;0FD84H 
    pop  B                          ;0FD85H 
    ret                             ;0FD86H 
    mov  A, C                       ;0FD87H 
    cpi  59H                        ;0FD88H 
    jnz  0FDA2H                     ;0FD8AH 
    mvi  A, 02H                     ;0FD8DH 
    ora  B                          ;0FD8FH 
    mov  M, A                       ;0FD90H 
    jmp  0FCF3H                     ;0FD91H 
    mov  B, A                       ;0FD94H 
    ani  03H                        ;0FD95H 
    jz   0FD87H                     ;0FD97H 
    dcr  A                          ;0FD9AH 
    jz   0FDCFH                     ;0FD9BH 
    dcr  A                          ;0FD9EH 
    jz   0FDDBH                     ;0FD9FH 
    mvi  M, 00H                     ;0FDA2H 
    mov  A, C                       ;0FDA4H 
    sui  4AH                        ;0FDA5H 
    jz   0FDF0H                     ;0FDA7H 
    dcr  A                          ;0FDAAH 
    jz   0FE0EH                     ;0FDABH 
    lxi  H, 0FC4EH                  ;0FDAEH 
    push H                          ;0FDB1H 
    mvi  C, 1FH                     ;0FDB2H 
    adi  06H                        ;0FDB4H 
    rz                              ;0FDB6H 
    mvi  C, 08H                     ;0FDB7H 
    inr  A                          ;0FDB9H 
    rz                              ;0FDBAH 
    mvi  C, 18H                     ;0FDBBH 
    inr  A                          ;0FDBDH 
    rz                              ;0FDBEH 
    inr  C                          ;0FDBFH 
    adi  02H                        ;0FDC0H 
    rz                              ;0FDC2H 
    inr  C                          ;0FDC3H 
    dcr  A                          ;0FDC4H 
    rz                              ;0FDC5H 
    mvi  C, 0CH                     ;0FDC6H 
    sui  06H                        ;0FDC8H 
    rz                              ;0FDCAH 
    pop  H                          ;0FDCBH 
    jmp  0FCF3H                     ;0FDCCH 
    mov  A, C                       ;0FDCFH 
    sui  20H                        ;0FDD0H 
    add  A                          ;0FDD2H 
    add  A                          ;0FDD3H 
    sta  0F3D6H                     ;0FDD4H 
    xra  A                          ;0FDD7H 
    jmp  0FD90H                     ;0FDD8H 
    mov  A, C                       ;0FDDBH 
    sui  20H                        ;0FDDCH 
    sta  0F3D7H                     ;0FDDEH 
    mvi  A, 0F1H                    ;0FDE1H 
    jmp  0FD90H                     ;0FDE3H 
    push B                          ;0FDE6H 
    push D                          ;0FDE7H 
    push H                          ;0FDE8H 
    push PSW                        ;0FDE9H 
    lda  0F3D4H                     ;0FDEAH 
    jmp  0FDF4H                     ;0FDEDH 
    lda  0F3D7H                     ;0FDF0H 
    inr  A                          ;0FDF3H 
    cpi  19H                        ;0FDF4H 
    jnc  0FCF3H                     ;0FDF6H 
    call 0FCFCH                     ;0FDF9H 
    dcr  H                          ;0FDFCH 
    inr  H                          ;0FDFDH 
    mov  L, C                       ;0FDFEH 
    lda  0F3D3H                     ;0FDFFH 
    mov  M, A                       ;0FE02H 
    inr  L                          ;0FE03H 
    jnz  0FE02H                     ;0FE04H 
    dcr  B                          ;0FE07H 
    jnz  0FDFDH                     ;0FE08H 
    jmp  0FCF3H                     ;0FE0BH 
    lhld 0F3D6H                     ;0FE0EH 
    push H                          ;0FE11H 
    mov  B, L                       ;0FE12H 
    mvi  C, 20H                     ;0FE13H 
    call DisplayC_Entry             ;0FE15H 
    mvi  A, 04H                     ;0FE18H 
    add  B                          ;0FE1AH 
    mov  B, A                       ;0FE1BH 
    jnz  0FE15H                     ;0FE1CH 
    pop  H                          ;0FE1FH 
    jmp  0FCF0H                     ;0FE20H 
    shld 0F501H                     ;0FE23H 
    lda  0F500H                     ;0FE26H 
    ret                             ;0FE29H 
    call 0FAEAH                     ;0FE2AH 
    cpi  0DH                        ;0FE2DH 
    jnz  0FE2AH                     ;0FE2FH 
    ret                             ;0FE32H 
    mvi  C, 18H                     ;0FE33H 
    lda  0F3E7H                     ;0FE35H 
    push PSW                        ;0FE38H 
    ei                              ;0FE39H 
    dcr  A                          ;0FE3AH 
    jnz  0FE39H                     ;0FE3BH 
    pop  psw                        ;0FE3EH 
    di                              ;0FE3FH 
    dcr  A                          ;0FE40H 
    jnz  0FE3FH                     ;0FE41H 
    dcr  C                          ;0FE44H 
    jnz  0FE35H                     ;0FE45H 
    ret                             ;0FE48H 
CodePageTable:
    DB    00010100B                 ;0FE49H 
    DB    11000000B                 ;0FE4AH 
    DB    10000100B                 ;0FE4BH 
    DB    00000000B                 ;0FE4CH 
    DB    00000100B                 ;0FE4DH 
    DB    01001010B                 ;0FE4EH 
    DB    01100000B                 ;0FE4FH 
    DB    00101010B                 ;0FE50H 
    DB    00011111B                 ;0FE51H 
    DB    00001010B                 ;0FE52H 
    DB    00011111B                 ;0FE53H 
    DB    00101010B                 ;0FE54H 
    DB    00010001B                 ;0FE55H 
    DB    00001110B                 ;0FE56H 
    DB    01010001B                 ;0FE57H 
    DB    00001110B                 ;0FE58H 
    DB    00010001B                 ;0FE59H 
    DB    00011000B                 ;0FE5AH 
    DB    00011001B                 ;0FE5BH 
    DB    00000010B                 ;0FE5CH 
    DB    00000100B                 ;0FE5DH 
    DB    00001000B                 ;0FE5EH 
    DB    00010011B                 ;0FE5FH 
    DB    00000011B                 ;0FE60H 
    DB    00000100B                 ;0FE61H 
    DB    00101010B                 ;0FE62H 
    DB    00001100B                 ;0FE63H 
    DB    00010101B                 ;0FE64H 
    DB    00010010B                 ;0FE65H 
    DB    00001101B                 ;0FE66H 
    DB    00100110B                 ;0FE67H 
    DB    00000010B                 ;0FE68H 
    DB    00000100B                 ;0FE69H 
    DB    01000000B                 ;0FE6AH 
    DB    00000010B                 ;0FE6BH 
    DB    00000100B                 ;0FE6CH 
    DB    01001000B                 ;0FE6DH 
    DB    00000100B                 ;0FE6EH 
    DB    00000010B                 ;0FE6FH 
    DB    00001000B                 ;0FE70H 
    DB    00000100B                 ;0FE71H 
    DB    01000010B                 ;0FE72H 
    DB    00000100B                 ;0FE73H 
    DB    00001000B                 ;0FE74H 
    DB    00000000B                 ;0FE75H 
    DB    00000100B                 ;0FE76H 
    DB    00010101B                 ;0FE77H 
    DB    00001110B                 ;0FE78H 
    DB    00010101B                 ;0FE79H 
    DB    00000100B                 ;0FE7AH 
    DB    00000000B                 ;0FE7BH 
    DB    00000000B                 ;0FE7CH 
    DB    00100100B                 ;0FE7DH 
    DB    00011111B                 ;0FE7EH 
    DB    00100100B                 ;0FE7FH 
    DB    00000000B                 ;0FE80H 
    DB    01000000B                 ;0FE81H 
    DB    00101100B                 ;0FE82H 
    DB    00000100B                 ;0FE83H 
    DB    00001000B                 ;0FE84H 
    DB    01000000B                 ;0FE85H 
    DB    00011111B                 ;0FE86H 
    DB    01000000B                 ;0FE87H 
    DB    10000000B                 ;0FE88H 
    DB    00101100B                 ;0FE89H 
    DB    00000000B                 ;0FE8AH 
    DB    00000001B                 ;0FE8BH 
    DB    00000010B                 ;0FE8CH 
    DB    00000100B                 ;0FE8DH 
    DB    00001000B                 ;0FE8EH 
    DB    00010000B                 ;0FE8FH 
    DB    00000000B                 ;0FE90H 
    DB    00001110B                 ;0FE91H 
    DB    00010001B                 ;0FE92H 
    DB    00010011B                 ;0FE93H 
    DB    00010101B                 ;0FE94H 
    DB    00011001B                 ;0FE95H 
    DB    00010001B                 ;0FE96H 
    DB    00001110B                 ;0FE97H 
    DB    00000100B                 ;0FE98H 
    DB    00001100B                 ;0FE99H 
    DB    01100100B                 ;0FE9AH 
    DB    00001110B                 ;0FE9BH 
    DB    00001110B                 ;0FE9CH 
    DB    00010001B                 ;0FE9DH 
    DB    00000001B                 ;0FE9EH 
    DB    00000110B                 ;0FE9FH 
    DB    00001000B                 ;0FEA0H 
    DB    00010000B                 ;0FEA1H 
    DB    00011111B                 ;0FEA2H 
    DB    00011111B                 ;0FEA3H 
    DB    00000001B                 ;0FEA4H 
    DB    00000010B                 ;0FEA5H 
    DB    00000110B                 ;0FEA6H 
    DB    00000001B                 ;0FEA7H 
    DB    00010001B                 ;0FEA8H 
    DB    00001110B                 ;0FEA9H 
    DB    00000010B                 ;0FEAAH 
    DB    00000110B                 ;0FEABH 
    DB    00001010B                 ;0FEACH 
    DB    00010010B                 ;0FEADH 
    DB    00011111B                 ;0FEAEH 
    DB    00100010B                 ;0FEAFH 
    DB    00011111B                 ;0FEB0H 
    DB    00010000B                 ;0FEB1H 
    DB    00011110B                 ;0FEB2H 
    DB    00100001B                 ;0FEB3H 
    DB    00010001B                 ;0FEB4H 
    DB    00001110B                 ;0FEB5H 
    DB    00000111B                 ;0FEB6H 
    DB    00001000B                 ;0FEB7H 
    DB    00010000B                 ;0FEB8H 
    DB    00011110B                 ;0FEB9H 
    DB    00110001B                 ;0FEBAH 
    DB    00001110B                 ;0FEBBH 
    DB    00011111B                 ;0FEBCH 
    DB    00000001B                 ;0FEBDH 
    DB    00000010B                 ;0FEBEH 
    DB    00000100B                 ;0FEBFH 
    DB    01001000B                 ;0FEC0H 
    DB    00001110B                 ;0FEC1H 
    DB    00110001B                 ;0FEC2H 
    DB    00001110B                 ;0FEC3H 
    DB    00110001B                 ;0FEC4H 
    DB    00001110B                 ;0FEC5H 
    DB    00001110B                 ;0FEC6H 
    DB    00110001B                 ;0FEC7H 
    DB    00001111B                 ;0FEC8H 
    DB    00000001B                 ;0FEC9H 
    DB    00000010B                 ;0FECAH 
    DB    00011100B                 ;0FECBH 
    DB    00000000B                 ;0FECCH 
    DB    00101100B                 ;0FECDH 
    DB    00100000B                 ;0FECEH 
    DB    00101100B                 ;0FECFH 
    DB    00101100B                 ;0FED0H 
    DB    00000000B                 ;0FED1H 
    DB    00101100B                 ;0FED2H 
    DB    00000100B                 ;0FED3H 
    DB    00001000B                 ;0FED4H 
    DB    00000010B                 ;0FED5H 
    DB    00000100B                 ;0FED6H 
    DB    00001000B                 ;0FED7H 
    DB    00010000B                 ;0FED8H 
    DB    00001000B                 ;0FED9H 
    DB    00000100B                 ;0FEDAH 
    DB    00000010B                 ;0FEDBH 
    DB    00100000B                 ;0FEDCH 
    DB    00011111B                 ;0FEDDH 
    DB    00000000B                 ;0FEDEH 
    DB    00011111B                 ;0FEDFH 
    DB    00100000B                 ;0FEE0H 
    DB    00001000B                 ;0FEE1H 
    DB    00000100B                 ;0FEE2H 
    DB    00000010B                 ;0FEE3H 
    DB    00000001B                 ;0FEE4H 
    DB    00000010B                 ;0FEE5H 
    DB    00000100B                 ;0FEE6H 
    DB    00001000B                 ;0FEE7H 
    DB    00001110B                 ;0FEE8H 
    DB    00010001B                 ;0FEE9H 
    DB    00000001B                 ;0FEEAH 
    DB    00000010B                 ;0FEEBH 
    DB    00000100B                 ;0FEECH 
    DB    00000000B                 ;0FEEDH 
    DB    00000100B                 ;0FEEEH 
    DB    00001110B                 ;0FEEFH 
    DB    00010001B                 ;0FEF0H 
    DB    00010011B                 ;0FEF1H 
    DB    00010101B                 ;0FEF2H 
    DB    00010111B                 ;0FEF3H 
    DB    00010000B                 ;0FEF4H 
    DB    00001110B                 ;0FEF5H 
    DB    00000100B                 ;0FEF6H 
    DB    00001010B                 ;0FEF7H 
    DB    00110001B                 ;0FEF8H 
    DB    00011111B                 ;0FEF9H 
    DB    00110001B                 ;0FEFAH 
    DB    00011110B                 ;0FEFBH 
    DB    00110001B                 ;0FEFCH 
    DB    00011110B                 ;0FEFDH 
    DB    00110001B                 ;0FEFEH 
    DB    00011110B                 ;0FEFFH 
    DB    00001110B                 ;0FF00H 
    DB    00010001B                 ;0FF01H 
    DB    01010000B                 ;0FF02H 
    DB    00010001B                 ;0FF03H 
    DB    00001110B                 ;0FF04H 
    DB    00011110B                 ;0FF05H 
    DB    10001001B                 ;0FF06H 
    DB    00011110B                 ;0FF07H 
    DB    00011111B                 ;0FF08H 
    DB    00110000B                 ;0FF09H 
    DB    00011110B                 ;0FF0AH 
    DB    00110000B                 ;0FF0BH 
    DB    00011111B                 ;0FF0CH 
    DB    00011111B                 ;0FF0DH 
    DB    00110000B                 ;0FF0EH 
    DB    00011110B                 ;0FF0FH 
    DB    01010000B                 ;0FF10H 
    DB    00001110B                 ;0FF11H 
    DB    00010001B                 ;0FF12H 
    DB    00110000B                 ;0FF13H 
    DB    00010011B                 ;0FF14H 
    DB    00010001B                 ;0FF15H 
    DB    00001111B                 ;0FF16H 
    DB    01010001B                 ;0FF17H 
    DB    00011111B                 ;0FF18H 
    DB    01010001B                 ;0FF19H 
    DB    00001110B                 ;0FF1AH 
    DB    10000100B                 ;0FF1BH 
    DB    00001110B                 ;0FF1CH 
    DB    01100001B                 ;0FF1DH 
    DB    00110001B                 ;0FF1EH 
    DB    00001110B                 ;0FF1FH 
    DB    00010001B                 ;0FF20H 
    DB    00010010B                 ;0FF21H 
    DB    00010100B                 ;0FF22H 
    DB    00011000B                 ;0FF23H 
    DB    00010100B                 ;0FF24H 
    DB    00010010B                 ;0FF25H 
    DB    00010001B                 ;0FF26H 
    DB    10010000B                 ;0FF27H 
    DB    00010001B                 ;0FF28H 
    DB    00011111B                 ;0FF29H 
    DB    00010001B                 ;0FF2AH 
    DB    00011011B                 ;0FF2BH 
    DB    00110101B                 ;0FF2CH 
    DB    01010001B                 ;0FF2DH 
    DB    00110001B                 ;0FF2EH 
    DB    00011001B                 ;0FF2FH 
    DB    00010101B                 ;0FF30H 
    DB    00010011B                 ;0FF31H 
    DB    00110001B                 ;0FF32H 
    DB    00001110B                 ;0FF33H 
    DB    10010001B                 ;0FF34H 
    DB    00001110B                 ;0FF35H 
    DB    00011110B                 ;0FF36H 
    DB    00110001B                 ;0FF37H 
    DB    00011110B                 ;0FF38H 
    DB    01010000B                 ;0FF39H 
    DB    00001110B                 ;0FF3AH 
    DB    01010001B                 ;0FF3BH 
    DB    00010101B                 ;0FF3CH 
    DB    00010010B                 ;0FF3DH 
    DB    00001101B                 ;0FF3EH 
    DB    00011110B                 ;0FF3FH 
    DB    00110001B                 ;0FF40H 
    DB    00011110B                 ;0FF41H 
    DB    00010100B                 ;0FF42H 
    DB    00010010B                 ;0FF43H 
    DB    00010001B                 ;0FF44H 
    DB    00001110B                 ;0FF45H 
    DB    00010001B                 ;0FF46H 
    DB    00010000B                 ;0FF47H 
    DB    00001110B                 ;0FF48H 
    DB    00000001B                 ;0FF49H 
    DB    00010001B                 ;0FF4AH 
    DB    00001110B                 ;0FF4BH 
    DB    00011111B                 ;0FF4CH 
    DB    10100100B                 ;0FF4DH 
    DB    10110001B                 ;0FF4EH 
    DB    00001110B                 ;0FF4FH 
    DB    01010001B                 ;0FF50H 
    DB    00101010B                 ;0FF51H 
    DB    00100100B                 ;0FF52H 
    DB    01010001B                 ;0FF53H 
    DB    01010101B                 ;0FF54H 
    DB    00001010B                 ;0FF55H 
    DB    00110001B                 ;0FF56H 
    DB    00001010B                 ;0FF57H 
    DB    00000100B                 ;0FF58H 
    DB    00001010B                 ;0FF59H 
    DB    00110001B                 ;0FF5AH 
    DB    00110001B                 ;0FF5BH 
    DB    00001010B                 ;0FF5CH 
    DB    01100100B                 ;0FF5DH 
    DB    00011111B                 ;0FF5EH 
    DB    00000001B                 ;0FF5FH 
    DB    00000010B                 ;0FF60H 
    DB    00001110B                 ;0FF61H 
    DB    00001000B                 ;0FF62H 
    DB    00010000B                 ;0FF63H 
    DB    00011111B                 ;0FF64H 
    DB    00001110B                 ;0FF65H 
    DB    10001000B                 ;0FF66H 
    DB    00001110B                 ;0FF67H 
    DB    00000000B                 ;0FF68H 
    DB    00010000B                 ;0FF69H 
    DB    00001000B                 ;0FF6AH 
    DB    00000100B                 ;0FF6BH 
    DB    00000010B                 ;0FF6CH 
    DB    00000001B                 ;0FF6DH 
    DB    00000000B                 ;0FF6EH 
    DB    00001110B                 ;0FF6FH 
    DB    10000010B                 ;0FF70H 
    DB    00001110B                 ;0FF71H 
    DB    00001110B                 ;0FF72H 
    DB    00010001B                 ;0FF73H 
    DB    10000000B                 ;0FF74H 
    DB    10100000B                 ;0FF75H 
    DB    00011111B                 ;0FF76H 
    DB    00010010B                 ;0FF77H 
    DB    00110101B                 ;0FF78H 
    DB    00011101B                 ;0FF79H 
    DB    00110101B                 ;0FF7AH 
    DB    00010010B                 ;0FF7BH 
    DB    00000100B                 ;0FF7CH 
    DB    00001010B                 ;0FF7DH 
    DB    00110001B                 ;0FF7EH 
    DB    00011111B                 ;0FF7FH 
    DB    00110001B                 ;0FF80H 
    DB    00011111B                 ;0FF81H 
    DB    00110000B                 ;0FF82H 
    DB    00011110B                 ;0FF83H 
    DB    00110001B                 ;0FF84H 
    DB    00011110B                 ;0FF85H 
    DB    10010010B                 ;0FF86H 
    DB    00011111B                 ;0FF87H 
    DB    00000001B                 ;0FF88H 
    DB    00000110B                 ;0FF89H 
    DB    01101010B                 ;0FF8AH 
    DB    00011111B                 ;0FF8BH 
    DB    00010001B                 ;0FF8CH 
    DB    00011111B                 ;0FF8DH 
    DB    00110000B                 ;0FF8EH 
    DB    00011110B                 ;0FF8FH 
    DB    00110000B                 ;0FF90H 
    DB    00011111B                 ;0FF91H 
    DB    00000100B                 ;0FF92H 
    DB    00011111B                 ;0FF93H 
    DB    00110101B                 ;0FF94H 
    DB    00011111B                 ;0FF95H 
    DB    00100100B                 ;0FF96H 
    DB    00011111B                 ;0FF97H 
    DB    00010001B                 ;0FF98H 
    DB    10010000B                 ;0FF99H 
    DB    00110001B                 ;0FF9AH 
    DB    00001010B                 ;0FF9BH 
    DB    00000100B                 ;0FF9CH 
    DB    00001010B                 ;0FF9DH 
    DB    00110001B                 ;0FF9EH 
    DB    00110001B                 ;0FF9FH 
    DB    00010011B                 ;0FFA0H 
    DB    00010101B                 ;0FFA1H 
    DB    00011001B                 ;0FFA2H 
    DB    00110001B                 ;0FFA3H 
    DB    00010101B                 ;0FFA4H 
    DB    00010001B                 ;0FFA5H 
    DB    00010011B                 ;0FFA6H 
    DB    00010101B                 ;0FFA7H 
    DB    00011001B                 ;0FFA8H 
    DB    00110001B                 ;0FFA9H 
    DB    00010001B                 ;0FFAAH 
    DB    00010010B                 ;0FFABH 
    DB    00010100B                 ;0FFACH 
    DB    00011000B                 ;0FFADH 
    DB    00010100B                 ;0FFAEH 
    DB    00010010B                 ;0FFAFH 
    DB    00010001B                 ;0FFB0H 
    DB    00000111B                 ;0FFB1H 
    DB    10001001B                 ;0FFB2H 
    DB    00011001B                 ;0FFB3H 
    DB    00010001B                 ;0FFB4H 
    DB    00011011B                 ;0FFB5H 
    DB    00110101B                 ;0FFB6H 
    DB    01010001B                 ;0FFB7H 
    DB    01010001B                 ;0FFB8H 
    DB    00011111B                 ;0FFB9H 
    DB    01010001B                 ;0FFBAH 
    DB    00001110B                 ;0FFBBH 
    DB    10010001B                 ;0FFBCH 
    DB    00001110B                 ;0FFBDH 
    DB    00011111B                 ;0FFBEH 
    DB    10110001B                 ;0FFBFH 
    DB    00001111B                 ;0FFC0H 
    DB    00110001B                 ;0FFC1H 
    DB    00001111B                 ;0FFC2H 
    DB    00000101B                 ;0FFC3H 
    DB    00001001B                 ;0FFC4H 
    DB    00010001B                 ;0FFC5H 
    DB    00011110B                 ;0FFC6H 
    DB    00110001B                 ;0FFC7H 
    DB    00011110B                 ;0FFC8H 
    DB    01010000B                 ;0FFC9H 
    DB    00001110B                 ;0FFCAH 
    DB    00010001B                 ;0FFCBH 
    DB    01010000B                 ;0FFCCH 
    DB    00010001B                 ;0FFCDH 
    DB    00001110B                 ;0FFCEH 
    DB    00011111B                 ;0FFCFH 
    DB    10100100B                 ;0FFD0H 
    DB    01010001B                 ;0FFD1H 
    DB    00001010B                 ;0FFD2H 
    DB    00000100B                 ;0FFD3H 
    DB    00001000B                 ;0FFD4H 
    DB    00010000B                 ;0FFD5H 
    DB    00010001B                 ;0FFD6H 
    DB    00110101B                 ;0FFD7H 
    DB    00001110B                 ;0FFD8H 
    DB    00110101B                 ;0FFD9H 
    DB    00010001B                 ;0FFDAH 
    DB    00011110B                 ;0FFDBH 
    DB    00110001B                 ;0FFDCH 
    DB    00011110B                 ;0FFDDH 
    DB    00110001B                 ;0FFDEH 
    DB    00011110B                 ;0FFDFH 
    DB    01010000B                 ;0FFE0H 
    DB    00011110B                 ;0FFE1H 
    DB    00110001B                 ;0FFE2H 
    DB    00011110B                 ;0FFE3H 
    DB    01010001B                 ;0FFE4H 
    DB    00011001B                 ;0FFE5H 
    DB    00110101B                 ;0FFE6H 
    DB    00011001B                 ;0FFE7H 
    DB    00001110B                 ;0FFE8H 
    DB    00010001B                 ;0FFE9H 
    DB    00000001B                 ;0FFEAH 
    DB    00000110B                 ;0FFEBH 
    DB    00000001B                 ;0FFECH 
    DB    00010001B                 ;0FFEDH 
    DB    00001110B                 ;0FFEEH 
    DB    00010001B                 ;0FFEFH 
    DB    10010101B                 ;0FFF0H 
    DB    00011111B                 ;0FFF1H 
    DB    00001110B                 ;0FFF2H 
    DB    00010001B                 ;0FFF3H 
    DB    00000001B                 ;0FFF4H 
    DB    00000111B                 ;0FFF5H 
    DB    00000001B                 ;0FFF6H 
    DB    00010001B                 ;0FFF7H 
    DB    00001110B                 ;0FFF8H 
    DB    10010101B                 ;0FFF9H 
    DB    00011111B                 ;0FFFAH 
    DB    00000001B                 ;0FFFBH 
    DB    01010001B                 ;0FFFCH 
    DB    00011111B                 ;0FFFDH 
    DB    01000001B                 ;0FFFEH 
    DB    01010010B                 ;0FFFFH 
