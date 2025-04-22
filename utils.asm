;*******************************************************************************
; UTILS.ASM
;
; utilities for the app
;*******************************************************************************
WRITE_CHR:  EQU 02H     ; BDOS write character entry point

;*******************************************************************************
; Convert ASCII string to binary
;
; From "Z80 Assembly Language Subroutines" by Lance A. Leventhal and Winthrop
;   Saville.
;
; Parameters:
;   HL - address of input buffer.  First byte is size of string
;
; Return:
;   HL -    binary value
;   Carry - set on error
;
; Registers Used:
;   AF, BC, DE, HL
;*******************************************************************************
DEC2BN:
    ; Initialize - save length, ;clear sign and value
    LD      A, (HL)
    LD      B, A
    INC     HL              ; point to byte after length
    SUB	    A
    LD      (NGFLAG), A     ; assume number is positive
    LD      DE, 0

    ; Check for empty buffer
    OR      B               ; is buffer length zero?
    JR      Z, EREXIT       ; yes, Exit with value = 0

    ; Check for minus or plus sign in front
INIT1:
    LD      A, (HL)         ; get first character
    CP      '-'             ; is it a minus sign?
    JR      NZ, PLUS        ; no, branch
    LD      A, 0FFH
    LD      (NGFLAG), A     ; yes, make sign of number negative
    JR      SKIP            ; Skip over plus section

PLUS:
    CP      '+'             ; is first character a plus sign?
    JR      NZ, CHKDIG      ; no, start conversion
SKIP:
    INC     HL              ; skip over the sign byte
    DEC     B               ; decrement count
    JR      Z, EREXIT       ; error EXit if only a sign in buffer

    ; conversion loop
    ; continue until the buffer is empty
    ; or a non-numeric character is found
CNVERT:
    LD      A, (HL)         ; get nEXt character
CHKDIG:
    SUB	    '0'
    JR      C, EREXIT       ; Error if < '0' (not a digit)
    CP	    9+1
    JR      NC, EREXIT      ; Error if > '9' (not a digit)
    LD      C, A            ; character is a digit, save it

    ; valid decimal so
    ;       value = value * 10
    ;             = value * (8 + 2)
    ;             = (value * 8) + (value * 2)
    PUSH    HL              ; save buffer pointer
    EX      DE, HL          ; HL = value
    ADD     HL, HL          ; * 2
    LD      E, L            ; Save timmes 2 in DE
    LD      D, H
    ADD     HL, HL          ; * 4
    ADD     HL, HL          ; * 8
    ADD     HL, DE          ; value = value * (8 + 2)

    ; Add in the nEXt digit
    ; value = value * digit
    LD      E, C            ; move nEXt digit to E
    LD      D, 0            ; high byte is 0
    ADD     HL, DE          ; ADD digit to value
    EX      DE, HL          ; DE = value
    POP     HL              ; point to nEXt character
    INC	    HL
    DJNZ    CNVERT          ; continue conversion

    ; conversion is complete, check sign
    EX      DE, HL          ; HL = value
    LD      A, (NGFLAG)
    OR      A
    JR      Z, OKEXIT       ; jump if the value has positive
    EX      DE, HL          ; else replace value with -value
    LD      HL, 0
    OR      A               ; clear carry
    SBC     HL, DE          ; subtract value from 0

    ; no errors, EXit with carry clear
OKEXIT:
    OR      A               ; clar carry
    RET

    ; An error.  Exit with Carry set
EREXIT:
    EX      DE, HL          ; HL = value
    SCF                     ; set carry to indicate error
    RET
        
    ;DATA
NGFLAG: 
    DS      1               ; sign of number



;*******************************************************************************
; Compare two strings
;
; This strings are a maximum of 255 bytes and are prepended with the size of the
; string.  If the two strings are identical through the length of the shorter, 
; the longer string is considered to be larger.
;
; From "Z80 Assembly Language Subroutines" by Lance A. Leventhal and Winthrop
;   Saville.
;
; Parameters:
;   HL - address of string 1
;   DE - address of string 2
;
; Return:
;   Z = 1 if strings are identical, 0 if they are not.
;   C = 1 if string 2 is larger than string 1, 0 if they are identical or 
;       string 1 is larger.
;
; Registers Used:
;   AF, BC, DE, HL
;*******************************************************************************
STRCMP:
    ; determine which string is shorter
    ; length of shorter = number of bytes to compare
    LD      A, (HL)     ; save length of string 1
    LD      (LENS1), A
    LD      A, (DE)     ; save length of string 2
    LD      (LENS2), A
    CP      (HL)        ; compare to length of string 1
    JR      C, BEGCMP   ; jump if string 2 is shorter
    LD      A, (HL)     ; else, string 1 is shorter

BEGCMP:
    OR      A           ; test length of shorter string
    JR      Z, CMPLEN   ; compare lengths
                        ; if length is zero
    LD      B, A        ; B = number of bytes to compare
    EX      DE, HL      ; DE = string 1
                        ; HL = string 2

CMPLP:
    INC     HL          ; increment to next bytes
    INC     DE
    LD      A, (DE)     ; get a byte of string 1
    CP      (HL)        ; compare to byte of string 2
    RET     NZ          ; return with flags set if bytes not equal
    DJNZ    CMPLP       ; continue through all bytes

    ; strings same through length of of shorter
    ; so use lengths to set flags
CMPLEN:
    LD      A, (LENS1)  ; compare lengths
    LD      HL, LENS2
    CP      (HL)
    RET                 ; return with flags set or cleared

    ; data
LENS1:  DS  1           ; length of string 1
LENS2:  DS  1           ; length of string 2



;*******************************************************************************
; Compare two 16-bit numbers
;
; From "Z80 Assembly Language Subroutines" by Lance A. Leventhal and Winthrop
;   Saville.
;
; Parameters:
;   L - low byte of minuend
;   H - high byte of minuend
;   E - low byte of subtrahend
;   D - high byte of subtrahend
;
; Return:
;   Z = 1 if numbers are equal
;
;   unsigned numbers:
;       C = 0 if HL > DE
;       C = 1 if HL < DE
;   signed numbers:
;       S = 0 if HL > DE
;       S = 1 if HL < DE
;
; Registers used:
;   A, HL
;*******************************************************************************
CMP16:
    ; OR	    A           ; clear carry
    ; SBC     HL,DE       ; subtract subtrahend from minuend
    ; RET     PO          ; return if no overflow
    ; LD      A, H        ; overflow - invert sign flag
    ; RRA                 ; save carry in bit 7
    ; XOR     01000000B   ; complement bit 6 (sign bit)
    ; SCF                 ; ensure a non-zero result
    ; ADC     A, A        ; restore carry, complemented sign
    ;                     ; zero flag = 0 for sure
    ; RET
    OR      A   ; clear carry
    SBC     HL, DE
    ADD     HL, DE
    RET

;*******************************************************************************
; Get a 16 bit integer and check that it is in the given range after.  Will 
; exit if user enters 'stop'.
;
; Parameters
;   v_w_param_1 - lower range
;   v_w_param_2 - upper range
;   v_w_param_3 - address holding prompt
;   v_w_param_4 - address holding error message
; Return
;   HL - the integer entered.
;   Z - set if user exited
;
; Registers used
;   B, C, DE, HL
;*******************************************************************************
GET_INT_IN_RANGE:
    ; LD  DE, v_input + 1 ;debug
    ; LD  A, D    ; debug
    ; CALL DUMPBYTE   ;debug
    ; LD  A, E    ; debug
    ; CALL DUMPBYTE   ;debug

    ; display prompt
    LD      HL, (v_w_param_3)
    CALL    NULL_STRING_OUT ; display prompt

    ; input number of guesses
    LD      DE, v_input     ; store input buffer address
    LD      A, 25           ; buffer size: # of characters + 1 to hold the size
    LD      (DE), A
    LD      C, READ_STR     ; BDOS read string function
    CALL    BDOS            ; read in the string

    ; echo guess to screen
    LD      HL, v_input + 1     ; second byte holds length
    CALL    LEN_STRING_OUT

    LD      HL, t_newline       ; print a newline
    CALL    NULL_STRING_OUT

    ; check for "stop"
    LD      DE, v_input + 1     ; second byte holds chars returned
    LD      HL, t_stop          ; check for 'stop'
    CALL    STRCMP
    RET     Z                   ; if z = 1, "stop" was entered, we're done

    CALL    CHECK_RANGE
    JR      NZ, GET_INT_IN_RANGE    ; not a number or not in range
    RET



;*******************************************************************************
; Check to see if the value in HL is a number and in range
;
; Parameters
;   v_w_param_1 - lower range
;   v_w_param_2 - upper range
;   v_w_param_4 - address holding error message
;
; Return
;   HL - the integer entered.
;   Z - set if a number and in range
;
; Registers Used
;   DE, HL
;*******************************************************************************
CHECK_RANGE:
    ; LD      DE, v_input + 1 ; debug
    ; CALL    SHOW_BYTES      ; debug
    ; RET                     ; debug

    ; LD      HL, t_check_range   ; debug
    ; CALL    NULL_STRING_OUT     ; debug

    ; try to convert to a number
    LD      HL, v_input + 1     ; size starts at second character
    CALL    DEC2BN
    JR      NC, CHECK_LOWER_RANGE     ; conversion succeeded

    LD      HL, t_nan           ; not a number, get the error message
    CALL    NULL_STRING_OUT
    ADD     A, 1                ; clear Z flag
    RET

CHECK_LOWER_RANGE:
    LD      DE, (v_w_param_1)   ; get lower range value
    PUSH    HL                  ; HL gets overwritten by CMP16
    CALL    CMP16
    POP     HL                  ; get converted value back off of stack

    JR      Z, CHECK_UPPER_RANGE    ; value = lower range
    JR      NC, CHECK_UPPER_RANGE   ; value > than lower range

    LD      HL, (v_w_param_4)   ;  too low, load error
    CALL    NULL_STRING_OUT     ; display error
    ADD     A, 1                ; clear Z flag
    RET

CHECK_UPPER_RANGE:
    LD      DE, (v_w_param_2)   ; get lower range value
    PUSH	HL
    CALL    CMP16
    POP     HL

    JR      Z, INT_IN_RANGE ; value = upper range
    JR      C, INT_IN_RANGE ; value < the upper range

    LD      HL, (v_w_param_4)   ; too high, load error
    CALL    NULL_STRING_OUT     ; display error
    ADD     A, 1                ; clear Z flag
    RET

INT_IN_RANGE:
    ; LD      HL, t_one       ; debug
    ; CALL    NULL_STRING_OUT ; debug
    LD      A, 1
    DEC     A
    RET



;*******************************************************************************
; Output to console a null terminated string starting at the address in HL
;
; Parameters:
;   HL - Address of the null terminated string
;
; Registers Used:
;   A, C, E, HL
;*******************************************************************************
NULL_STRING_OUT:
    ; check for NULL terminator
    LD      A, (HL)     ; load character into A
    CP      0           ; check for NULL
    RET     Z           ; NULl found, string is ended

    ; output the character
    PUSH	HL              ; WRITE_CHR overwrites HL
    LD      C, WRITE_CHR    ; write a character to console.  We have to load 
                            ; this every time because WRITE_CHR overwrites C
    LD      E, (HL)         ; copy character to E
    CALL    BDOS            ; print character, shouLD be defined in main.asm
    POP	    HL              ; restore HL register

    ; move to next character and loop
    INC     HL              ; next character
    JR      NULL_STRING_OUT ; loop



;*******************************************************************************
; Output to console a a length prepended string.  The maximum length is 255
; characters.
;
; Parameters:
;   HL - address of the length prepended string
;
; Registers Used:
;   B, C, E, HL
;*******************************************************************************
LEN_STRING_OUT:
    LD      B, (HL)         ; save len

LSO_LOOP:
    INC     HL              ; next position
    PUSH    B               ; B and HL are overwritten by WRITE_CHR
    PUSH    HL

    LD      C, WRITE_CHR    ; char output routine
    LD      E, (HL)         ; get character
    CALL    BDOS

    POP     HL              ; restore HL and B
    POP     B

    DJNZ    LSO_LOOP        ; loop if there are more

    RET



;*******************************************************************************
; Split up a delimited string
;
; Parameters:
;
;
; Registers Used:
;
;*******************************************************************************
SPLIT_STRING:
;todo: implement



;*******************************************************************************
;*******************************************************************************
; DEBUGGING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;*******************************************************************************
;*******************************************************************************
; TODO: Delete/Comment out debugging stuff

;*******************************************************************************
; Convert one byte to two ASCII characters
;
; From "Z80 Assembly Language Subroutines" by Lance A. Leventhal and Winthrop
;   Saville.
;
; Parameters:
;   A - byte to confert
;
; Return:
;   H - ASCII most significant digit
;   L - ASCII least significant digit
;
; Registers Used:
;   AF, B, HL
;*******************************************************************************
BN2HEX:
    ; convert high nibble
    LD      B, A        ; save original binary value
    AND     0F0H        ; get high nibble
    RRCA                ; move high nibble to low nibble
    RRCA
    RRCA
    RRCA
    CALL    NASCII      ; convert high nibble to ASCII
    LD      H, A        ; return high nibble in H

    ; convert low nibble
    LD      A, B
    AND     0FH         ; get low nibble
    CALL    NASCII      ; convert low nibble to ASCII
    LD      L, A        ; return low nibble in L
    RET

    ;***************************************************************************
    ; Convert a hexadecimal digit to ASCII
    ; 
    ; Parameters:
    ;   A - binary data in lower nibble
    ;
    ; Return:
    ;   A = ASCII character
    ;
    ; Registers used:
    ;   A, F
    ;***************************************************************************
NASCII:
    CP      10
    JR      C, NAS1     ; jump if hi8gh nibble < 10
    ADD     A, 7        ; else add 7 so after adding '0' the character will be
                        ; in 'A'..'F'
NAS1:
    ADD     A, '0'      ; add ASCII 0 to make a character
    RET



;*******************************************************************************
; Dump a byte to console as two characters with a trailing space
; This is quick and dirty for testing, I don't need it to be efficient
;
; Parameters
;   A - the byte to convert
;
; Registers used
;   A, HL
;*******************************************************************************
DUMPBYTE:
    CALL    BN2HEX          ; convert
    PUSH    HL              ; push result
    LD      A, H            ; byte 1
    LD      HL, d_output    ; load output buffer
    LD      (HL), A
    
    ; second byte
    POP     HL              ; pop result
    LD	    A, L            ; byte 2
    LD      HL, d_output+1  ; load output buffer
    LD      (HL), A

    ; space
    LD      A, 20H          ; space
    INC     HL              ; 
    LD      (HL), A
    
    ; output
    LD      HL, d_output
    CALL	NULL_STRING_OUT
    RET
d_output:
    DS      255                 ; output buffer



;*******************************************************************************
; Show 8 bytes at the given address
;
; Parameters:
;   DE - address of the 8 bytes to display
;
; Registers used
;   A, B, HL
;*******************************************************************************
SHOW_BYTES:
    ; LD  DE, v_input + 1 ;debug
    ; LD  A, D    ; debug
    ; CALL DUMPBYTE   ;debug
    ; LD  A, E    ; debug
    ; CALL DUMPBYTE   ;debug

    ; below works in main.asm, but not here
    ; LD  HL, t_one   ;debug
    ; CALL NULL_STRING_OUT;   debug
    ; LD  HL, t_you_win_alert   ; debug
    ; CALL    NULL_STRING_OUT;    debug

    ; LD  HL, t_one   ;debug
    ; CALL NULL_STRING_OUT;   debug

    ; what if I output a letter?
    ; LD      C, 2    ; debug
    ; LD      E, 'q'  ; debug
    ; CALL    5       ; debug
    
    ; LD  HL, t_you_win_alert   ; debug
    ; CALL    NULL_STRING_OUT;    debug

    LD      B, 8
SB_LOOP:
    PUSH    B       ; DUMPBYTE overwrites
    PUSH	DE      ; DUMPBYTE overwrites

    LD  A, (DE)
    CALL DUMPBYTE

    POP DE          ; restore
    INC DE          ; next byte

    POP B           ; restore
    DJNZ    SB_LOOP

    RET
