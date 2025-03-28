;*******************************************************************************
; VARIABLES.ASM
;
; Variables and related constants used by the application
;*******************************************************************************

; other constants
INPUT_BUFFSIZ   EQU 255         ; number of bytes to read + max size + chars returned

; variables
v_winnings:
    DW      00H                 ; how much player won, two bytes signed

v_input:
    DS      INPUT_BUFFSIZ       ; input buffer

v_output:
    DS      255                 ; output buffer
    
OLD_SP:
    DW      0000H               ; old stack pointer
