%-------------------------------------------%
% File name: mario_background_only.t        %
% Date: 12/09/2012                          %
% Programmer: Mr.G                          %
% Description: The following program is a template for Mario game.
%-------------------------------------------%
setscreen ("graphics:640;400")
setscreen ("offscreenonly")

const RUN_SPEED := 10

var bgd1 : int := Pic.FileNew("background.bmp")
var bgd1W : int := Pic.Width(bgd1)
var bgd1X : int := 0
var bgd1Y : int := 0
var bgd2 : int := Pic.FileNew("background.bmp")
var bgd2W : int := Pic.Width(bgd2)
var bgd2X : int := bgd1W
var bgd2Y : int := 0
var bgdSpeed : int := 0

var keyInput : array char of boolean
%-------------------------------------------%
procedure redrawGameField
    Pic.Draw (bgd1, bgd1X, bgd1Y, picMerge)
    Pic.Draw (bgd2, bgd2X, bgd2Y, picMerge)
end redrawGameField
%-------------------------------------------%
procedure moveBackground
    bgd1X := bgd1X + bgdSpeed
    if bgd1X < -bgd1W then
	bgd1X := bgd2W + bgdSpeed
    elsif bgd1X > bgd1W then
	bgd1X := -bgd2W + bgdSpeed
    end if

    bgd2X := bgd2X + bgdSpeed
    if bgd2X < -bgd2W then
	bgd2X := bgd1W + bgdSpeed
    elsif bgd2X > bgd2W then
	bgd2X := -bgd1W + bgdSpeed
    end if
end moveBackground
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Program                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loop
    Input.KeyDown (keyInput)
    if keyInput (KEY_LEFT_ARROW) then
	bgdSpeed := RUN_SPEED
    elsif keyInput (KEY_RIGHT_ARROW) then
	bgdSpeed := -RUN_SPEED
    else
	bgdSpeed := 0
    end if    
    
    moveBackground
    redrawGameField
    View.Update
    delay (30)
    cls
end loop
