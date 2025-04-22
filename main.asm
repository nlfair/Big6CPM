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
READ_STR:       EQU 0AH



;*******************************************************************************
; Program entry/exit wrapper
;*******************************************************************************
    ORG 100H   ; start address

    ; save CP/M stack
	LD		HL, 0
	ADD		HL, SP          ; HL = SP
	LD		SP, STACK       ; use local stack area
    PUSH    HL              ; save original SP value in our stack

    ; show instructions
    ;CALL    SHOW_INSTRUCTIONS

    ; start game loop
    CALL    MAIN_LOOP
    ;LD  DE, t_cash_out  ; debug
    ;CALL    SHOW_BYTES  ; debug
    ;CALL DEBUG  ; debug
    ; LD      C, 2    ; debug
    ; LD      E, 'q'  ; debug
    ; CALL    5       ; debug

    ; this shows that two consecutive calls to NULL_STRING_OUT work
    ; LD  HL, t_one   ;debug
    ; CALL NULL_STRING_OUT;   debug
    ; LD  HL, t_you_win_alert   ; debug
    ; CALL    NULL_STRING_OUT;    debug

    ; show exit message
    ; LD      HL, t_cash_out
    ; CALL    NULL_STRING_OUT

    ; todo: show winnings/losses (gosub 3360)

    ; end of program, return to CCP
    POP     HL      ; get original SP value
    LD      SP, HL  ; restore original SP

    ret             ; to the CCP

DEBUG:
    LD      C, 2    ; debug
    LD      E, 'q'  ; debug
    CALL    5       ; debug
    ret             ; debug

;*******************************************************************************
; Main program loop
;*******************************************************************************
MAIN_LOOP:
    ; get # of guesses
    LD      BC, 1                   ; lower range
    LD      HL, v_w_param_1
    LD      (HL), C
    INC     HL
    LD      (HL), B

    LD      BC, 3                   ; upper range
    LD      HL, v_w_param_2
    LD      (HL), C
    INC     HL
    LD      (HL), B

    LD      BC, t_bet_prompt        ; save prompt
    LD      HL, v_w_param_3
    LD      (HL), C
    INC     HL
    LD      (HL), B
    
    LD      BC, t_bad_count_alert   ; save error message
    LD      HL, v_w_param_4
    LD      (HL), C
    INC     HL
    LD      (HL), B
    
    ; LD  BC, v_input + 1 ;debug
    ; LD  A, B    ; debug
    ; CALL DUMPBYTE   ;debug
    ; LD  A, C    ; debug
    ; CALL DUMPBYTE   ;debug

    CALL    GET_INT_IN_RANGE
    ;JR      NZ, GET_GUESSES            ; if z = 1, "stop" was entered, we're done
    RET

GET_GUESSES:
    LD	    D, H          ; HL gets overwritten by CMP16, so lets swap
    LD      E, L
    LD      HL, 1
    CALL    CMP16
    JR      Z, ONE_GUESS    ; 1 is a match

    LD      HL, 2           ; check 2
    CALL    CMP16
    JR      Z, TWO_GUESSES  ; 2 is a match

    LD      HL, 3           ; check 3
    CALL    CMP16
    JR      Z, THREE_GUESSES    ; 3 is a match

    ; just in case an out of range guess makes it through
    LD      HL, t_bad_count_alert
    CALL    NULL_STRING_OUT
    JMP      MAIN_LOOP

ONE_GUESS:
    LD  A, 1                    ; store number of guesses
    LD  (v_numbers), A
    
    ; get 1 guess
    LD  HL, t_number_prompt:
    CALL NULL_STRING_OUT
    ; todo: get number
    ; todo: get wager
    RET

TWO_GUESSES:
    LD  A, 2
    LD  (v_numbers), A
    
    ; get 2 guesses
    LD  HL, t_first_number_prompt
    CALL NULL_STRING_OUT
    ; todo: get 2 numbers
    ; todo: get wager
    RET

THREE_GUESSES:
    LD  A, 3
    LD  (v_numbers), A
    
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
; todo: fix why utils has to be last for it to work with variables.asm
    INCLUDE "text.asm"
    INCLUDE "variables.asm"
    INCLUDE "utils.asm"

; new stack at end of program
    DS      64
STACK:
    .END
    
