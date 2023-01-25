*-----------------------------------------------------------
* Title      : Part2
* Written by : Steve Fasoranti
* Date       : 25/01/2023
* Description: Demonstrate indirect addressing and
*display health using Address Register
*(A2)
*a. Health dc.b $10
*b. Assign Health to A2
*c. Adds 5 points
*d. Subtracts 5 points
*e. Multiplies points by 2
*f. Divides points by 2

*-----------------------------------------------------------

    ORG    $1000
START:                  ; first instruction of program

* Put program code here

            
    LEA Health,A2         ; Assign Health to A2
    ADD.B #5,A2          ; Adds 5 points
    SUB.B #5,A2          ; Subtracts 5 points
    LSL.B #2,A2          ; Multiplies points by 2
    LSR.B #2,A2          ; Divides points by 2
    MOVE.B  A2,D0         ; Move the value in Health to D0
   
            



    SIMHALT             ; halt simulator
    
MESSAGE DC.B 'Health',0 

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
