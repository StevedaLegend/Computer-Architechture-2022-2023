*-------------------------------------------------------------------------------------------------------------------*
* Title      : My Graphical design project                                                                          *
* Written by : Steve Fasoranti                                                                                      *
* Date       : 26/01/2023                                                                                           *
* Description: A built in graphical endless runner game thats called DASH dash as far as you can dogding obsticles  *
*-------------------------------------------------------------------------------------------------------------------*

	ORG $1000

START:

SPACE_KEY       equ $20
PlayerSprite    equ 160
Gravity                 equ $9C     ;gravity store for the closest representation of 9.8
FRAC_BITS               equ 4

PLYR_W_INIT EQU         08          ; Players initial Width
PLYR_H_INIT EQU         08          ; Players initial Height

PLYR_DFLT_V EQU         00          ; Default Player Velocity
PLYR_JUMP_V EQU        -20          ; Player Jump Velocity
PLYR_DFLT_G EQU         01          ; Player Default Gravity

GND_TRUE    EQU         01          ; Player on Ground True
GND_FALSE   EQU         00          ; Player on Ground False

RUN_INDEX   EQU         00          ; Player Run Sound Index  
JMP_INDEX   EQU         01          ; Player Jump Sound Index  
OPPS_INDEX  EQU         02          ; Player Opps Sound Index

ENMY_W_INIT EQU         08          ; Enemy initial Width
ENMY_H_INIT EQU         08          ; Enemy initial Height


	
*---------------------------------------------------------------------------------------------------------------*	
*-------Changes screen size to the desires size of the screen so #700 is the width and the 600 is the length----*
*---------------------------------------------------------------------------------------------------------------*	
        move.b  #(ScreenChangeCode) , d0
        move.l  #700*$10000+600, d1
        trap    #15        
        
        
        
        
        
ResetBattleVariables
*---------------------------------------------------------*
*-------Reset all of the variables for character----------*
*---------------------------------------------------------*
        move.l  #10,Player1X
        move.l  #550, Player1Y
        move.l  #160, Player1ChunkX
        move.l  #0, Player1ChunkY
        
        
        
        
        
               
*-----------------------------------------------------------------------------------------------------*
*-----After buffering of the loading screen it loads the title image and uses DRAWIMAGE to draw it----*
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
*--------Displays the new draw in d0 and replaces what was in d0 (the loading screen in the above code)-*
*-------------------------------------------------------------------------------------------------------*       
        move.b  #94, d0                ;moves the value 94 into D0
        trap    #15                    ;displays the new draw in 
        
        
        

*-------------------------------------------------------------------------------------------------------* 
*-------------Set drawing pen to black for score bar----------------------------------------------------*
*-------------------------------------------------------------------------------------------------------* 
        move.l      #80, d0
        move.l      #$00000000, d1
        trap        #15
        move.l      #81, d0
        move.l      #$00000000, d1
        trap        #15
        
        
        
*-------------------------------------------------------------------------------------------------------* 
*-------------Draw a filled black box in the upper 50 pixels of the screen------------------------------*
*-------------------------------------------------------------------------------------------------------* 
        move.w      #0, d1
        move.w      #0, d2
        move.w      #700, d3
        move.w      #50, d4
        move.l      #87, d0
        trap        #15

        
*------------------------------------------------------*
*-------User presses SPACEKEY command to start---------*
*------------------------------------------------------*
ScenesLoop
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #SPACE_KEY,d1
        TRAP            #15
        cmpi.l          #0, d1
        BEQ             ScenesLoop
                
*----------------------------------------------------------------------*        
*----------place double buffer on the view of the screen---------------*
*----------------------------------------------------------------------*
        move.b  #94, d0
        trap    #15
   
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
*--------store player velocity as a shifted number for calculation-----*
*----------------------------------------------------------------------*
        move.l  Player1Velocity, d0
        lsl     #FRAC_BITS, d0
        move.l  d0, Player1Velocity
        *Store Player positions shifted as well for the Y coordinate.
        move.l  Player1Y, d0
        lsl     #FRAC_BITS, d0
        move.l  d0, Player1Y        
        lsl     #FRAC_BITS, d0
 

       

*-------------------------------------------------------------------------------------------------------* 
*-------------Set drawing pen to black for score bar----------------------------------------------------*
*-------------------------------------------------------------------------------------------------------* 
        move.l      #80, d0
        move.l      #$00000000, d1
        trap        #15
        move.l      #81, d0
        move.l      #$00000000, d1
        trap        #15
        
        
        
*-------------------------------------------------------------------------------------------------------* 
*-------------Draw a filled black box in the upper 50 pixels of the screen------------------------------*
*-------------------------------------------------------------------------------------------------------* 
        move.w      #0, d1
        move.w      #0, d2
        move.w      #700, d3
        move.w      #50, d4
        move.l      #87, d0
        trap        #15       
        
        
*----------------------------------------------------------------------*
*-----Load in values of both player 1 and 2 and call draw sub routine--*
*----------------------------------------------------------------------*
DrawPlayerCall
    lea     Player, a0
    move.l  Player1Width, d1
    move.l  Player1Height, d2
    move.l  Player1X, d3
    move.l  Player1Y, d4 
    lsr     #4, d4
    move.l  Player1ChunkX, d5
    move.l  Player1ChunkY, d6
    jsr     DRAWIMAGE

      
*----------------------------------------------------------------------*        
*------draw character--------------------------------------------------*
*----------------------------------------------------------------------*
drawPlayers 
      
    LEA     Player, a0
    move.l  Player1Width, d1
    move.l  Player1Height, d2
    move.l  Player1X, d3
    move.l  Player1Y, d4
    lsr     #FRAC_BITS, d4
    move.l  Player1ChunkX, d5
    move.l  Player1ChunkY, d6
    jsr     DRAWIMAGE
    
    move.b  #94, d0
    trap    #15
    
    rts       
   
*----------------------------------------------------------------------*
*---------main gameloop to update entities and draw them---------------*
*----------------------------------------------------------------------*
GAMELOOP:
    jsr     initPlayerInput
    jsr     drawPlayers
  
        
*-------------------------------------------------------------------------------------------------------*        
*--------Displays the new draw in d0 and replaces what was in d0 (the loading screen in the above code)-*
*-------------------------------------------------------------------------------------------------------*       
        move.b  #94, d0                ;moves the value 94 into D0
        trap    #15                    ;displays the new draw in 
        
          

*-----------------------------------------------------------
* Subroutine    : Move Enemy
* Description   : Move Enemy Right to Left
*-----------------------------------------------------------
MOVE_ENEMY:

    RTS



*-----------------------------------------------------------
* Subroutine    : Reset Enemy
* Description   : Reset Enemy if to passes 0 to Right of Screen
*-----------------------------------------------------------

RESET_ENEMY_POSITION:


    RTS

*-----------------------------------------------------------
* Subroutine    : Draw
* Description   : Draw Screen
*-----------------------------------------------------------
DRAW: 
    ; Enable back buffer
    MOVE.B  #94,        D0
    TRAP    #15

    ; Clear the screen

	MOVE.W	#$FF00,     D1          ; Clear contents
	TRAP    #15                     ; Trap (Perform action)




    RTS                             ; Return to subroutine

*-----------------------------------------------------------------------*
*-------Sounds that are used in the same directory are declared here----*
*-----------------------------------------------------------------------*



*-----------------------------------------------------------------------*
*--------The character on the screen------------------------------------*
*-----------------------------------------------------------------------*
Player1Width
    dc.l   32
Player1Height
    dc.l   41 
Player1X
    dc.l    10
Player1Y
    dc.l    550
Player1ChunkX
    dc.l    160
Player1ChunkY
    dc.l    0       
Player1Velocity
    dc.l    0


*--------------------------------------------------------------------------------------------------------------------------------------------*    
*-------Variables in the drawimages.x68 are Declared here then use the images in the same file location to load the images in bmp form-------*
*--------------------------------------------------------------------------------------------------------------------------------------------*  
LoadingScreen
      INCBIN  "loadinggame.bmp"
TitleScreen
      INCBIN  "Titlesmall.bmp"
Player
      INCBIN  "player_320x92.bmp"
Frame1
      INCBIN  "assests2\frame1.bmp"

 
*--------------------------------------------------------------------------------------------------------------------*      
*--------Includes the file in the same directory with the varibles above so that the code is affected in the main-----*
*---------------------------------------------------------------------------------------------------------------------*                      
 include "drawimages.x68"
 include "playerInput.x68"


OUIT
	END	START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
