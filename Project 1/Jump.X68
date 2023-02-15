*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
updateRunnerGravity
        *update position of player due to gravity 
        jsr     RunnerGravityRoutine
        jsr     checkForRunnerGround
        rts

RunnerGravityRoutine
        *If the player is still jumping, do not apply gravity
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #SPACE_KEY,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             exitGravity
        move.l          RunnerJumping, d5
        cmpi.l          #1, d5
        BNE             exitGravity
        *If the player is moving left or right, then do not use the jumping sprite
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #$41,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             applyRunnerGravity
        
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #$44,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             applyRunnerGravity
        
        *Change sprite to jumping sprite
        move.l          RunnerJumpSprite, RunnerX
applyRunnerGravity
        *ACCELERATION HERE
        *add gravity to acceleration and then acceleration to Y position of player every frame
        move.l          RunnerVelocity, d0
        move.l          #Gravity, d1
        add.l           d1, d0
        move.l          d0, RunnerVelocity        
        move.l          RunnerY, d4
        add.l           RunnerVelocity, d4
        move.l          d4, RunnerY
        rts
        
checkForRunnerGround
    *Check if the velocity added to the position is greater than the ground of the player
    move.l  RunnerY, d4
    add.l   RunnerVelocity, d4
    *shift right since the Y position is stored while shifted
    lsr     #FRAC_BITS, d4
    move.l  Ground, d5
    cmp     d5, d4
    BGT     setRunnerGround     
    
returnRunnerGround    
    rts
    
setRunnerGround
    *set player1 Y position to the ground
    move.l  #0, RunnerVelocity
    move.l  RunnerIdleSprite, RunnerX
    jsr     updatePlayersBackGrounds
    move.l  Ground, d4
    lsl     #FRAC_BITS, d4
    move.l  d4, RunnerY
    move.l  #0, RunnerJumping
    
    
    bra     returnRunnerGround        
        


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
