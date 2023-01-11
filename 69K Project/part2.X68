*-----------------------------------------------------------
* Title      : Task 2
* Written by : Steve Fasoranti
* Date       : 11/01/2023
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program


            MOVE.B #9,D1 ;Moves the value 9 to D1
            LEA text, A1 ;Simulates the text
            MOVE #14,D0  ;Moves value 14 to D0
            TRAP #15     ;Displays the unassigned number in D1
            MOVE #3,D0  ;Moves the value 3 to D0
            TRAP #15    ;Dsiplays the unassigned number in D1

 SIMHALT
text dc.b 'Data Register: ',0


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
