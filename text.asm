; strings used for the program
CR:     EQU     0DH     ; ASCII Carriage Return
LF:     EQU     0AH     ; ASCII Line Feed

DATA:   DB "Hello World!$", CR,LF    ; $string with /r/n

; info for 80 columns
;DB  "         1         2         3         4         5         6         7         8"
;DB  "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

t_intro:
        DB  "                                      Big6",CR,LF  ; <text>,<newline>
        DB	"                               Creative Computing",CR,LF
        DB	"                             Morristown, New Jersey",CR,LF
        DB  CR,LF
        DB  CR,LF
        DB  "  This program is a dice wheel game in which you can bet on any number between",CR,LF
        DB  "one and six and up to three numbers.",CR,LF
        DB	"  The house limit is from $1 to $500!!",CR,LF
        DB	"  To end this program type the word 'stop'.",CR,LF
        DB	"  Good luck!"
        DB      CR,LF
        DB      CR,LF
        DB      CR,LF,0            ; newlines, null

t_bad_count:
        DB	"You cannot bet on less than one or more than three numbers.",CR,LF,0

t_number:
        DB  "What number?"

t_integer:
        DB  "You can only bet on an integer from one to six.",CR,LF,0

t_wager:
        DB	"Wager",CR,LF,0

t_bet_count:
        DB	"How many numbers do you want to bet on?",CR,LF,0

t_limit:
        DB	"The house limit is from $1 to $500.",CR,LF,0

t_wager_two:
        DB	"Wager on both",CR,LF,0

t_wager_three:
        DB	"Wager on each of the three",CR,LF,0

t_one_number:
        DB	"Enter your number",CR,LF,0

t_first_number:
        DB	"Enter your first number",CR,LF,0

t_second_number:
        DB	"Enter your second number",CR,LF,0

t_third_number:
        DB	"Enter your third number",CR,LF,0

t_bad_bet:
        DB	"You can only bet on an integer from one to six.",CR,LF,0

t_lucky_numbers:
        DB	"The lucky numbers are: ",0

t_you_lose:
        DB	"You lose on: ",0

t_you_win:
        DB	"You win ",0

t_times:
        DB	" times on: ",0

t_even:
        DB	"You're even!!",CR,LF,0

t_ahead:
        DB	"You're ahead $",0

t_behind:
        DB	"You're behind $",0

t_cash_out:
        DB	CR,LF,CR,LF,"So you want to cash out your chips, I see!!!",CR,LF,0

t_no_money:
        DB	"You didn't win any money, but I'm willing to call it even!!",CR,LF,0

t_winnings:
        DB	"You won exactly $",0

t_not_bad:
        DB	"!!  Not bad!!!",CR,LF,0

t_debug_stop:
        DB	4,"stop"    ; length prefixed for easier compares

; TODO: remove debugging messages
t_one:
        DB	"One",CR,LF,0

t_two:
        DB	"Two",CR,LF,0

t_three:
        DB	"Three",CR,LF,0

t_four:
        DB	"Four",CR,LF,0

t_five:
        DB	"Five",CR,LF,0

t_six:
        DB	"Six",CR,LF,0

t_entered:
        DB	"END OF TEXT VALUES",0

t_test:
        DB      1, "CR,LF"

t_output:               ; space for holding coverted numbers for output
        DEFS    3       ; 3 bytes should be enough