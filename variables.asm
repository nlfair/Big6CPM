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
    DS      INPUT_BUFFSIZ       ; output buffer
    
OLD_SP:
    DW      0000H               ; old stack pointer

v_prompt:
    DW      0000H               ; pointer to prompt for GET_INT_IN_RANGE

v_error:
    DW      0000H               ; error message for GET_INT_IN_RANGE

v_lower:
    DW      0000H               ; lower value

v_upper:
    DW      0000H               ; upper value