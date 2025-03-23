ORG 0100H   ; start address

;CP/M Entry Points
WRITE_STR:      EQU 09H
BIOS:           EQU 05H

    ; save CP/M stack
    ; todo

    PUSH    AF
    PUSH	BC
    PUSH    DE
    PUSH    HL

    ; show instructions
    CALL    SHOW_INSTRUCTIONS

    ; start game loop
    CALL    MAIN_LOOP

    ; show exit message
    LD  HL, t_cash_out
    CALL    STRING_OUT

    ; show winnings/losses
    ; todo

    POP	HL
    POP DE
    POP BC
    POP AF

    ; restore CP/M stack
    ; todo

    RET

MAIN_LOOP:
    ; run game
    ; todo

    RET

SHOW_INSTRUCTIONS:
    ; show instructions
    LD  HL, t_intro
    CALL    STRING_OUT
    RET

; includes
    INCLUDE "utils.asm"
    INCLUDE "text.asm"
