;*******************************************************************************
; UTILS.ASM
;
; utilities for the app
;*******************************************************************************

WRITE_CHR:  EQU 02H

;*******************************************************************************
; Output to console a null terminated string starting at the address in HL
;
; Parameters:
;   HL - Address of the null terminated string
;
; Registers Used:
;   A, C, E, HL
;*******************************************************************************
STRING_OUT:
    ; check for NULL terminator
    LD      A, (HL)     ; load character into A
    CP      0           ; check for NULL
    RET     Z           ; NULL, get out

    ; output the character
    PUSH	HL              ; WRITE_CHR trashes HL
    LD      C, WRITE_CHR    ; write a character to console.  WRITE_CHR also trashes C
    LD      E, (HL)         ; copy character to E
    CALL    BDOS            ; print character, shouLD be defined in main.asm

    ; move to nEXt character and loop
    POP	    HL
    INC     HL              ; nEXt character
    JR      STRING_OUT      ; loop



;*******************************************************************************
; Convert ASCII string to binary
;
; From "Z80 Assembly Language Subroutines" by Lance A. Leventhal and Winthrop
;   Saville.
;
; Parameters:
;   HL - address of input buffer.  First byte is size of string
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
    JR      Z, EREXIT       ; yes, EXit with value = 0

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
    sub	    '0'
    JR      C, EREXIT       ; ERRor if < '0' (not a digit)
    CP	    9+1
    JR      NC, EREXIT      ; ERRor if > '9' (not a digit)
    LD      C, a            ; character is a digit, save it

    ; valid decimal so
    ;       value = value * 10
    ;             = value * (8 + 2)
    ;             = (value * 8) + (value * 2)
    PUSH    HL              ; save buffer pointer
    EX      DE, HL          ; HL = value
    ADD     HL, HL          ; * 2
    LD      E, L            ; Save timmes 2 in DE
    LD      E, H
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
    LD      A, (de)     ; save length of string 2
    LD      (LENS2), A
    CP      (HL)        ; compare to length of string 1
    JR      C, BEGCMP   ; jump if string 2 is shorter
    LD      A, (HL)     ; else, string 1 is shorter

BEGCMP:
    OR      A           ; test length of shorter string
    JR      Z, CMPLEN   ; compare lengths
                        ; if length is zero
    LD      B, A        ; B = number of bytes to compare
    EX      DE, HL      ; de = string 1
                        ; HL = string 2

CMPLP:
    INC     HL          ; INCrement to nEXt bytes
    INC     DE
    LD      A, (de)     ; get a byte of string 1
    CP      (HL)        ; compare to byte of string 2
    RET     NZ          ; RETurn with flags set if bytes not equal
    DJNZ    CMPLP       ;continue through all bytes

    ; strings same through length of of shorter
    ; so use lengths to set flags
CMPLEN:
    LD      A, (LENS1)  ; compare lengths
    LD      HL, LENS2
    CP      (HL)
    RET                 ; RETurn with flags set or cleared

    ; data
LENS1:  DS  1           ; length of string 1
LENS2:  DS  1           ; length of string 2


;*******************************************************************************
; Convert one byte to two ASCII characters
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
