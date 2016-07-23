%-------------------------------------------%
% File name: mario_jumping.t                %
% Date: 12/09/2012                          %
% Programmer: Mr.G                          %
% Description: The following program is a template for Mario game.
%-------------------------------------------%
setscreen ("graphics:640;400")
setscreen ("offscreenonly")

const GROUND_LEVEL := 0
const RUN_SPEED := 10
const JUMP_SPEED := 30
const GRAVITY := 2

var mario : int := Pic.FileNew("pic1.bmp")
var marioH : int := Pic.Height(mario)
var marioW : int := Pic.Width(mario)
var marioX : int := round(maxx/2)
var marioY : int := GROUND_LEVEL

var marioXvelocity : int := 0 
var marioYvelocity : int := 0

var keyInput : array char of boolean
%-------------------------------------------%
procedure redrawGameField
    Pic.Draw(mario, marioX, marioY, picMerge)
end redrawGameField
%-------------------------------------------%
procedure moveMario
    marioX := marioX + marioXvelocity
    
    marioYvelocity := marioYvelocity - GRAVITY
    marioY := marioY + marioYvelocity
    if marioY < GROUND_LEVEL then
	marioY := GROUND_LEVEL
	marioYvelocity := 0
    end if
end moveMario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Program                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loop
    Input.KeyDown (keyInput)
    if keyInput (KEY_LEFT_ARROW) then
	marioXvelocity := -RUN_SPEED
    elsif keyInput (KEY_RIGHT_ARROW) then
	marioXvelocity := RUN_SPEED
    else
	marioXvelocity := 0
    end if
    if keyInput (KEY_UP_ARROW) and marioY = GROUND_LEVEL then
	marioYvelocity := JUMP_SPEED
    end if

    moveMario
    redrawGameField
    View.Update
    delay (30)
    cls    
end loop 
