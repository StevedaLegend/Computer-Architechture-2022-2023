*-----------------------------------------------------------
* Title      : Part3
* Written by : Steve Fasoranti
* Date       : 25/01/2023
* Description:Write a program that utilises the
*following Traps
*a. 2
*b. 5
*c. 8
*d. 11
*e. 13
*f. 17
*g. 18
*h. 21
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

            
           LEA MESSAGE, A1
           MOVE.B #14,D0
           TRAP #15

    SIMHALT             ; halt simulator
    
MESSAGE DC.B '2'
        DC.B    $0D,$0A
        DC.B '5'  
        DC.B    $0D,$0A
        DC.B '8'
        DC.B    $0D,$0A
        DC.B '11'
        DC.B    $0D,$0A
        DC.B '13'
        DC.B    $0D,$0A
        DC.B '17'
        DC.B    $0D,$0A
        DC.B '18'
        DC.B    $0D,$0A
        DC.B '21',0
* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
