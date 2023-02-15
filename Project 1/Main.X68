*-------------------------------------------------------------------------------------------------------------------*
* Title      : My Graphical design project                                                                          *
* Written by : Steve Fasoranti                                                                                      *
* Date       : 26/01/2023                                                                                           *
* Description: A built in graphical endless runner game thats called DASH dash as far as you can dogding obsticles  *
*-------------------------------------------------------------------------------------------------------------------*

	ORG $1000

START:

SPACE_KEY               equ $20
RunnerSprite            equ 160
UP_KEY                  equ $26
DOWN_KEY                equ $28
LEFT_KEY                equ $25
RIGHT_KEY               equ $27
Gravity                 equ $9C 
GET_USER_INPUT_COMMAND  equ 19
RunnerStartSpriteX      equ 160
FRAC_BITS               equ 4

*---------------------------------------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------------------------------------*	
*---------------------------------------------------------------------------------------------------------------*
*-------Changes screen size to the desires size of the screen so #700 is the width and the 600 is the length----*
*---------------------------------------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------------------------------------*


        move.b  #(ScreenChangeCode) , d0
        move.l  #700*$10000+600, d1
        trap    #15
        
*--------------------------------------------------*	
*--------------------------------------------------*	
*-------Loades the loading screen------------------*
*--------------------------------------------------*
*--------------------------------------------------*


        LEA     LoadingScreen, A0     ;Load up the loading screen from the bmp file onto the terminal
        MOVE.B  #160, d1              ;Moves the value 160 into D1
        MOVE.B  #170, d2              ;Moves the value 170 into D2
        MOVE.l  #270, d3              ;Moves the value 270 into D3
        MOVE.B  #250, d4              ;Moves the value 250 into D4
        MOVE.B  #0, d5                ;Moves the value 0 into D5
        MOVE.B  #0, d6                ;Moves the value 0 into D6
        jsr     DRAWIMAGE           ;Uses jsr to draw the image (DRAW IMAGE is a variable used in drawimages.x68 which draws the image in the terminal also using LEA)
        
        
    
*---------------------------------------------------------* 
*---------------------------------------------------------*
*------Double buffering occurs after the loading screen---*   
*---------------------------------------------------------*
*---------------------------------------------------------*
    
        move.b  #92, d0               ;Moves the value 92 to D0
        move.b  #17, d1               ;Moves the value 17 into D1
        trap    #15                   ;enables the buffering after the loading screen
        
        
*------------------------------------------------------------------------* 
*------------------------------------------------------------------------*
*------Resets the variables for the runner so they dont break the game---*   
*------------------------------------------------------------------------*
*------------------------------------------------------------------------*
 
ResetBattleVariables

        *Reset all of the variables for the runner
        move.l  #10,  RunnerX
        move.l  #550, RunnerY
        move.l  #160, RunnerChunkX
        move.l  #0,   RunnerChunkY
        move.l  #10,  RunnerSpeed
        move.l  #0,   RunnerJumping

        move.l  #0,   RunnerLeft
        
       
*-----------------------------------------------------------------------------------------------------*        
*-----------------------------------------------------------------------------------------------------*
*-----After buffering of the loading screen it loads the title image and uses DRAWIMAGE to draw it----*
*-----------------------------------------------------------------------------------------------------*
*-----------------------------------------------------------------------------------------------------*

    
        LEA     TitleScreen, a0        ;Loads up the Title screen after the buffering from the bmp image file
        move.l  #700, d1               ;moves the value long 700 (Screen size) into d1
        move.l  #600, d2               ;moves the value long 700 (Screen size) into d2
        move.l  #0, d3                 ;moves the value long 0 into d3
        move.l  #0, d4                 ;moves the value long 0 into d4
        move.l  #0, d5                 ;moves the value long 0 into d5
        move.l  #0, d6                 ;moves the value long 0 into d6
        jsr     DRAWIMAGE             ;Uses jsr to draw the image (DRAW IMAGE is a variable used in drawimages.x68 which draws the image in the terminal also using LEA)


*-------------------------------------------------------------------------------------------------------*        
*-------------------------------------------------------------------------------------------------------*        
*--------Displays the new draw in d0 and replaces what was in d0 (the loading screen in the above code)-*
*-------------------------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------------------------*     

        move.b  #94, d0                ;moves the value 94 into D0
        trap    #15                    ;displays the new draw in 
        
   
*----------------------------------------------------------------------*
*--------Draws the background of the Gameplaybackground----------------*
*----------------------------------------------------------------------*

        LEA     Frame1, a0
        move.l  #700, d1
        move.l  #550, d2
        move.l  #0, d3
        move.l  #50, d4
        move.l  #0, d5
        move.l  #50, d6
        jsr     DRAWIMAGE
        
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*----store player velocity as a shifted number for calculation---------*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
        move.l  RunnerVelocity, d0
        lsl     #FRAC_BITS, d0
        move.l  d0, RunnerVelocity
        
        
        
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*------Store Player positions shifted as well for the Y coordinate.----*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
        move.l  RunnerY, d0
        lsl     #FRAC_BITS, d0
        move.l  d0, RunnerY        
        
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*        
*-------------------Set drawing pen to black for score bar-------------*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
        move.l      #80, d0
        move.l      #$00000000, d1
        trap        #15
        move.l      #81, d0
        move.l      #$00000000, d1
        trap        #15
        
        
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*        
*-----Draw a filled black box in the upper 50 pixels of the screen-----*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
        move.w      #0, d1
        move.w      #0, d2
        move.w      #700, d3
        move.w      #50, d4
        move.l      #87, d0
        trap        #15
        
        
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*        
*------------------------Draw health bar images------------------------*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

        jsr     DrawRunnerHealth
   
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*-Draw 7 segment health digits with the health of each player displayed*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

        jsr     updateHealth
     
*------------------------------------------------------*
*-------User presses SPACEKEY command to start---------*
*------------------------------------------------------*
MainTitleLoop
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #SPACE_KEY,d1
        TRAP            #15
        cmpi.l          #0, d1
        BEQ             MainTitleLoop

*-----------------------------------------------------------------------------------------------------*        
*-----------------------------------------------------------------------------------------------------*
*-----After buffering of the loading screen it loads the title image and uses DRAWIMAGE to draw it----*
*-----------------------------------------------------------------------------------------------------*
*-----------------------------------------------------------------------------------------------------*


        *place double buffer on the view of the screen
        move.b  #94, d0
        trap    #15
        
*-----------------------------------------------------------------------------------------------------* 
*-----------------------------------------------------------------------------------------------------*
*-----------------------------Game loop to update entities--------------------------------------------*
*-----------------------------------------------------------------------------------------------------* 
*-----------------------------------------------------------------------------------------------------* 
         
GameLoop:

    jsr     updatePlayersBackgrounds
    jsr     initPlayerInput
    jsr     updateProjectilesBackgrounds
    jsr     drawPlayers
    
    
*---------------------------------------------------------* 
*---------------------------------------------------------*
*----Double buffering on the screen after the game loop---*   
*---------------------------------------------------------*
*---------------------------------------------------------*
    
    move.b  #92, d0               ;Moves the value 92 to D0
    trap    #15                   ;enables the buffering after the loading screen
        
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*          
*-Check both players health to see if they are at 0.  If they are, end the game*
*------------------------------------------------------------------------------* 
*------------------------------------------------------------------------------* 
    BLT     GAMEOVER
    
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*        
*--------Player 2's health reached 0  so create player 2 win screen------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------* 

*-------------Draw over players and projectiles---------*
GAMEOVER
    jsr     updatePlayersBackgrounds

    
**-----------------Draw GAMEOVER banner-----------------*
    lea     GAMEOVER, a0
    move.l  #700, d1
    move.l  #100, d2
    move.l  #0, d3
    move.l  #300, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
        

*------------Get image on double buffer-----------------*
    move.b  #94, d0
    trap    #15
    

*----------Stay on screen until user presses space key----*
GAMEOVERLOOP
    move.b          #GET_KEY_INPUT_COMMAND,d0
    move.l          #$20,d1
    TRAP            #15
    cmpi.l          #0, d1
    BNE             ResetBattleVariables
    BRA             GAMEOVERLOOP
   
   
*draw over projectile backgrounds and then draw the projectile in it's new position on screen
updateProjectilesBackgrounds


    
    
   
*--------------------------------------------------*	
*--------------------------------------------------*	
*----Loads in the runner into the sub routine------*
*--------------------------------------------------*
*--------------------------------------------------*
               
Drawrunner

            
    lea     Runner, a0
    move.l  RunnerWidth, d1
    move.l  RunnerHeight, d2
    move.l  RunnerX, d3
    move.l  RunnerY, d4
    lsr     #FRAC_BITS, d4
    move.l  RunnerX, d5
    move.l  RunnerY, d6
    jsr     DRAWIMAGE
    
    move.b  #94, d0
    trap    #15
    
    rts

   
*Draw the health bars of both players
DrawRunnerHealth
    lea     RunnerHealthImage, a0
    move.l  #200, d1
    move.l  #50, d2
    move.l  #0, d3
    move.l  #0, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    rts
*--------------------------------------------------*	
*--------------------------------------------------*	
*-------Draws the background for the runner--------*
*--------------------------------------------------*
*--------------------------------------------------*

updatePlayersBackgrounds

    move.l  RunnerHeight, d2
    move.l  RunnerX, d3
    move.l  RunnerY, d4
    lsr     #FRAC_BITS, d4
    move.l  RunnerX, d5
    move.l  RunnerY, d6
    lsr     #FRAC_BITS, d6
    jsr     DRAWIMAGE
    rts

   
*---------Draw over both score backgrounds---------*
updateScoreBackGround
    move.l      #80, d0
    move.l      #$00000000, d1
    trap        #15
    
    move.l      #81, d0
    move.l      #$00000000, d1
    trap        #15

    move.w      #205, d1
    move.w      #5, d2
    move.w      #235, d3
    move.w      #50, d4
    move.l      #87, d0
    trap        #15
    
    move.w      #460, d1
    move.w      #5, d2
    move.w      #495, d3
    move.w      #50, d4
    move.l      #87, d0
    trap        #15
    
    rts


*draw both players
drawPlayers 
      
    lea     Runner, a0
    move.l  RunnerWidth, d1
    move.l  RunnerHeight, d2
    move.l  RunnerX, d3
    move.l  RunnerY, d4
    lsr     #FRAC_BITS, d4
    move.l  RunnerChunkX, d5
    move.l  RunnerChunkY, d6
    jsr     DRAWIMAGE

*--------------------------------------------------*	
*--------------------------------------------------*	
*-------Variables for the runner are declared------*
*--------------------------------------------------*
*--------------------------------------------------*

RunnerWidth
    dc.l   32
RunnerHeight
    dc.l   41 
RunnerX
    dc.l    10
RunnerY
    dc.l    550
RunnerChunkX
    dc.l    160
RunnerChunkY
    dc.l    0
RunnerSpeed
    dc.l    10
RunnerJumping
    dc.l    0
Runner1Health
    dc.l    8
RunnerLeft
    dc.l    0
RunnerIdlSprite
    dc.l    160
RunnerJumpSprite
    dc.l    256  
RunnerDamageSprite
    dc.l    288 
Ground
    dc.l    550
RunnerVelocity
    dc.l    0
ProjectileSpeed
    dc.l    20
RunnerScoreX
    dc.l    200

*-----------------------------------------------------------------------*
*-------Sounds that are used in the same directory are declared here----*
*-----------------------------------------------------------------------*



*--------------------------------------------------------------------------------------------------------------------------------------------*    
*-------Variables in the drawimages.x68 are Declared here then use the images in the same file location to load the images in bmp form-------*
*--------------------------------------------------------------------------------------------------------------------------------------------*  
LoadingScreen
      INCBIN  "loadinggame.bmp"
TitleScreen
      INCBIN  "Titlesmall.bmp"
Frame1
      INCBIN  "frame1.bmp"
Runner
      INCBIN  "runner2.bmp"
RunnerHealthImage
      INCBIN  "RunnerHealth_200x50.bmp"

 
*--------------------------------------------------------------------------------------------------------------------*      
*--------Includes the file in the same directory with the varibles above so that the code is affected in the main-----*
*---------------------------------------------------------------------------------------------------------------------*                      
 include "drawimages.x68"
 include "playerInput.x68"
 include "RunnersHealthBar.x68"


OUIT
	END	START












































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
