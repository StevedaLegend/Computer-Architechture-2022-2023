*-----------------------------------------------------------
* Title      : 68k Project Task 1
* Written by : Steve Fasoranti 
* Date       : 25/01/2023
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

            LEA text, A1        ;Simulates the text
            MOVE #4,D0          ;Moving value 4 to D0
            TRAP #15            ;Displays the unassigned number in D1
            MOVE #14,D0         ;Moves the value 14 to D0
            TRAP #15            ;Displays the unassigned number in D1
            MOVE #3,D0          ;Moves the value 3 to D0
            TRAP #15            ;Displays the unassigned number in D1

    SIMHALT             ; halt simulator
    

text dc.b 'Data Register: ',0


* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
