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

; parameters
v_w_param_1:
    DW      0000H

v_w_param_2:
    DW      0000H

v_w_param_3:
    DW      0000H

v_w_param_4:
    DW      0000H

; wagers
v_wager_1:
    DW      0000H

v_wager_2:
    DW      0000H

v_wager_3:
    DW      0000H

v_num_1:
    DB      00H

v_num_2:
    DB      00H

v_num_3:
    DB      00H
