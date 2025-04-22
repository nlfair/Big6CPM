;*******************************************************************************
; TEXT.ASM
;
; strings used for the program
;*******************************************************************************

CR: EQU     0DH     ; ASCII Carriage Return
LF: EQU     0AH     ; ASCII Line Feed

DATA:   DM "Hello World!$", CR,LF    ; $string with /r/n

; info for 80 columns
;       "         1         2         3         4         5         6         7         8"
;       "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

t_intro:
    DM  "                                      Big6",CR,LF  ; <text>,<newline>
    DM	"                               Creative Computing",CR,LF
    DM	"                             Morristown, New Jersey",CR,LF
    DM  CR,LF
    DM  CR,LF
    DM  "  This program is a dice wheel game in which you can bet on any number between",CR,LF
    DM  "one and six and up to three numbers.",CR,LF
    DM	"  The house limit is from $1 to $500!!",CR,LF
    DM	"  To end this program type the word 'stop'.",CR,LF
    DM	"  Good luck!"
    DM      CR,LF
    DM      CR,LF
    DM      CR,LF,0            ; newlines, null

; prompts **********************************************************************
t_number_prompt:
    DM  "What number do you want to bet on?",CR,LF,0

t_wager_prompt:
    DM	"Wager",CR,LF,0

t_bet_prompt:
    DM	"How many numbers do you want to bet on?",CR,LF,0

t_wager_two:
    DM	"Wager on both",CR,LF,0

t_wager_three:
    DM	"Wager on each of the three",CR,LF,0

t_one_number_prompt:
    DM	"Enter your number",CR,LF,0

t_first_number_prompt:
    DM	"Enter your first number",CR,LF,0

t_second_number_prompt:
    DM	"Enter your second number",CR,LF,0

t_third_number_prompt:
    DM	"Enter your third number",CR,LF,0

; win/lose *********************************************************************
t_lucky_numbers:
    DM	"The lucky numbers are: ",0

t_you_lose_alert:
    DM	"You lose on: ",0

t_you_win_alert:
    DM	"You win ",0

t_times_alert:
    DM	" times on: ",0

t_even_alert:
    DM	"You're even!!",CR,LF,0

t_ahead_alert:
    DM	"You're ahead $",0

t_behind_alert:
    DM	"You're behind $",0

t_cash_out:
    DM	CR,LF,CR,LF,"So you want to cash out your chips, I see!!!",CR,LF,0

t_no_money_alert:
    DM	"You didn't win any money, but I'm willing to call it even!!",CR,LF,0

t_winnings:
    DM	"You won exactly $",0

t_not_bad:
    DM	"!!  Not bad!!!",CR,LF,0

; alerts ***********************************************************************
t_bad_count_alert:
    DM	"You cannot bet on less than one or more than three numbers.",CR,LF,CR,LF,0

t_bad_bet_alert:
    DM	"You can only bet on an integer from one to six.",CR,LF,CR,LF,0

t_limit_alert:
    DM	"The house limit is from $1 to $500.",CR,LF,CR,LF,0

t_nan:
    DM  "You have to enter a number or 'stop'.",CR,LF,CR, LF, 0 ; Not A Number

; misc. ************************************************************************
t_stop:
    DM	4, "stop"       ; stop command text prefixed with length for easier compare

t_newline:
    DM  CR, LF, 0       ; crlf for new line

; TODO: remove debugging messages
t_you_entered:
    DM  "You entered: $"

t_one:
    DM	"One",CR,LF,0

t_two:
    DM	"Two",CR,LF,0

t_three:
    DM	"Three",CR,LF,0

t_four:
    DM	"Four",CR,LF,0

t_five:
    DM	"Five",CR,LF,0

t_six:
    DM	"Six",CR,LF,0

t_entered:
    DM	"END OF TEXT VALUES",0

t_test:
    DM  1, "CR,LF"

t_gogo:
    DM  4, "gogo"   ; opposite of stop

t_match:
    DM  "MATCH!", 0

t_nomatch:
    DM  "NOT A MATCH!", 0

t_blankline:
    DM  CR, LF, 0

t_pass:
    DM "Pass", CR, LF, 0

t_fail:
    DM "Fail", CR, LF, 0

t_check_range:
    DM "CHECK_RANGE:", CR, LF, 0

t_in_range:
    DM "In range", CR, LF, 0