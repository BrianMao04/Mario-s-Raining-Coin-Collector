%-------------------------------------------%
% File name: mario_jumping_with_background.t%
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

var mario : int := Pic.FileNew ("pic1.bmp")
var marioH : int := Pic.Height (mario)
var marioW : int := Pic.Width (mario)
var marioX : int := round(maxx/2)
var marioY : int := GROUND_LEVEL

var marioXvelocity : int := 0
var marioYvelocity : int := 0

var bgd1 : int := Pic.FileNew ("background.bmp")
var bgd1W : int := Pic.Width (bgd1)
var bgd1X : int := 0
var bgd1Y : int := 0
var bgd2 : int := Pic.FileNew ("background.bmp")
var bgd2W : int := Pic.Width (bgd2)
var bgd2X : int := bgd1W
var bgd2Y : int := 0

var keyInput : array char of boolean
%-------------------------------------------%
procedure redrawGameField
    Pic.Draw (bgd1, bgd1X, bgd1Y, picMerge)
    Pic.Draw (bgd2, bgd2X, bgd2Y, picMerge)
    Pic.Draw (mario, marioX, marioY, picMerge)
end redrawGameField
%-------------------------------------------%
procedure moveMario
    bgd1X := bgd1X + marioXvelocity
    if bgd1X < -bgd1W then
	bgd1X := bgd2W + marioXvelocity
    elsif bgd1X > bgd1W then
	bgd1X := -bgd2W + marioXvelocity
    end if

    bgd2X := bgd2X + marioXvelocity
    if bgd2X < -bgd2W then
	bgd2X := bgd1W + marioXvelocity
    elsif bgd2X > bgd2W then
	bgd2X := -bgd1W + marioXvelocity
    end if

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
	marioXvelocity := RUN_SPEED
    elsif keyInput (KEY_RIGHT_ARROW) then
	marioXvelocity := -RUN_SPEED
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
