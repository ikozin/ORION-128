include "8085.inc"
ORG 0F800H

    mvi  A, 00H                     ;0F800H 
    out  0F9H                       ;0F802H 
    out  0FAH                       ;0F804H 
    mvi  C, 0FFH                    ;0F806H 
    mov  A, C                       ;0F808H 
Beep:
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
    jnz  Beep                       ;0F819H 
    lxi  H, 0F800H                  ;0F81CH 
    mvi  M, 02H                     ;0F81FH 
    mvi  B, 80H                     ;0F821H 
    mvi  C, 00H                     ;0F823H 
L_4:
    lxi  D, 0000H                   ;0F825H 
L_5:
    mov  A, B                       ;0F828H 
    stax D                          ;0F829H 
    ldax D                          ;0F82AH 
    xra  B                          ;0F82BH 
    ora  C                          ;0F82CH 
    mov  C, A                       ;0F82DH 
    inx  D                          ;0F82EH 
    mov  A, B                       ;0F82FH 
    cma                             ;0F830H 
    mov  B, A                       ;0F831H 
    mov  A, D                       ;0F832H 
    cpi  0F4H                       ;0F833H 
    jnz  L_5                        ;0F835H 
    mov  A, B                       ;0F838H 
    cma                             ;0F839H 
    rrc                             ;0F83AH 
    mov  B, A                       ;0F83BH 
    cpi  80H                        ;0F83CH 
    jnz  L_4                        ;0F83EH 
    mov  A, C                       ;0F841H 
    cpi  00H                        ;0F842H 
    jz   L_13                       ;0F844H 
    mvi  A, 01H                     ;0F847H 
    lxi  H, L_6                     ;0F849H 
    ana  C                          ;0F84CH 
    jnz  L_114                      ;0F84DH 
    jmp  L_110                      ;0F850H 
L_6:
    mvi  A, 02H                     ;0F853H 
    lxi  H, L_7                     ;0F855H 
    ana  C                          ;0F858H 
    jnz  L_114                      ;0F859H 
    jmp  L_110                      ;0F85CH 
L_7:
    mvi  A, 04H                     ;0F85FH 
    lxi  H, L_8                     ;0F861H 
    ana  C                          ;0F864H 
    jnz  L_114                      ;0F865H 
    jmp  L_110                      ;0F868H 
L_8:
    mvi  A, 08H                     ;0F86BH 
    lxi  H, L_9                     ;0F86DH 
    ana  C                          ;0F870H 
    jnz  L_114                      ;0F871H 
    jmp  L_110                      ;0F874H 
L_9:
    mvi  A, 10H                     ;0F877H 
    lxi  H, L_10                    ;0F879H 
    ana  C                          ;0F87CH 
    jnz  L_114                      ;0F87DH 
    jmp  L_110                      ;0F880H 
L_10:
    mvi  A, 20H                     ;0F883H 
    lxi  H, L_11                    ;0F885H 
    ana  C                          ;0F888H 
    jnz  L_114                      ;0F889H 
    jmp  L_110                      ;0F88CH 
L_11:
    mvi  A, 40H                     ;0F88FH 
    lxi  H, L_12                    ;0F891H 
    ana  C                          ;0F894H 
    jnz  L_114                      ;0F895H 
    jmp  L_110                      ;0F898H 
L_12:
    mvi  A, 80H                     ;0F89BH 
    lxi  H, L_13                    ;0F89DH 
    ana  C                          ;0F8A0H 
    jnz  L_114                      ;0F8A1H 
    jmp  L_110                      ;0F8A4H 
L_13:
    lxi  D, 0F403H                  ;0F8A7H 
    mvi  A, 80H                     ;0F8AAH 
    stax D                          ;0F8ACH 
    inr  H                          ;0F8ADH 
    stax D                          ;0F8AEH 
    inr  D                          ;0F8AFH 
    stax D                          ;0F8B0H 
    lxi  D, 0F400H                  ;0F8B1H 
L_14:
    mov  A, C                       ;0F8B4H 
    stax D                          ;0F8B5H 
    inx  D                          ;0F8B6H 
    stax D                          ;0F8B7H 
    inx  D                          ;0F8B8H 
    stax D                          ;0F8B9H 
    inr  D                          ;0F8BAH 
    mov  A, D                       ;0F8BBH 
    cpi  0F6H                       ;0F8BCH 
    jnz  L_14                       ;0F8BEH 
    lxi  H, 0F800H                  ;0F8C1H 
    mvi  M, 00H                     ;0F8C4H 
    lxi  H, 0C000H                  ;0F8C6H 
L_15:
    mvi  M, 00H                     ;0F8C9H 
    inx  H                          ;0F8CBH 
    mov  A, H                       ;0F8CCH 
    cpi  0F0H                       ;0F8CDH 
    jnz  L_15                       ;0F8CFH 
    mvi  E, 30H                     ;0F8D2H 
L_16:
    mvi  D, 0CCH                    ;0F8D4H 
L_17:
    mvi  A, 0FFH                    ;0F8D6H 
    stax D                          ;0F8D8H 
    inr  D                          ;0F8D9H 
    stax D                          ;0F8DAH 
    inr  D                          ;0F8DBH 
    inr  D                          ;0F8DCH 
    inr  D                          ;0F8DDH 
    mov  A, D                       ;0F8DEH 
    cpi  0ECH                       ;0F8DFH 
    jnz  L_17                       ;0F8E1H 
    mvi  A, 10H                     ;0F8E4H 
    add  E                          ;0F8E6H 
    mov  E, A                       ;0F8E7H 
    cpi  0B0H                       ;0F8E8H 
    jnz  L_16                       ;0F8EAH 
    lxi  H, L_18                    ;0F8EDH 
    lxi  D, 0CC30H                  ;0F8F0H 
    mvi  A, 01H                     ;0F8F3H 
    ana  C                          ;0F8F5H 
    jnz  L_105                      ;0F8F6H 
    jmp  L_104                      ;0F8F9H 
L_18:
    mvi  A, 02H                     ;0F8FCH 
    ana  C                          ;0F8FEH 
    lxi  H, L_19                    ;0F8FFH 
    jnz  L_105                      ;0F902H 
    jmp  L_104                      ;0F905H 
L_19:
    mvi  A, 04H                     ;0F908H 
    ana  C                          ;0F90AH 
    lxi  H, L_20                    ;0F90BH 
    jnz  L_105                      ;0F90EH 
    jmp  L_104                      ;0F911H 
L_20:
    mvi  A, 08H                     ;0F914H 
    ana  C                          ;0F916H 
    lxi  H, L_21                    ;0F917H 
    jnz  L_105                      ;0F91AH 
    jmp  L_104                      ;0F91DH 
L_21:
    mvi  A, 10H                     ;0F920H 
    ana  C                          ;0F922H 
    lxi  H, L_22                    ;0F923H 
    jnz  L_105                      ;0F926H 
    jmp  L_104                      ;0F929H 
L_22:
    mvi  A, 20H                     ;0F92CH 
    ana  C                          ;0F92EH 
    lxi  H, L_23                    ;0F92FH 
    jnz  L_105                      ;0F932H 
    jmp  L_104                      ;0F935H 
L_23:
    mvi  A, 40H                     ;0F938H 
    ana  C                          ;0F93AH 
    lxi  H, L_24                    ;0F93BH 
    jnz  L_105                      ;0F93EH 
    jmp  L_104                      ;0F941H 
L_24:
    mvi  A, 80H                     ;0F944H 
    ana  C                          ;0F946H 
    lxi  H, L_25                    ;0F947H 
    jnz  L_105                      ;0F94AH 
    jmp  L_104                      ;0F94DH 
L_25:
    mvi  H, 0CCH                    ;0F950H 
    mvi  B, 80H                     ;0F952H 
    lxi  D, L_26                    ;0F954H 
    jmp  L_107                      ;0F957H 
L_26:
    mvi  H, 0CDH                    ;0F95AH 
    mvi  B, 01H                     ;0F95CH 
    lxi  D, L_27                    ;0F95EH 
    jmp  L_107                      ;0F961H 
L_27:
    lxi  H, 0D204H                  ;0F964H 
    lxi  D, Inversed_Text_Copyright ;0F967H 
L_28:
    mvi  B, 09H                     ;0F96AH 
L_29:
    ldax D                          ;0F96CH 
    mov  M, A                       ;0F96DH 
    inx  D                          ;0F96EH 
    inx  H                          ;0F96FH 
    dcr  B                          ;0F970H 
    mov  A, B                       ;0F971H 
    jnz  L_29                       ;0F972H 
    inr  H                          ;0F975H 
    mvi  L, 04H                     ;0F976H 
    mov  A, H                       ;0F978H 
    cpi  0DDH                       ;0F979H 
    jnz  L_28                       ;0F97BH 
    lxi  D, Inversed_Text_Line      ;0F97EH 
    mvi  H, 0C2H                    ;0F981H 
L_30:
    mvi  L, 34H                     ;0F983H 
L_31:
    ldax D                          ;0F985H 
    mov  M, A                       ;0F986H 
    inx  D                          ;0F987H 
    inr  L                          ;0F988H 
    mov  A, L                       ;0F989H 
    cpi  3DH                        ;0F98AH 
    jnz  L_31                       ;0F98CH 
    inr  H                          ;0F98FH 
    mov  A, H                       ;0F990H 
    cpi  0C6H                       ;0F991H 
    jnz  L_30                       ;0F993H 
    lxi  H, L_32                    ;0F996H 
    lxi  D, Inversed_Text_1         ;0F999H 
    lxi  B, 0C634H                  ;0F99CH 
    jmp  L_131                      ;0F99FH 
L_32:
    lxi  D, Inversed_Text_Line      ;0F9A2H 
    mvi  H, 0C2H                    ;0F9A5H 
L_33:
    mvi  L, 54H                     ;0F9A7H 
L_34:
    ldax D                          ;0F9A9H 
    mov  M, A                       ;0F9AAH 
    inx  D                          ;0F9ABH 
    inr  L                          ;0F9ACH 
    mov  A, L                       ;0F9ADH 
    cpi  5DH                        ;0F9AEH 
    jnz  L_34                       ;0F9B0H 
    inr  H                          ;0F9B3H 
    mov  A, H                       ;0F9B4H 
    cpi  0C6H                       ;0F9B5H 
    jnz  L_33                       ;0F9B7H 
    lxi  H, L_35                    ;0F9BAH 
    lxi  D, Inversed_Text_2         ;0F9BDH 
    lxi  B, 0C654H                  ;0F9C0H 
    jmp  L_131                      ;0F9C3H 
L_35:
    lxi  H, L_36                    ;0F9C6H 
    mvi  A, 01H                     ;0F9C9H 
    jmp  L_101                      ;0F9CBH 
L_36:
    lxi  H, L_37                    ;0F9CEH 
    lxi  D, 0CC50H                  ;0F9D1H 
    mvi  A, 01H                     ;0F9D4H 
    ana  C                          ;0F9D6H 
    jnz  L_105                      ;0F9D7H 
    jmp  L_104                      ;0F9DAH 
L_37:
    mvi  A, 02H                     ;0F9DDH 
    ana  C                          ;0F9DFH 
    lxi  H, L_38                    ;0F9E0H 
    jnz  L_105                      ;0F9E3H 
    jmp  L_104                      ;0F9E6H 
L_38:
    mvi  A, 04H                     ;0F9E9H 
    ana  C                          ;0F9EBH 
    lxi  H, L_39                    ;0F9ECH 
    jnz  L_105                      ;0F9EFH 
    jmp  L_104                      ;0F9F2H 
L_39:
    mvi  A, 08H                     ;0F9F5H 
    ana  C                          ;0F9F7H 
    lxi  H, L_40                    ;0F9F8H 
    jnz  L_105                      ;0F9FBH 
    jmp  L_104                      ;0F9FEH 
L_40:
    mvi  A, 10H                     ;0FA01H 
    ana  C                          ;0FA03H 
    lxi  H, L_41                    ;0FA04H 
    jnz  L_105                      ;0FA07H 
    jmp  L_104                      ;0FA0AH 
L_41:
    mvi  A, 20H                     ;0FA0DH 
    ana  C                          ;0FA0FH 
    lxi  H, L_42                    ;0FA10H 
    jnz  L_105                      ;0FA13H 
    jmp  L_104                      ;0FA16H 
L_42:
    mvi  A, 40H                     ;0FA19H 
    ana  C                          ;0FA1BH 
    lxi  H, L_43                    ;0FA1CH 
    jnz  L_105                      ;0FA1FH 
    jmp  L_104                      ;0FA22H 
L_43:
    mvi  A, 80H                     ;0FA25H 
    ana  C                          ;0FA27H 
    lxi  H, L_44                    ;0FA28H 
    jnz  L_105                      ;0FA2BH 
    jmp  L_104                      ;0FA2EH 
    lxi  H, 0001H                   ;0FA31H 
    mov  M, C                       ;0FA34H 
L_44:
    lxi  D, Inversed_Text_Line      ;0FA35H 
    mvi  H, 0C2H                    ;0FA38H 
L_45:
    mvi  L, 74H                     ;0FA3AH 
L_46:
    ldax D                          ;0FA3CH 
    mov  M, A                       ;0FA3DH 
    inx  D                          ;0FA3EH 
    inr  L                          ;0FA3FH 
    mov  A, L                       ;0FA40H 
    cpi  7DH                        ;0FA41H 
    jnz  L_46                       ;0FA43H 
    inr  H                          ;0FA46H 
    mov  A, H                       ;0FA47H 
    cpi  0C6H                       ;0FA48H 
    jnz  L_45                       ;0FA4AH 
    lxi  H, L_47                    ;0FA4DH 
    lxi  D, Inversed_Text_3         ;0FA50H 
    lxi  B, 0C674H                  ;0FA53H 
    jmp  L_131                      ;0FA56H 
L_47:
    lxi  H, L_48                    ;0FA59H 
    mvi  A, 02H                     ;0FA5CH 
    jmp  L_101                      ;0FA5EH 
L_48:
    lxi  H, L_49                    ;0FA61H 
    lxi  D, 0CC70H                  ;0FA64H 
    mvi  A, 01H                     ;0FA67H 
    ana  C                          ;0FA69H 
    jnz  L_105                      ;0FA6AH 
    jmp  L_104                      ;0FA6DH 
L_49:
    mvi  A, 02H                     ;0FA70H 
    ana  C                          ;0FA72H 
    lxi  H, L_50                    ;0FA73H 
    jnz  L_105                      ;0FA76H 
    jmp  L_104                      ;0FA79H 
L_50:
    mvi  A, 04H                     ;0FA7CH 
    ana  C                          ;0FA7EH 
    lxi  H, L_51                    ;0FA7FH 
    jnz  L_105                      ;0FA82H 
    jmp  L_104                      ;0FA85H 
L_51:
    mvi  A, 08H                     ;0FA88H 
    ana  C                          ;0FA8AH 
    lxi  H, L_52                    ;0FA8BH 
    jnz  L_105                      ;0FA8EH 
    jmp  L_104                      ;0FA91H 
L_52:
    mvi  A, 10H                     ;0FA94H 
    ana  C                          ;0FA96H 
    lxi  H, L_53                    ;0FA97H 
    jnz  L_105                      ;0FA9AH 
    jmp  L_104                      ;0FA9DH 
L_53:
    mvi  A, 20H                     ;0FAA0H 
    ana  C                          ;0FAA2H 
    lxi  H, L_54                    ;0FAA3H 
    jnz  L_105                      ;0FAA6H 
    jmp  L_104                      ;0FAA9H 
L_54:
    mvi  A, 40H                     ;0FAACH 
    ana  C                          ;0FAAEH 
    lxi  H, L_55                    ;0FAAFH 
    jnz  L_105                      ;0FAB2H 
    jmp  L_104                      ;0FAB5H 
L_55:
    mvi  A, 80H                     ;0FAB8H 
    ana  C                          ;0FABAH 
    lxi  H, L_56                    ;0FABBH 
    jnz  L_105                      ;0FABEH 
    jmp  L_104                      ;0FAC1H 
L_56:
    lxi  D, Inversed_Text_Line      ;0FAC4H 
    mvi  H, 0C2H                    ;0FAC7H 
L_57:
    mvi  L, 94H                     ;0FAC9H 
L_58:
    ldax D                          ;0FACBH 
    mov  M, A                       ;0FACCH 
    inx  D                          ;0FACDH 
    inr  L                          ;0FACEH 
    mov  A, L                       ;0FACFH 
    cpi  9DH                        ;0FAD0H 
    jnz  L_58                       ;0FAD2H 
    inr  H                          ;0FAD5H 
    mov  A, H                       ;0FAD6H 
    cpi  0C7H                       ;0FAD7H 
    jnz  L_57                       ;0FAD9H 
    lxi  H, L_59                    ;0FADCH 
    lxi  D, Inversed_Text_4         ;0FADFH 
    lxi  B, 0C694H                  ;0FAE2H 
    jmp  L_131                      ;0FAE5H 
L_59:
    lxi  H, L_60                    ;0FAE8H 
    mvi  A, 03H                     ;0FAEBH 
    jmp  L_101                      ;0FAEDH 
L_60:
    lxi  H, L_61                    ;0FAF0H 
    lxi  D, 0CC90H                  ;0FAF3H 
    mvi  A, 01H                     ;0FAF6H 
    ana  C                          ;0FAF8H 
    jnz  L_105                      ;0FAF9H 
    jmp  L_104                      ;0FAFCH 
L_61:
    mvi  A, 02H                     ;0FAFFH 
    ana  C                          ;0FB01H 
    lxi  H, L_62                    ;0FB02H 
    jnz  L_105                      ;0FB05H 
    jmp  L_104                      ;0FB08H 
L_62:
    mvi  A, 04H                     ;0FB0BH 
    ana  C                          ;0FB0DH 
    lxi  H, L_63                    ;0FB0EH 
    jnz  L_105                      ;0FB11H 
    jmp  L_104                      ;0FB14H 
L_63:
    mvi  A, 08H                     ;0FB17H 
    ana  C                          ;0FB19H 
    lxi  H, L_64                    ;0FB1AH 
    jnz  L_105                      ;0FB1DH 
    jmp  L_104                      ;0FB20H 
L_64:
    mvi  A, 10H                     ;0FB23H 
    ana  C                          ;0FB25H 
    lxi  H, L_65                    ;0FB26H 
    jnz  L_105                      ;0FB29H 
    jmp  L_104                      ;0FB2CH 
L_65:
    mvi  A, 20H                     ;0FB2FH 
    ana  C                          ;0FB31H 
    lxi  H, L_66                    ;0FB32H 
    jnz  L_105                      ;0FB35H 
    jmp  L_104                      ;0FB38H 
L_66:
    mvi  A, 40H                     ;0FB3BH 
    ana  C                          ;0FB3DH 
    lxi  H, L_67                    ;0FB3EH 
    jnz  L_105                      ;0FB41H 
    jmp  L_104                      ;0FB44H 
L_67:
    mvi  A, 80H                     ;0FB47H 
    ana  C                          ;0FB49H 
    lxi  H, L_68                    ;0FB4AH 
    jnz  L_105                      ;0FB4DH 
    jmp  L_104                      ;0FB50H 
    lxi  H, 0001H                   ;0FB53H 
    mov  M, C                       ;0FB56H 
L_68:
    nop                             ;0FB57H 
    lxi  D, Inversed_Text_Port      ;0FB58H 
    mvi  H, 0C7H                    ;0FB5BH 
L_69:
    mvi  L, 0B4H                    ;0FB5DH 
L_70:
    ldax D                          ;0FB5FH 
    mov  M, A                       ;0FB60H 
    inx  D                          ;0FB61H 
    inr  L                          ;0FB62H 
    mov  A, L                       ;0FB63H 
    cpi  0BDH                       ;0FB64H 
    jnz  L_70                       ;0FB66H 
    inr  H                          ;0FB69H 
    mov  A, H                       ;0FB6AH 
    cpi  0CBH                       ;0FB6BH 
    jnz  L_69                       ;0FB6DH 
    lxi  H, L_71                    ;0FB70H 
    lxi  D, Inversed_Text_1         ;0FB73H 
    lxi  B, 0CBB4H                  ;0FB76H 
    jmp  L_131                      ;0FB79H 
L_71:
    lxi  H, 0F403H                  ;0FB7CH 
    mvi  C, 00H                     ;0FB7FH 
    mvi  M, 80H                     ;0FB81H 
    dcx  H                          ;0FB83H 
    mvi  A, 55H                     ;0FB84H 
    mov  M, A                       ;0FB86H 
    dcx  H                          ;0FB87H 
    mov  M, A                       ;0FB88H 
    dcx  H                          ;0FB89H 
    mov  M, A                       ;0FB8AH 
    lxi  H, 0F403H                  ;0FB8BH 
    cmp  M                          ;0FB8EH 
    jnz  L_73                       ;0FB8FH 
    dcx  H                          ;0FB92H 
    cmp  M                          ;0FB93H 
    jnz  L_73                       ;0FB94H 
    dcx  H                          ;0FB97H 
    cmp  M                          ;0FB98H 
    jnz  L_73                       ;0FB99H 
    lxi  H, 0F403H                  ;0FB9CH 
    mvi  M, 80H                     ;0FB9FH 
    dcx  H                          ;0FBA1H 
    mvi  A, 0AAH                    ;0FBA2H 
    mov  M, A                       ;0FBA4H 
    dcx  H                          ;0FBA5H 
    mov  M, A                       ;0FBA6H 
    dcx  H                          ;0FBA7H 
    mov  M, A                       ;0FBA8H 
    lxi  H, 0F403H                  ;0FBA9H 
    cmp  M                          ;0FBACH 
    jnz  L_73                       ;0FBADH 
    dcx  H                          ;0FBB0H 
    cmp  M                          ;0FBB1H 
    jnz  L_73                       ;0FBB2H 
    dcx  H                          ;0FBB5H 
    cmp  M                          ;0FBB6H 
    jnz  L_73                       ;0FBB7H 
    lxi  H, L_72                    ;0FBBAH 
    lxi  D, Inversed_Text_Ok        ;0FBBDH 
    lxi  B, 0C9C4H                  ;0FBC0H 
    jmp  L_131                      ;0FBC3H 
L_72:
    lxi  H, L_76                    ;0FBC6H 
    lxi  B, 0CAC4H                  ;0FBC9H 
    jmp  L_131                      ;0FBCCH 
L_73:
    lxi  H, L_74                    ;0FBCFH 
    lxi  D, Inversed_Text_Bad       ;0FBD2H 
    lxi  B, 0C8C4H                  ;0FBD5H 
    jmp  L_131                      ;0FBD8H 
L_74:
    lxi  H, L_75                    ;0FBDBH 
    lxi  B, 0C9C4H                  ;0FBDEH 
    jmp  L_131                      ;0FBE1H 
L_75:
    lxi  H, L_76                    ;0FBE4H 
    lxi  B, 0CAC4H                  ;0FBE7H 
    jmp  L_131                      ;0FBEAH 
L_76:
    lxi  D, Inversed_Text_Port      ;0FBEDH 
    mvi  H, 0D4H                    ;0FBF0H 
L_77:
    mvi  L, 0B4H                    ;0FBF2H 
L_78:
    ldax D                          ;0FBF4H 
    mov  M, A                       ;0FBF5H 
    inx  D                          ;0FBF6H 
    inr  L                          ;0FBF7H 
    mov  A, L                       ;0FBF8H 
    cpi  0BDH                       ;0FBF9H 
    jnz  L_78                       ;0FBFBH 
    inr  H                          ;0FBFEH 
    mov  A, H                       ;0FBFFH 
    cpi  0D8H                       ;0FC00H 
    jnz  L_77                       ;0FC02H 
    lxi  H, 0FC11H                  ;0FC05H 
    lxi  D, Inversed_Text_2         ;0FC08H 
    lxi  B, 0D8B4H                  ;0FC0BH 
    jmp  L_131                      ;0FC0EH 
    lxi  H, 0F503H                  ;0FC11H 
    mvi  C, 00H                     ;0FC14H 
    mvi  M, 80H                     ;0FC16H 
    dcx  H                          ;0FC18H 
    mvi  A, 55H                     ;0FC19H 
    mov  M, A                       ;0FC1BH 
    dcx  H                          ;0FC1CH 
    mov  M, A                       ;0FC1DH 
    dcx  H                          ;0FC1EH 
    mov  M, A                       ;0FC1FH 
    lxi  H, 0F503H                  ;0FC20H 
    cmp  M                          ;0FC23H 
    jnz  L_79                       ;0FC24H 
    dcx  H                          ;0FC27H 
    cmp  M                          ;0FC28H 
    jnz  L_79                       ;0FC29H 
    dcx  H                          ;0FC2CH 
    cmp  M                          ;0FC2DH 
    jnz  L_79                       ;0FC2EH 
    lxi  H, 0F503H                  ;0FC31H 
    mvi  M, 80H                     ;0FC34H 
    dcx  H                          ;0FC36H 
    mvi  A, 0AAH                    ;0FC37H 
    mov  M, A                       ;0FC39H 
    dcx  H                          ;0FC3AH 
    mov  M, A                       ;0FC3BH 
    dcx  H                          ;0FC3CH 
    mov  M, A                       ;0FC3DH 
    lxi  H, 0F503H                  ;0FC3EH 
    cmp  M                          ;0FC41H 
    jnz  L_79                       ;0FC42H 
    dcx  H                          ;0FC45H 
    cmp  M                          ;0FC46H 
    jnz  L_79                       ;0FC47H 
    dcx  H                          ;0FC4AH 
    cmp  M                          ;0FC4BH 
    jnz  L_73                       ;0FC4CH 
    lxi  H, 0FC5BH                  ;0FC4FH 
    lxi  D, Inversed_Text_Ok        ;0FC52H 
    lxi  B, 0D6C4H                  ;0FC55H 
    jmp  L_131                      ;0FC58H 
    lxi  H, L_82                    ;0FC5BH 
    lxi  B, 0D7C4H                  ;0FC5EH 
    jmp  L_131                      ;0FC61H 
L_79:
    lxi  H, L_80                    ;0FC64H 
    lxi  D, Inversed_Text_Bad       ;0FC67H 
    lxi  B, 0D5C4H                  ;0FC6AH 
    jmp  L_131                      ;0FC6DH 
L_80:
    lxi  H, L_81                    ;0FC70H 
    lxi  B, 0D6C4H                  ;0FC73H 
    jmp  L_131                      ;0FC76H 
L_81:
    lxi  H, L_82                    ;0FC79H 
    lxi  B, 0D7C4H                  ;0FC7CH 
    jmp  L_131                      ;0FC7FH 
    nop                             ;0FC82H 
L_82:
    lxi  D, Inversed_Text_Port      ;0FC83H 
    mvi  H, 0E1H                    ;0FC86H 
L_83:
    mvi  L, 0B4H                    ;0FC88H 
L_84:
    ldax D                          ;0FC8AH 
    mov  M, A                       ;0FC8BH 
    inx  D                          ;0FC8CH 
    inr  L                          ;0FC8DH 
    mov  A, L                       ;0FC8EH 
    cpi  0BDH                       ;0FC8FH 
    jnz  L_84                       ;0FC91H 
    inr  H                          ;0FC94H 
    mov  A, H                       ;0FC95H 
    cpi  0E5H                       ;0FC96H 
    jnz  L_83                       ;0FC98H 
    lxi  H, L_85                    ;0FC9BH 
    lxi  D, Inversed_Text_3         ;0FC9EH 
    lxi  B, 0E5B4H                  ;0FCA1H 
    jmp  L_131                      ;0FCA4H 
L_85:
    lxi  H, 0F603H                  ;0FCA7H 
    mvi  C, 00H                     ;0FCAAH 
    mvi  M, 80H                     ;0FCACH 
    dcx  H                          ;0FCAEH 
    mvi  A, 55H                     ;0FCAFH 
    mov  M, A                       ;0FCB1H 
    dcx  H                          ;0FCB2H 
    mov  M, A                       ;0FCB3H 
    dcx  H                          ;0FCB4H 
    mov  M, A                       ;0FCB5H 
    lxi  H, 0F603H                  ;0FCB6H 
    cmp  M                          ;0FCB9H 
    jnz  L_86                       ;0FCBAH 
    dcx  H                          ;0FCBDH 
    cmp  M                          ;0FCBEH 
    jnz  L_86                       ;0FCBFH 
    dcx  H                          ;0FCC2H 
    cmp  M                          ;0FCC3H 
    jnz  L_86                       ;0FCC4H 
    lxi  H, 0F603H                  ;0FCC7H 
    mvi  M, 80H                     ;0FCCAH 
    dcx  H                          ;0FCCCH 
    mvi  A, 0AAH                    ;0FCCDH 
    mov  M, A                       ;0FCCFH 
    dcx  H                          ;0FCD0H 
    mov  M, A                       ;0FCD1H 
    dcx  H                          ;0FCD2H 
    mov  M, A                       ;0FCD3H 
    lxi  H, 0F603H                  ;0FCD4H 
    cmp  M                          ;0FCD7H 
    jnz  L_86                       ;0FCD8H 
    dcx  H                          ;0FCDBH 
    cmp  M                          ;0FCDCH 
    jnz  L_86                       ;0FCDDH 
    dcx  H                          ;0FCE0H 
    cmp  M                          ;0FCE1H 
    jnz  L_86                       ;0FCE2H 
    lxi  H, 0F603H                  ;0FCE5H 
    mvi  M, 0B9H                    ;0FCE8H 
    dcx  H                          ;0FCEAH 
    dcx  H                          ;0FCEBH 
    mov  A, M                       ;0FCECH 
    jnz  L_86                       ;0FCEDH 
    dcx  H                          ;0FCF0H 
    mov  A, M                       ;0FCF1H 
    jnz  L_86                       ;0FCF2H 
    lxi  H, 0F603H                  ;0FCF5H 
    lxi  D, 0F602H                  ;0FCF8H 
    mvi  M, 80H                     ;0FCFBH 
    mvi  A, 00H                     ;0FCFDH 
    stax D                          ;0FCFFH 
    ldax D                          ;0FD00H 
    jnz  L_86                       ;0FD01H 
    mvi  M, 01H                     ;0FD04H 
    ldax D                          ;0FD06H 
    cpi  01H                        ;0FD07H 
    jnz  L_86                       ;0FD09H 
    mvi  M, 03H                     ;0FD0CH 
    ldax D                          ;0FD0EH 
    cpi  03H                        ;0FD0FH 
    jnz  L_86                       ;0FD11H 
    mvi  M, 05H                     ;0FD14H 
    ldax D                          ;0FD16H 
    cpi  07H                        ;0FD17H 
    jnz  L_86                       ;0FD19H 
    mvi  M, 07H                     ;0FD1CH 
    ldax D                          ;0FD1EH 
    cpi  0FH                        ;0FD1FH 
    jnz  L_86                       ;0FD21H 
    mvi  M, 09H                     ;0FD24H 
    ldax D                          ;0FD26H 
    cpi  1FH                        ;0FD27H 
    jnz  L_86                       ;0FD29H 
    mvi  M, 0BH                     ;0FD2CH 
    ldax D                          ;0FD2EH 
    cpi  3FH                        ;0FD2FH 
    jnz  L_86                       ;0FD31H 
    mvi  M, 0DH                     ;0FD34H 
    ldax D                          ;0FD36H 
    cpi  7FH                        ;0FD37H 
    jnz  L_86                       ;0FD39H 
    mvi  M, 0FH                     ;0FD3CH 
    ldax D                          ;0FD3EH 
    cpi  0FFH                       ;0FD3FH 
    jnz  L_86                       ;0FD41H 
    lxi  H, 0FD50H                  ;0FD44H 
    lxi  D, Inversed_Text_Ok        ;0FD47H 
    lxi  B, 0E3C4H                  ;0FD4AH 
    jmp  L_131                      ;0FD4DH 
    lxi  H, L_89                    ;0FD50H 
    lxi  B, 0E4C4H                  ;0FD53H 
    jmp  L_131                      ;0FD56H 
L_86:
    lxi  H, L_87                    ;0FD59H 
    lxi  D, Inversed_Text_Bad       ;0FD5CH 
    lxi  B, 0E2C4H                  ;0FD5FH 
    jmp  L_131                      ;0FD62H 
L_87:
    lxi  H, L_88                    ;0FD65H 
    lxi  B, 0E3C4H                  ;0FD68H 
    jmp  L_131                      ;0FD6BH 
L_88:
    lxi  H, L_89                    ;0FD6EH 
    lxi  B, 0E4C4H                  ;0FD71H 
    jmp  L_131                      ;0FD74H 
L_89:
    lxi  B, 0120H                   ;0FD77H 
L_90:
    lxi  D, 0FFFFH                  ;0FD7AH 
L_91:
    dcx  D                          ;0FD7DH 
    mov  A, D                       ;0FD7EH 
    cpi  00H                        ;0FD7FH 
    jnz  L_91                       ;0FD81H 
    dcx  B                          ;0FD84H 
    mov  A, B                       ;0FD85H 
    cpi  00H                        ;0FD86H 
    jnz  L_90                       ;0FD88H 
    mvi  A, 06H                     ;0FD8BH 
    out  0F8H                       ;0FD8DH 
    lxi  H, 0C000H                  ;0FD8FH 
    mvi  C, 0FH                     ;0FD92H 
L_92:
    mvi  A, 01H                     ;0FD94H 
    out  0F9H                       ;0FD96H 
    mov  M, C                       ;0FD98H 
    mvi  A, 00H                     ;0FD99H 
    out  0F9H                       ;0FD9BH 
    mov  A, L                       ;0FD9DH 
    ani  07H                        ;0FD9EH 
    mvi  A, 01H                     ;0FDA0H 
    jnz  L_93                       ;0FDA2H 
    mvi  A, 0FFH                    ;0FDA5H 
L_93:
    mov  M, A                       ;0FDA7H 
    inx  H                          ;0FDA8H 
    mov  A, H                       ;0FDA9H 
    cpi  0F0H                       ;0FDAAH 
    jnz  L_92                       ;0FDACH 
    lxi  B, 0134H                   ;0FDAFH 
L_94:
    lxi  D, 0FFFFH                  ;0FDB2H 
L_95:
    dcx  D                          ;0FDB5H 
    mov  A, D                       ;0FDB6H 
    cpi  00H                        ;0FDB7H 
    jnz  L_95                       ;0FDB9H 
    dcx  B                          ;0FDBCH 
    mov  A, B                       ;0FDBDH 
    cpi  00H                        ;0FDBEH 
    jnz  L_94                       ;0FDC0H 
    mvi  C, 0F0H                    ;0FDC3H 
L_96:
    lxi  D, 0300H                   ;0FDC5H 
L_97:
    dcx  H                          ;0FDC8H 
    mvi  A, 01H                     ;0FDC9H 
    out  0F9H                       ;0FDCBH 
    mov  M, C                       ;0FDCDH 
    mvi  A, 00H                     ;0FDCEH 
    out  0F9H                       ;0FDD0H 
    mvi  M, 00H                     ;0FDD2H 
    dcx  D                          ;0FDD4H 
    mov  A, D                       ;0FDD5H 
    ora  E                          ;0FDD6H 
    jnz  L_97                       ;0FDD7H 
    mov  A, C                       ;0FDDAH 
    sui  10H                        ;0FDDBH 
    mov  C, A                       ;0FDDDH 
    jnz  L_96                       ;0FDDEH 
    lxi  H, 0E2E9H                  ;0FDE1H 
    lxi  D, Inversed_Text_Copyright ;0FDE4H 
L_98:
    mvi  B, 09H                     ;0FDE7H 
L_99:
    ldax D                          ;0FDE9H 
    mov  M, A                       ;0FDEAH 
    inx  D                          ;0FDEBH 
    inx  H                          ;0FDECH 
    dcr  B                          ;0FDEDH 
    mov  A, B                       ;0FDEEH 
    jnz  L_99                       ;0FDEFH 
    inr  H                          ;0FDF2H 
    mvi  L, 0E9H                    ;0FDF3H 
    mov  A, H                       ;0FDF5H 
    cpi  0EDH                       ;0FDF6H 
    jnz  L_98                       ;0FDF8H 
L_100:
    jmp  L_100                      ;0FDFBH 
L_101:
    lxi  D, 0F900H                  ;0FDFEH 
    stax D                          ;0FE01H 
    mvi  B, 80H                     ;0FE02H 
    mvi  C, 00H                     ;0FE04H 
L_102:
    lxi  D, 0000H                   ;0FE06H 
L_103:
    mov  A, B                       ;0FE09H 
    stax D                          ;0FE0AH 
    ldax D                          ;0FE0BH 
    xra  B                          ;0FE0CH 
    ora  C                          ;0FE0DH 
    mov  C, A                       ;0FE0EH 
    inx  D                          ;0FE0FH 
    mov  A, B                       ;0FE10H 
    cma                             ;0FE11H 
    mov  B, A                       ;0FE12H 
    mov  A, D                       ;0FE13H 
    cpi  0F0H                       ;0FE14H 
    jnz  L_103                      ;0FE16H 
    mov  A, B                       ;0FE19H 
    cma                             ;0FE1AH 
    rrc                             ;0FE1BH 
    mov  B, A                       ;0FE1CH 
    cpi  80H                        ;0FE1DH 
    jnz  L_102                      ;0FE1FH 
    lxi  D, 0F900H                  ;0FE22H 
    stax D                          ;0FE25H 
    pchl                            ;0FE26H 
L_104:
    inr  D                          ;0FE27H 
    inr  D                          ;0FE28H 
    inr  D                          ;0FE29H 
    inr  D                          ;0FE2AH 
    pchl                            ;0FE2BH 
L_105:
    mvi  B, 10H                     ;0FE2CH 
    mvi  A, 0FFH                    ;0FE2EH 
    stax D                          ;0FE30H 
    inr  E                          ;0FE31H 
    dcr  B                          ;0FE32H 
    mov  A, B                       ;0FE33H 
    jnz  0FE2EH                     ;0FE34H 
    inr  D                          ;0FE37H 
    dcr  E                          ;0FE38H 
    mvi  B, 10H                     ;0FE39H 
L_106:
    mvi  A, 0FFH                    ;0FE3BH 
    stax D                          ;0FE3DH 
    dcr  E                          ;0FE3EH 
    dcr  B                          ;0FE3FH 
    mov  A, B                       ;0FE40H 
    jnz  L_106                      ;0FE41H 
    inr  E                          ;0FE44H 
    inr  D                          ;0FE45H 
    inr  D                          ;0FE46H 
    inr  D                          ;0FE47H 
    pchl                            ;0FE48H 
L_107:
    mvi  L, 31H                     ;0FE49H 
L_108:
    mvi  A, 0FH                     ;0FE4BH 
L_109:
    mov  M, B                       ;0FE4DH 
    inr  L                          ;0FE4EH 
    dcr  A                          ;0FE4FH 
    jnz  L_109                      ;0FE50H 
    mvi  A, 11H                     ;0FE53H 
    add  L                          ;0FE55H 
    mov  L, A                       ;0FE56H 
    cpi  9FH                        ;0FE57H 
    jm   L_108                      ;0FE59H 
    mvi  A, 04H                     ;0FE5CH 
    add  H                          ;0FE5EH 
    mov  H, A                       ;0FE5FH 
    cpi  0EAH                       ;0FE60H 
    jm   L_107                      ;0FE62H 
    xchg                            ;0FE65H 
    pchl                            ;0FE66H 
L_110:
    xchg                            ;0FE67H 
    lxi  H, L_111                   ;0FE68H 
    jmp  L_122                      ;0FE6BH 
L_111:
    lxi  H, L_112                   ;0FE6EH 
    jmp  L_126                      ;0FE71H 
L_112:
    lxi  H, L_113                   ;0FE74H 
    jmp  L_126                      ;0FE77H 
L_113:
    xchg                            ;0FE7AH 
    pchl                            ;0FE7BH 
L_114:
    xchg                            ;0FE7CH 
    lxi  H, 0F403H                  ;0FE7DH 
    mvi  M, 07H                     ;0FE80H 
    lxi  H, L_115                   ;0FE82H 
    jmp  L_122                      ;0FE85H 
L_115:
    lxi  H, L_116                   ;0FE88H 
    jmp  L_122                      ;0FE8BH 
L_116:
    lxi  H, L_117                   ;0FE8EH 
    jmp  L_122                      ;0FE91H 
L_117:
    lxi  H, L_118                   ;0FE94H 
    jmp  L_122                      ;0FE97H 
L_118:
    lxi  H, L_119                   ;0FE9AH 
    jmp  L_122                      ;0FE9DH 
L_119:
    lxi  H, 0F403H                  ;0FEA0H 
    mvi  M, 06H                     ;0FEA3H 
    lxi  H, L_120                   ;0FEA5H 
    jmp  L_126                      ;0FEA8H 
L_120:
    lxi  H, L_121                   ;0FEABH 
    jmp  L_126                      ;0FEAEH 
L_121:
    xchg                            ;0FEB1H 
    pchl                            ;0FEB2H 
L_122:
    mvi  A, 0FFH                    ;0FEB3H 
L_123:
    ei                              ;0FEB5H 
    mov  B, A                       ;0FEB6H 
    mvi  A, 0FFH                    ;0FEB7H 
L_124:
    dcr  A                          ;0FEB9H 
    jnz  L_124                      ;0FEBAH 
    di                              ;0FEBDH 
    mvi  A, 90H                     ;0FEBEH 
L_125:
    dcr  A                          ;0FEC0H 
    jnz  L_125                      ;0FEC1H 
    mov  A, B                       ;0FEC4H 
    dcr  A                          ;0FEC5H 
    jnz  L_123                      ;0FEC6H 
    pchl                            ;0FEC9H 
L_126:
    mvi  A, 0FFH                    ;0FECAH 
L_127:
    mov  B, A                       ;0FECCH 
    mvi  A, 0FFH                    ;0FECDH 
L_128:
    dcr  A                          ;0FECFH 
    jnz  L_128                      ;0FED0H 
    mvi  A, 0FFH                    ;0FED3H 
L_129:
    dcr  A                          ;0FED5H 
    jnz  L_129                      ;0FED6H 
    mvi  A, 0FFH                    ;0FED9H 
L_130:
    dcr  A                          ;0FEDBH 
    jnz  L_130                      ;0FEDCH 
    mov  A, B                       ;0FEDFH 
    dcr  A                          ;0FEE0H 
    jnz  L_127                      ;0FEE1H 
    pchl                            ;0FEE4H 
L_131:
    ldax D                          ;0FEE5H 
    stax B                          ;0FEE6H 
    inx  D                          ;0FEE7H 
    inr  C                          ;0FEE8H 
    mvi  A, 0FH                     ;0FEE9H 
    ana  C                          ;0FEEBH 
    cpi  0DH                        ;0FEECH 
    jz   L_132                      ;0FEEEH 
    jmp  L_131                      ;0FEF1H 
L_132:
    pchl                            ;0FEF4H 
Inversed_Text_1:
    DB    11111111B                 ;0FEF5H '        '
    DB    11111011B                 ;0FEF6H '     0  '
    DB    11110011B                 ;0FEF7H '    00  '
    DB    11111011B                 ;0FEF8H '     0  '
    DB    11111011B                 ;0FEF9H '     0  '
    DB    11111011B                 ;0FEFAH '     0  '
    DB    11111011B                 ;0FEFBH '     0  '
    DB    11110001B                 ;0FEFCH '    000 '
    DB    11111111B                 ;0FEFDH '        '
Inversed_Text_2:
    DB    11111111B                 ;0FEFEH '        '
    DB    11000111B                 ;0FEFFH '  000   '
    DB    10111011B                 ;0FF00H ' 0   0  '
    DB    11111011B                 ;0FF01H '     0  '
    DB    11100111B                 ;0FF02H '   00   '
    DB    11011111B                 ;0FF03H '  0     '
    DB    10111111B                 ;0FF04H ' 0      '
    DB    10000011B                 ;0FF05H ' 00000  '
    DB    11111111B                 ;0FF06H '        '
Inversed_Text_3:
    DB    11111111B                 ;0FF07H '        '
    DB    10000011B                 ;0FF08H ' 00000  '
    DB    11111011B                 ;0FF09H '     0  '
    DB    11110111B                 ;0FF0AH '    0   '
    DB    11100111B                 ;0FF0BH '   00   '
    DB    11111011B                 ;0FF0CH '     0  '
    DB    10111011B                 ;0FF0DH ' 0   0  '
    DB    11000111B                 ;0FF0EH '  000   '
    DB    11111111B                 ;0FF0FH '        '
Inversed_Text_4:
    DB    11111111B                 ;0FF10H '        '
    DB    11110111B                 ;0FF11H '    0   '
    DB    11100111B                 ;0FF12H '   00   '
    DB    11010111B                 ;0FF13H '  0 0   '
    DB    10110111B                 ;0FF14H ' 0  0   '
    DB    10000011B                 ;0FF15H ' 00000  '
    DB    11110111B                 ;0FF16H '    0   '
    DB    11110111B                 ;0FF17H '    0   '
    DB    11111111B                 ;0FF18H '        '
Inversed_Text_Line:
    DB    11111111B                 ;0FF19H '                                '
    DB    11111011B                 ;0FF1AH '     0      000  0   0 00000    '
    DB    11111011B                 ;0FF1BH '     0       0   0   0 0        '
    DB    11111011B                 ;0FF1CH '     0       0   00  0 0        '
    DB    11111011B                 ;0FF1DH '     0       0   0 0 0 0000     '
    DB    11111011B                 ;0FF1EH '     0       0   0  00 0        '
    DB    11111011B                 ;0FF1FH '     0   0   0   0   0 0        '
    DB    11111000B                 ;0FF20H '     00000  000  0   0 00000    '
    DB    11111111B                 ;0FF21H '                                '
    DB    11111111B                 ;0FF22H 
    DB    11110001B                 ;0FF23H 
    DB    11111011B                 ;0FF24H 
    DB    11111011B                 ;0FF25H 
    DB    11111011B                 ;0FF26H 
    DB    11111011B                 ;0FF27H 
    DB    10111011B                 ;0FF28H 
    DB    00110001B                 ;0FF29H 
    DB    11111111B                 ;0FF2AH 
    DB    11111111B                 ;0FF2BH 
    DB    10111010B                 ;0FF2CH 
    DB    10111010B                 ;0FF2DH 
    DB    10011010B                 ;0FF2EH 
    DB    10101010B                 ;0FF2FH 
    DB    10110010B                 ;0FF30H 
    DB    10111010B                 ;0FF31H 
    DB    10111010B                 ;0FF32H 
    DB    11111111B                 ;0FF33H 
    DB    11111111B                 ;0FF34H 
    DB    00001111B                 ;0FF35H 
    DB    11111111B                 ;0FF36H 
    DB    11111111B                 ;0FF37H 
    DB    00011111B                 ;0FF38H 
    DB    11111111B                 ;0FF39H 
    DB    11111111B                 ;0FF3AH 
    DB    00001111B                 ;0FF3BH 
    DB    11111111B                 ;0FF3CH 
Inversed_Text_Port:
    DB    11111111B                 ;0FF3DH '                                ' 
    DB    11111000B                 ;0FF3EH '     0000   000  0000  00000    ' 
    DB    11111011B                 ;0FF3FH '     0   0 0   0 0   0   0      ' 
    DB    11111011B                 ;0FF40H '     0   0 0   0 0   0   0      ' 
    DB    11111000B                 ;0FF41H '     0000  0   0 0000    0      ' 
    DB    11111011B                 ;0FF42H '     0     0   0 0  0    0      ' 
    DB    11111011B                 ;0FF43H '     0     0   0 0   0   0      ' 
    DB    11111011B                 ;0FF44H '     0      000  0    0  0      ' 
    DB    11111111B                 ;0FF45H '                                ' 
    DB    11111111B                 ;0FF46H 
    DB    01110001B                 ;0FF47H 
    DB    10101110B                 ;0FF48H 
    DB    10101110B                 ;0FF49H 
    DB    01101110B                 ;0FF4AH 
    DB    11101110B                 ;0FF4BH 
    DB    11101110B                 ;0FF4CH 
    DB    11110001B                 ;0FF4DH 
    DB    11111111B                 ;0FF4EH 
    DB    11111111B                 ;0FF4FH 
    DB    10000110B                 ;0FF50H 
    DB    10111011B                 ;0FF51H 
    DB    10111011B                 ;0FF52H 
    DB    10000111B                 ;0FF53H 
    DB    10101111B                 ;0FF54H 
    DB    10110111B                 ;0FF55H 
    DB    10111011B                 ;0FF56H 
    DB    11111111B                 ;0FF57H 
    DB    11111111B                 ;0FF58H 
    DB    00001111B                 ;0FF59H 
    DB    10111111B                 ;0FF5AH 
    DB    10111111B                 ;0FF5BH 
    DB    10111111B                 ;0FF5CH 
    DB    10111111B                 ;0FF5DH 
    DB    10111111B                 ;0FF5EH 
    DB    10111111B                 ;0FF5FH 
    DB    11111111B                 ;0FF60H 
Inversed_Text_Ok:
    DB    11111111B                 ;0FF61H '                ' 
    DB    11110001B                 ;0FF62H '    000  0   0  ' 
    DB    11101110B                 ;0FF63H '   0   0 0  0   ' 
    DB    11101110B                 ;0FF64H '   0   0 0 0    ' 
    DB    11101110B                 ;0FF65H '   0   0 00     ' 
    DB    11101110B                 ;0FF66H '   0   0 0 0    ' 
    DB    11101110B                 ;0FF67H '   0   0 0  0   ' 
    DB    11110001B                 ;0FF68H '    000  0   0  ' 
    DB    11111111B                 ;0FF69H '                ' 
    DB    11111111B                 ;0FF6AH 
    DB    10111011B                 ;0FF6BH 
    DB    10110111B                 ;0FF6CH 
    DB    10101111B                 ;0FF6DH 
    DB    10011111B                 ;0FF6EH 
    DB    10101111B                 ;0FF6FH 
    DB    10110111B                 ;0FF70H 
    DB    10111011B                 ;0FF71H 
    DB    11111111B                 ;0FF72H 
Inversed_Text_Bad:
    DB    11111111B                 ;0FF73H '                        ' 
    DB    11111000B                 ;0FF74H '     0000  00000 0000   ' 
    DB    11111011B                 ;0FF75H '     0   0 0      0  0  ' 
    DB    11111011B                 ;0FF76H '     0   0 0      0  0  ' 
    DB    11111000B                 ;0FF77H '     0000  0000   0  0  ' 
    DB    11111011B                 ;0FF78H '     0   0 0      0  0  ' 
    DB    11111011B                 ;0FF79H '     0   0 0      0  0  ' 
    DB    11111000B                 ;0FF7AH '     0000  00000 0000   ' 
    DB    11111111B                 ;0FF7BH '                        ' 
    DB    11111111B                 ;0FF7CH 
    DB    01100000B                 ;0FF7DH 
    DB    10101111B                 ;0FF7EH 
    DB    10101111B                 ;0FF7FH 
    DB    01100001B                 ;0FF80H 
    DB    10101111B                 ;0FF81H 
    DB    10101111B                 ;0FF82H 
    DB    01100000B                 ;0FF83H 
    DB    11111111B                 ;0FF84H 
    DB    11111111B                 ;0FF85H 
    DB    10000111B                 ;0FF86H 
    DB    11011011B                 ;0FF87H 
    DB    11011011B                 ;0FF88H 
    DB    11011011B                 ;0FF89H 
    DB    11011011B                 ;0FF8AH 
    DB    11011011B                 ;0FF8BH 
    DB    10000111B                 ;0FF8CH 
    DB    11111111B                 ;0FF8DH 
Inversed_Text_Copyright:
    DB    11111111B                 ;0FF8EH '                                                                                        '
    DB    11111100B                 ;0FF8FH '      000                                              00  0   0 0000  0000    00       '
    DB    11111011B                 ;0FF90H '     0   0  00  000  0  0 000  000  00  0  0 00000     00  00 00 0   0 0   0   00       '
    DB    11111011B                 ;0FF91H '     0     0  0 0  0 0  0 0  0  0  0  0 0  0 0 0 0      0  0 0 0 0   0 0   0    0       '
    DB    11111011B                 ;0FF92H '     0     0  0 0  0 0  0 0  0  0  0    0  0   0       0   0 0 0 0000  0000    0        '
    DB    11111011B                 ;0FF93H '     0     0  0 000   00  000   0  0 00 0000   0           0   0 0   0 0   0            '
    DB    11111011B                 ;0FF94H '     0   0 0  0 0     0   0 0   0  0  0 0  0   0           0   0 0   0 0   0            '
    DB    11111100B                 ;0FF95H '      000   00  0    0    0  0 000  00  0  0   0           0   0 0000  0000             '
    DB    11111111B                 ;0FF96H '                                                                                        '
    DB    11111111B                 ;0FF97H 
    DB    01111111B                 ;0FF98H 
    DB    10110011B                 ;0FF99H 
    DB    11101101B                 ;0FF9AH 
    DB    11101101B                 ;0FF9BH 
    DB    11101101B                 ;0FF9CH 
    DB    10101101B                 ;0FF9DH 
    DB    01110011B                 ;0FF9EH 
    DB    11111111B                 ;0FF9FH 
    DB    11111111B                 ;0FFA0H 
    DB    11111111B                 ;0FFA1H 
    DB    00011011B                 ;0FFA2H 
    DB    01101011B                 ;0FFA3H 
    DB    01101011B                 ;0FFA4H 
    DB    00011100B                 ;0FFA5H 
    DB    01111101B                 ;0FFA6H 
    DB    01111011B                 ;0FFA7H 
    DB    11111111B                 ;0FFA8H 
    DB    11111111B                 ;0FFA9H 
    DB    11111111B                 ;0FFAAH 
    DB    01000110B                 ;0FFABH 
    DB    01011011B                 ;0FFACH 
    DB    01011011B                 ;0FFADH 
    DB    11000111B                 ;0FFAEH 
    DB    11010111B                 ;0FFAFH 
    DB    11011010B                 ;0FFB0H 
    DB    11111111B                 ;0FFB1H 
    DB    11111111B                 ;0FFB2H 
    DB    11111111B                 ;0FFB3H 
    DB    00110011B                 ;0FFB4H 
    DB    01101101B                 ;0FFB5H 
    DB    01101111B                 ;0FFB6H 
    DB    01101001B                 ;0FFB7H 
    DB    01101101B                 ;0FFB8H 
    DB    00110011B                 ;0FFB9H 
    DB    11111111B                 ;0FFBAH 
    DB    11111111B                 ;0FFBBH 
    DB    11111111B                 ;0FFBCH 
    DB    01101000B                 ;0FFBDH 
    DB    01101010B                 ;0FFBEH 
    DB    01101110B                 ;0FFBFH 
    DB    00001110B                 ;0FFC0H 
    DB    01101110B                 ;0FFC1H 
    DB    01101110B                 ;0FFC2H 
    DB    11111111B                 ;0FFC3H 
    DB    11111111B                 ;0FFC4H 
    DB    11111110B                 ;0FFC5H 
    DB    00111110B                 ;0FFC6H 
    DB    10111111B                 ;0FFC7H 
    DB    11111110B                 ;0FFC8H 
    DB    11111111B                 ;0FFC9H 
    DB    11111111B                 ;0FFCAH 
    DB    11111111B                 ;0FFCBH 
    DB    11111111B                 ;0FFCCH 
    DB    11111111B                 ;0FFCDH 
    DB    01101110B                 ;0FFCEH 
    DB    01100100B                 ;0FFCFH 
    DB    01101010B                 ;0FFD0H 
    DB    11101010B                 ;0FFD1H 
    DB    11101110B                 ;0FFD2H 
    DB    11101110B                 ;0FFD3H 
    DB    11101110B                 ;0FFD4H 
    DB    11111111B                 ;0FFD5H 
    DB    11111111B                 ;0FFD6H 
    DB    10000110B                 ;0FFD7H 
    DB    10111010B                 ;0FFD8H 
    DB    10111010B                 ;0FFD9H 
    DB    10000110B                 ;0FFDAH 
    DB    10111010B                 ;0FFDBH 
    DB    10111010B                 ;0FFDCH 
    DB    10000110B                 ;0FFDDH 
    DB    11111111B                 ;0FFDEH 
    DB    11111111B                 ;0FFDFH 
    DB    00011110B                 ;0FFE0H 
    DB    11101110B                 ;0FFE1H 
    DB    11101111B                 ;0FFE2H 
    DB    00011110B                 ;0FFE3H 
    DB    11101111B                 ;0FFE4H 
    DB    11101111B                 ;0FFE5H 
    DB    00011111B                 ;0FFE6H 
    DB    11111111B                 ;0FFE7H 
    DB    11111111B                 ;0FFE8H 
    DB    01111111B                 ;0FFE9H 
    DB    01111111B                 ;0FFEAH 
    DB    01111111B                 ;0FFEBH 
    DB    11111111B                 ;0FFECH 
    DB    11111111B                 ;0FFEDH 
    DB    11111111B                 ;0FFEEH 
    DB    11111111B                 ;0FFEFH 
    DB    11111111B                 ;0FFF0H 
Data:
    DB    11111111B                 ;0FFF1H 
    DB    11111111B                 ;0FFF2H 
    DB    11111111B                 ;0FFF3H 
    DB    01101101B                 ;0FFF4H 
    DB    01101001B                 ;0FFF5H 
    DB    01100110B                 ;0FFF6H 
    DB    01110100B                 ;0FFF7H 
    DB    01100001B                 ;0FFF8H 
    DB    01101000B                 ;0FFF9H 
    DB    01101111B                 ;0FFFAH 
    DB    01110111B                 ;0FFFBH 
    DB    00100000B                 ;0FFFCH 
    DB    01100010B                 ;0FFFDH 
    DB    00101110B                 ;0FFFEH 
    DB    01100010B                 ;0FFFFH 
