;--------------------------------------;
;  Main                                ;
;--------------------------------------;

.code

; Initialize stack pointer
ldi 0xFF
lsp

infinite_loop:

; Increment count if SW1 is pressed
in 0xF8
and mask_sw1
cmp mask_sw1
jpb _sw1_not_pressed
call inc_count
_sw1_not_pressed:

; Decrement count if SW2 is pressed
in 0xF8
and mask_sw2
cmp mask_sw2
jpb _sw2_not_pressed
call dec_count
_sw2_not_pressed:

; Update display
ldi display_digits
add count
lia
out 0xF9

jmp infinite_loop

;--------------------------------------;
;  Subroutines                         ;
;--------------------------------------;

inc_count:
ldi 9
cmp count
jpa _inc
ldi 0
sta count
ret
_inc:
ldi 1
sta temp
lda count
add temp
sta count
ret

dec_count:
ldi 0
cmp count
jpb _dec
ldi 9
sta count
ret
_dec:
ldi 1
sta temp
lda count
sub temp
sta count
ret

;--------------------------------------;
;  Initialized variables               ;
;--------------------------------------;

.data

count: 0
temp: 0
mask_sw1: 0x01
mask_sw2: 0x10
display_digits: 0x3F 0x06 0x5B 0x4F 0x66
                0x6D 0x7D 0x07 0x7F 0x6F

end
