;*******************************************************************************
; MAIN.ASM
;
; Main code for Big6 Program
;
; This is translation of the BASIC program Big6 from the book "More BASIC 
; Computer Games", edited by David H. AHL, and published by Workman Publishing 
; in 1980.
;*******************************************************************************

BDOS:           EQU 05H     ; BDOS entry address

WRITE_STR:      EQU 09H
READ_STR:       EQU 0AH

;*******************************************************************************
; Program entry/exit wrapper
;*******************************************************************************
    ORG 100H   ; start address

    ; save CP/M stack
	LD		HL, 0
	ADD		HL, SP          ; HL = SP
	LD		SP, MY_SP       ; use local stack area
    PUSH    HL              ; save original SP value

    ; show instructions
    CALL    SHOW_INSTRUCTIONS

    ; start game loop
    CALL    MAIN_LOOP

    ; show exit message
    LD      HL, t_cash_out
    CALL    STRING_OUT

    ; todo: show winnings/losses

EXIT:
    ; end of program, return to CCP
    POP     HL      ; HL = original SP value
    LD      SP, HL  ; restore original SP

    ret           ; to the CCP

;*******************************************************************************
; Main program loop
;*******************************************************************************
MAIN_LOOP:
    ; prompt for how many numbers
    LD	    HL, t_bet_prompt
    CALL    STRING_OUT

GET_NUMBERS:
    ; input number of guesses
    LD      DE, v_input     ; store input buffer address
    LD      A, 7            ; buffer size: # of characters + 1 to hoLD the size
    LD      (DE), A
    LD      C, READ_STR
    CALL    BDOS

    ; check for "stop"
    LD      DE, v_input + 1     ; second byte holds chars returned
    LD      HL, t_stop
    CALL    STRCMP
    JR      NZ, CONVERT_NUMBERS ; if z = 1, "stop" was entered, we're done
    RET
CONVERT_NUMBERS:
    LD      HL, t_nomatch   ; debugging
    CALL    STRING_OUT

    ; todo: check for number

    ; todo: get guesses

    ; todo: generate numbers

    ; todo: compare

    ; todo: update totals

    ; todo: tell player how they did

    ; todo: keep playing?

    ; todo: if playing, show rules?

    ; todo: if not playing, show exit message

    RET

SHOW_INSTRUCTIONS:
    ; show instructions
    LD      HL, t_intro
    CALL    STRING_OUT
    RET

SHOW_BYTES:
    ; show 8 bytes from DE
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    PUSH    DE              ; store input buffer
    LD      DE, HL          ; copy result
    LD      HL, v_output    ; put result into output
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    ; 1
    PUSH    DE              ; store input buffer position
    PUSH	HL              ; store output buffer position
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    LD      DE, HL          ; copy result
    POP     HL              ; get back positon in output buffer
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    ; 2
    PUSH    DE              ; store input buffer position
    PUSH	HL              ; store output buffer position
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    LD      DE, HL          ; copy result
    POP     HL              ; get back positon in output buffer
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    ; 3
    PUSH    DE              ; store input buffer position
    PUSH	HL              ; store output buffer position
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    LD      DE, HL          ; copy result
    POP     HL              ; get back positon in output buffer
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    ; 4
    PUSH    DE              ; store input buffer position
    PUSH	HL              ; store output buffer position
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    LD      DE, HL          ; copy result
    POP     HL              ; get back positon in output buffer
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    ; 5
    PUSH    DE              ; store input buffer position
    PUSH	HL              ; store output buffer position
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    LD      DE, HL          ; copy result
    POP     HL              ; get back positon in output buffer
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    ; 6
    PUSH    DE              ; store input buffer position
    PUSH	HL              ; store output buffer position
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    LD      DE, HL          ; copy result
    POP     HL              ; get back positon in output buffer
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    ; 7
    PUSH    DE              ; store input buffer position
    PUSH	HL              ; store output buffer position
    LD      A, (DE)         ; get character
    CALL    BN2HEX          ; get ASCII
    LD      DE, HL          ; copy result
    POP     HL              ; get back positon in output buffer
    LD      (HL), D
    INC     HL              ; next position
    LD      (HL), E
    INC     HL              ; next position
    LD      A, 32           ; add space
    LD      (HL), A         ; 
    INC     HL              ; next position
    POP     DE              ; get buffer back
    INC     DE              ; next character

    LD      A, 0            ; null to end string
    LD      (HL), A

    LD      HL, v_output
    CALL    STRING_OUT
    RET

; includes
    INCLUDE "utils.asm"
    INCLUDE "text.asm"
    INCLUDE "variables.asm"

; new stack at end of program
    DS      256
MY_SP:
    
