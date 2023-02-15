*-----------------------------------------------------------
* Title      : Key inputs
* Written by : Steve Fasoranti
* Date       : 01/02/2023
* Description: USes calls and functions to call a key input to the main game itself
*-----------------------------------------------------------
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
        move.l          #0, RunnerBeamPressed
        *end of input, return
        rts

callFunction
*save off registers
        movem.l ALL_REG,-(sp)
*load up FunctionTable[d2-'0']  
        lea     FunctionTable,a0
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











*input routines
spaceRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
*shift player 1 out of fraction to increase y value        
        move.l  #550, d0
        move.l  RunnerY, d1
        lsr     #FRAC_BITS, d1
        cmp.l   d0,d1
        BNE     jumpLoop

        
jumpLoop
        *Set player down velocity to 0 and then 
        move.l  #0, RunnerVelocity
        move.l  RunnerY, d4
        move.l  #50, d5
        lsl     #FRAC_BITS, d5
        move.l  RunnerY, d6
        move.l  RunnerSpeed, d3
        lsl     #FRAC_BITS, d3
        sub.l   d3, d6
        cmp     d5, d6
        BLT     spaceRoutineExit
        ;change player to jump sprite and set boolean to jumping
        move.l  RunnerJumpSprite, RunnerChunkX
        sub.l   d3, d4
        move.l  d4, RunnerY
        move.l  #1, RunnerJumping
        
spaceRoutineExit
        rts
        
   
downRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine0
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine1
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine2
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine3
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine4
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine5
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine6
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine7
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine8
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine9
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineA
        *left moveing logic for player1
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
