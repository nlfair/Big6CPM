;*******************************************************************************
; VARIABLES.ASM
;
; Variables and related constants used by the application
;*******************************************************************************

; other constants
INPUT_BUFFSIZ   EQU 255         ; number of bytes to read + max size + chars returned

;*******************************************************************************
; global variables
;*******************************************************************************
v_winnings:
    DW      0000H               ; how much player won, two bytes, signed

v_input:
    DS      INPUT_BUFFSIZ       ; input buffer

v_output:
    DS      INPUT_BUFFSIZ       ; output buffer

v_wager_1:
    DW      0000H   ; wager 1

v_wager_2:
    DW      0000H   ; wager 2

v_wager_3:
    DW      0000H   ; wager 3

v_numbers:
    DB      00H     ; how many numbers user chose

v_num_1:
    DB      00H     ; user number 1

v_num_2:
    DB      00H     ; user number 2

v_num_3:
    DB      00H     ; user number 3

OLD_SP:
    DW      0000H               ; old stack pointer

;*******************************************************************************
; parameters for calling functions or returning values
;*******************************************************************************
v_w_param_1:
    DW      0000H

v_w_param_2:
    DW      0000H

v_w_param_3:
    DW      0000H

v_w_param_4:
    DW      0000H
