;
; utilities for the app
;

WRITE_CHR:  EQU 02H

;*******************************************************************************
; Output to console a string starting at the address in HL
;
; Parameters:
;   HL - Address of the null terminated string
;
; Registers Used:
;   A, C, E, HL
;*******************************************************************************
STRING_OUT:
    ; check for NULL terminator
    LD  A, (HL)     ; load character into A
    CP  0           ; check for NULL
    RET Z           ; NULL, get out

    ; output the character
    PUSH	HL          ; WRITE_CHR trashes HL
    LD  C, WRITE_CHR    ; write a character to console.  WRITE_CHR also trashes C
    LD  E, (HL)         ; copy character to E
    CALL    BIOS        ; print character, should be defined in main.asm

    ; move to next character and loop
    POP	HL
    INC HL              ; next character
    JR  STRING_OUT      ; loop
