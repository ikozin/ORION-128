include "8085.inc"

ORG 0F800H
StartCode:
    jmp StartCode                   ;0F800H 
