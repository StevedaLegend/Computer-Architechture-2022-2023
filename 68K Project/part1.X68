*-----------------------------------------------------------
* Title      : Part1
* Written by : Steve Fasoranti
* Date       : 25/01/2023
* Description: a. Ask user for gamer points
* b. Stores a gamers points in a memory
* location
* c. Displays points on screen
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here 

        LEA MESSAGE, A1
        MOVE.B #14,D0
        TRAP #15
        MOVE.B #9,D0
    
        MOVE.B #4,D0
        TRAP    #15
        
        
               
    SIMHALT             

MESSAGE DC.B 'Can i have gamer points?'
        DC.B    $0D,$0A,0
PROMPT DC.B 'Enter the amount of gamer points he can have:'
THEMESSAGE DC.B 'The computer now has',0


* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
