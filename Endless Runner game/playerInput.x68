*Still need to document


ALL_REG                 REG     D0-D7/A0-A6
GET_KEY_INPUT_COMMAND   equ     19        

initPlayerInput
        *ASCII CODE 25 = 0
        move.l          #$20,d2
inputLoop
        clr.l           d0   
        move.b          #GET_KEY_INPUT_COMMAND,d0
*put current ascii value we're looking for into d1 for trap
        move.l          d2,d1
        TRAP            #15
*if key is pressed call function if not just goto next ascii value
        cmpi.b          #0,d1
        beq             noCall
        jsr             callFunction
noCall
*bump to next ascii value
        add.l           #1,d2          
*if we're at Z, then reinit the data to 0 and begin loop again
        cmpi.b          #$5A,d2
        bne             inputLoop
     

        *end of input, return
        rts

callFunction
*save off registers
        movem.l ALL_REG,-(sp)
*load up FunctionTable[d2-'0']  

        sub.l   #$20,d2
        lsl.l   #2,d2
        move.l  (a0,d2),d1
*if it's a null function ptr, nothting to call so leave
        cmpi.l  #0,d1
        beq     noFuncPtr
*move value into A1 and call it
        move.l  d1,a1
        jsr     (a1)  
noFuncPtr
        movem.l (sp)+,ALL_REG
        rts





        




























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
