;=======================================================================
;   MSC-8080/8085 support for FASMG 03.02.2016
;=======================================================================
element register
element B?   : register + 0000h  
element C?   : register + 0FF1h
element D?   : register + 0112h
element E?   : register + 0FF3h
element H?   : register + 0224h
element L?   : register + 0FF5h
element M?   : register + 0FF6h
element A?   : register + 0FF7h
element SP?  : register + 0F3Fh
element PSW? : register + 03FFh
;                          |||
;                          ||\- any 8-bit register operation
;                          |\-- any 16-bit operation, except push&pop
;                          \--- push&pop operations 
;-----------------------------------------------------------------------
condition_nz = 0 shl 3
condition_z  = 1 shl 3
condition_nc = 2 shl 3
condition_c  = 3 shl 3
condition_po = 4 shl 3
condition_pe = 5 shl 3
condition_p  = 6 shl 3
condition_m  = 7 shl 3
;-----------------------------------------------------------------------
macro regX name,param,disp
    name = 0Fh
    match param,x
        if param relativeto param element 1 & \
           param scale 0 = 0 & \
           param metadata 1 relativeto register
    		name = (param metadata 1 - register) \
    		        shr disp and 0Fh
        end if
    end match
    if name = 0Fh
       err "bad register"
    end if
end macro
;-----------------------------------------------------------------------
macro reg8 name,param
    regX name,param,0
end macro
;-----------------------------------------------------------------------
macro reg16 name,param
    regX name,param,4
end macro
;-----------------------------------------------------------------------
macro pushpop name,param
    regX name,param,8
end macro
;=======================================================================
irp <mnem,opcode>,XCHG?,0EBh,PCHL?,0E9h,XTHL?,0E3h,SPHL?,0F9h,\
                  RLC?, 007h,RRC?, 00Fh,RAL?, 017h,RAR?, 01Fh,\
                  DAA?, 027h,CMA?, 02Fh,STC?, 037h,CMC?, 03Fh,\
                  NOP?, 000h,RET?, 0C9h,RIM?, 020h,SIM?, 030h,\
                  HLT?, 076h,EI?,  0FBh,DI?,  0F3h
    macro mnem 
        db opcode
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,INX?,003h,DCX?,00Bh,DAD?,009h
    macro mnem r1
        reg16 dest,r1
        db dest shl 4 or opcode
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,STAX?,002h,LDAX?,00Ah
    macro mnem r1
        reg16 dest,r1
        if dest and 0Eh
            err "bad register pair"
        else
            db dest shl 4 or opcode
        end if
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,PUSH?,0C5h,POP?,0C1h
    macro mnem r1
        pushpop dest,r1
        db opcode or dest shl 4 
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,INR?,004h,DCR?,005h
    macro mnem r1 
        reg8 dest,r1
        db opcode or dest shl 3
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,ADD?,080h,ADC?,088h,SUB?,090h,SBB?,098h,\
                  ANA?,0A0h,XRA?,0A8h,ORA?,0B0h,CMP?,0B8h
    macro mnem r1 
        reg8 src,r1
        db opcode or src
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,CALL?,0CDh,SHLD?,022h,LHLD?,02Ah,\
                  JMP?, 0C3h,STA?, 032h,LDA?, 03Ah
    macro mnem addr 
        local value
        value = +addr
        db opcode
        dw value
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,condition>,JC?,condition_c,JNC?,condition_nc,\
                     JZ?,condition_z,JNZ?,condition_nz,\
                     JP?,condition_p,JPO?,condition_po,\
                     JM?,condition_m,JPE?,condition_pe
    macro mnem addr
        local value
        value = +addr
        db 0C2h or condition
        dw value
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,condition>,CC?,condition_c,CNC?,condition_nc,\
                     CZ?,condition_z,CNZ?,condition_nz,\
                     CP?,condition_p,CPO?,condition_po,\
                     CM?,condition_m,CPE?,condition_pe
    macro mnem addr
        local value
        value = +addr
        db 0C4h or condition
        dw value
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,condition>,RC?,condition_c,RNC?,condition_nc,\
                     RZ?,condition_z,RNZ?,condition_nz,\
                     RP?,condition_p,RPO?,condition_po,\
                     RM?,condition_m,RPE?,condition_pe
    macro mnem 
        db 0C0h or condition
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,ADI?,0C6h,ACI?,0CEh,SUI?,0D6h,SBI?,0DEh,\
                  ANI?,0E6h,XRI?,0EEh,ORI?,0F6h,CPI?,0FEh
    macro mnem imm 
        dw opcode or (imm) shl 8
    end macro
end irp
;-----------------------------------------------------------------------
irp <mnem,opcode>,IN?,0DBh,OUT?,0D3h
    macro mnem ioaddr 
        db opcode,ioaddr
    end macro
end irp
;-----------------------------------------------------------------------
macro LXI? r1,imm
    local value
    value = +imm
    reg16 dest,r1
    db 001h or dest shl 4
    dw value 
end macro    
;-----------------------------------------------------------------------
macro MVI? r1,imm
    reg8 dest,r1
    dw 006h or dest shl 3 or (imm) shl 8
end macro 
;-----------------------------------------------------------------------
macro MOV? r1,r2
    reg8 dest,r1
    reg8 src,r2
    if src = dest & dest = 6
        err "illegal registers combination"
    else
        db 040h or dest shl 3 or src
    end if
end macro 
;-----------------------------------------------------------------------
macro RST? imm 
    if imm>7 | imm<0
        err "value is out of range"
    end if
    db 0C7h or (imm) shl 3
end macro   
;=======================================================================
macro DS? num
    rb num
end macro
;=======================================================================
