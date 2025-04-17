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
    CALL    NULL_STRING_OUT

    ; todo: show winnings/losses (gosub 3360)

EXIT:
    ; end of program, return to CCP
    POP     HL      ; HL = original SP value
    LD      SP, HL  ; restore original SP

    ret           ; to the CCP

;*******************************************************************************
; Main program loop
;*******************************************************************************
MAIN_LOOP:
    ; get # of guesses
    LD      BC, 1                   ; lower range
    LD      HL, v_w_param_1
    LD      (HL), BC

    LD      BC, 3                   ; upper range
    LD      HL, v_w_param_2
    LD      (HL), BC

    LD      DE, t_bet_prompt        ; save prompt
    LD      HL, v_w_param_3
    LD      (HL), DE
    
    LD      DE, t_bad_count_alert   ; save error message
    LD      HL, v_w_param_4
    LD      (HL), DE
    
    CALL    GET_INT_IN_RANGE
    JR      NZ, IN_RANGE            ; if z = 1, "stop" was entered, we're done
    RET

IN_RANGE:
    ; debug ***********************************
    ; ; first byte
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE

    ; ; second byte
    ; POP     HL
    ; INC     HL
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE

    ; ; third byte
    ; POP     HL
    ; INC     HL
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE
    
    ; ; fourth byte
    ; POP     HL
    ; INC     HL
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE
    
    ; ; fifth byte
    ; POP     HL
    ; INC     HL
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE
    
    ; ; sixth byte
    ; POP     HL
    ; INC     HL
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE
    
    ; ; seventh byte
    ; POP     HL
    ; INC     HL
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE
    
    ; ; eighth byte
    ; POP     HL
    ; INC     HL
    ; LD      A, (HL) 
    ; PUSH    HL
    ; CALL    DUMPBYTE
    
    ; RET
    ; end debug *******************************

CHECK_GUESSES_RANGE:
    LD	    DE, HL          ; HL gets overwritten by CMP16, so lets swap
    LD      HL, 1
    CALL    CMP16
    JR      Z, ONE_GUESS    ; 1 is a match

    LD      HL, 2           ; check 2
    CALL    CMP16
    JR      Z, TWO_GUESSES  ; 2 is a match

    LD      HL, 3           ; check 3
    CALL    CMP16
    JR      Z, THREE_GUESSES    ; 3 is a match

    LD      HL, t_bad_count_alert
    CALL    NULL_STRING_OUT
    JMP      MAIN_LOOP

ONE_GUESS:
    ; get 1 guess
    LD  HL, t_number_prompt:
    CALL NULL_STRING_OUT
    ; todo: get number
    ; todo: get wager
    RET

TWO_GUESSES:
    ; get 2 guesses
    LD  HL, t_first_number_prompt
    CALL NULL_STRING_OUT
    ; todo: get 2 numbers
    ; todo: get wager
    RET

THREE_GUESSES:
    ; get 3 guesses
    LD  HL, t_three
    CALL NULL_STRING_OUT
    ; todo: get 3 numbers
    ; todo: get wager
    RET

    ; todo: generate numbers (gosub 1870)

    ; todo: compare and update winnings(gosub 2060)

    ; todo: tell player how they did (gosub 3260)

    JP      MAIN_LOOP;

    RET

SHOW_INSTRUCTIONS:
    ; show instructions
    LD      HL, t_intro
    CALL    NULL_STRING_OUT
    RET

; includes
; todo: fix why they utils has to be included last
    INCLUDE "text.asm"
    INCLUDE "variables.asm"
    INCLUDE "utils.asm"

; new stack at end of program
MY_SP:
    DS      256
    
