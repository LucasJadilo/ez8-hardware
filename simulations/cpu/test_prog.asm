.code

;------------------------------------------------------;
;  Data transfer                                       ;
;------------------------------------------------------;

lda data6   ; A = data6 = 0x12
            ; PC = 0x02
ldi data1   ; A = &data1 = 0x58
            ; PC = 0x04
sta data7   ; data7 = A = 0x58
            ; PC = 0x06
lia         ; A = *A = *0x58 = 0x34 (data1)
            ; PC = 0x07

;------------------------------------------------------;
;  Arithmetic and logic operations                     ;
;------------------------------------------------------;

not         ; A = ~A = ~0x34 = 0xCB
            ; PC = 0x08
and data2   ; A = A & data2 = 0xCB & 0x45 = 0x41
            ; PC = 0x0A
or data3    ; A = A | data3 = 0x41 | 0x56 = 0x57
            ; PC = 0x0C
xor data4   ; A = A ^ data4 = 0x57 ^ 0x67 = 0x30
            ; PC = 0x0E
shl         ; A = A << 1 = 0x30 << 1 = 0x60
            ; PC = 0x0F
shr         ; A = A >> 1 = 0x60 >> 1 = 0x30
            ; PC = 0x10
add data5   ; A = A + data5 = 0x30 + 0x78 = 0xA8
            ; PC = 0x12
sub data8   ; A = A - data8 = 0xA8 - 0x50 = 0x58
            ; PC = 0x14

;------------------------------------------------------;
;  Unconditional jump                                  ;
;------------------------------------------------------;

jmp jump1   ; Jump to `jump1`
            ; PC = 0x17
nop         ; Skip
jump1:

;------------------------------------------------------;
;  Jump if A = B                                       ;
;------------------------------------------------------;

cmp data0   ; R = A - data0 - 1 = 0x58 - 0x58 - 1 = 0xFF
            ; PC = 0x19
jpe jump2   ; Jump to `jump2` (A = B)
            ; PC = 0x1C
nop         ; Skip
jump2:
cmp data6   ; R = A - data6 - 1 = 0x58 - 0x12 - 1 = 0x45
            ; PC = 0x1E
jpe jump3   ; Don't jump (A > B)
            ; PC = 0x20
nop         ; PC = 0x21
jump3:
cmp data5   ; R = A - data5 - 1 = 0x58 - 0x78 - 1 = 0xDF
            ; PC = 0x23
jpe jump4   ; Don't jump (A < B)
            ; PC = 0x25
nop         ; PC = 0x26
jump4:

;------------------------------------------------------;
;  Jump if A > B                                       ;
;------------------------------------------------------;

cmp data0   ; R = A - data0 - 1 = 0x58 - 0x58 - 1 = 0xFF
            ; PC = 0x28
jpa jump5   ; Don't jump (A = B)
            ; PC = 0x2A
nop         ; PC = 0x2B
jump5:
cmp data6   ; R = A - data6 - 1 = 0x58 - 0x12 - 1 = 0x45
            ; PC = 0x2D
jpa jump6   ; Jump to `jump6` (A > B)
            ; PC = 0x30
nop         ; Skip
jump6:
cmp data5   ; R = A - data5 - 1 = 0x58 - 0x78 - 1 = 0xDF
            ; PC = 0x32
jpa jump7   ; Don't jump (A < B)
            ; PC = 0x34
nop         ; PC = 0x35
jump7:

;------------------------------------------------------;
;  Jump if A < B                                       ;
;------------------------------------------------------;

cmp data0   ; R = A - data0 - 1 = 0x58 - 0x58 - 1 = 0xFF
            ; PC = 0x37
jpb jump8   ; Don't jump (A = B)
            ; PC = 0x39
nop         ; PC = 0x3A
jump8:
cmp data6   ; R = A - data6 - 1 = 0x58 - 0x12 - 1 = 0x45
            ; PC = 0x3C
jpb jump9   ; Don't jump (A > B)
            ; PC = 0x3E
nop         ; PC = 0x3F
jump9:
cmp data5   ; R = A - data5 - 1 = 0x58 - 0x78 - 1 = 0xDF
            ; PC = 0x41
jpb jump10  ; Jump to `jump10` (A < B)
            ; PC = 0x44
nop         ; Skip
jump10:

;------------------------------------------------------;
;  Stack operations                                    ;
;------------------------------------------------------;

ldi 0xFF    ; A = 0xFF
            ; PC = 0x46
lsp         ; SP = A = 0xFF
            ; PC = 0x47
ldi 0x11    ; A = 0x11
            ; PC = 0x49
push        ; *SP = A -> *0xFF = 0x11
            ; SP = SP - 1 = 0xFF - 1 = 0xFE
            ; PC = 0x4A
call func   ; Jump to `func`
            ; *SP = PC -> *0xFE = 0x4C
            ; SP = SP - 1 = 0xFE - 1 = 0xFD
            ; PC = 0x4E
pop         ; SP = SP + 1 = 0xFE + 1 = 0xFF
            ; A = *SP = *0xFF = 0x11
            ; PC = 0x4D
halt        ; Halt CPU, end of program

;------------------------------------------------------;
;  Subroutine (stack and I/O operations)               ;
;------------------------------------------------------;

func:
out 0xF9    ; *0xF9 (IO1) = A = 0x11
            ; PC = 0x50
ldi 0xAA    ; A = 0xAA
            ; PC = 0x52
in 0xF9     ; A = *0xF9 (IO1) = 0x11
            ; PC = 0x54
lda 0x01    ; A = *0x01 = 0x5D (&data6)
            ; PC = 0x56
ret         ; Return to call
            ; SP = SP + 1 = 0xFD + 1 = 0xFE
            ; PC = *SP = *0xFE = 0x4C

;------------------------------------------------------;
;  Initialized variables                               ;
;------------------------------------------------------;

.data

data0: 0x58
data1: 0x34
data2: 0x45
data3: 0x56
data4: 0x67
data5: 0x78
data6: 0x12
data7: 0x23
data8: 0x50

end
