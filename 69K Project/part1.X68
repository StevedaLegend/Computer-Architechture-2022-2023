*-----------------------------------------------------------
* Title      : 68k Project Task 1 
* Written by : Steve Fasoranti
* Date       : 11/01/2023
* Description: 

*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program


                MOVE.B #9,D1 ;Moves the value 9 to D1
                MOVE.B D1,D2 ;Moves whats in the value D1 to D2
                MOVE.B D1,1100 ; Makes the D1 as a value of 12 in binary 
                MOVE.B 1100,D2 ;Moves 12 in binary to D2
                MOVE.B 1100,100 ;Moves 12 and replaces it as 4 in binary 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
