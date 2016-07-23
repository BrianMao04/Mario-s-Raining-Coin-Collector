%-------------------------------------------%
% File name: Mario's Coin Collector
% Date: Jan. 7, 2013
% Programmer: Brian Mao
% Description: My Final Project
%-------------------------------------------%

setscreen ("graphics:700;400")
setscreen ("offscreenonly")

%Mario's movement variables
const GROUND_LEVEL := 0
const RUN_SPEED := 10                      %Mario's run and jump constants
const JUMP_SPEED := 28
const GRAVITY := 2
const pipe_level := 150                    %Height of the blocks

var newgravity : int := -30                %Gravity speed when Mario is ground pounding
var mario : int := Pic.FileNew ("pic1.bmp")
var marioH : int := Pic.Height (mario)     %Mario's Picture Dimmensions
var marioW : int := Pic.Width (mario)
var marioX : int := round (maxx / 2)       %Mario's location coordinates
var marioY : int := GROUND_LEVEL

var marioXvelocity : int := 0               %Mario's movement speed
var marioYvelocity : int := 0
%------------------------------
%Mario's animations
var marioPicNum : int := 1                  % Current view of mario
var marioDir : string := "left"             % Direction in which mario is facing
var marioPic : array 1 .. 12 of int         % The 12 pictures represent all animated views of mario
for i : 1 .. 12
    marioPic (i) := Pic.FileNew ("pic" + intstr (i) + ".bmp")
end for
var nextLeftPic : array 1 .. 12 of int := init (2, 3, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2)
var nextRightPic : array 1 .. 12 of int := init (5, 5, 5, 5, 6, 7, 8, 6, 5, 5, 5, 5)
%-------------------------------
%P-switch variables
var pSwitch : int := Pic.FileNew ("p-switch.bmp")
pSwitch := Pic.Scale (pSwitch, 70, 70)   %Scales down the p-switch picture
var pswitchactiv1 : boolean := false     %Determines if the p-switch is activated
var pswitchactiv2 : boolean := false     %Determines if the p-switch is activated
%-------------------------------
%Screen and Control Variables
var maxxx : int := 700                    %Max screen coordinates
var maxxy : int := 400
var keyInput : array char of boolean      %Allows keyboard inputs from the player
%--------------------------------
%Score variables
var score : int := 0                       %Current Score
var coinx : flexible array 0 .. 10 of int  %Coordinates of the coins out on the screen
var coiny : flexible array 0 .. 10 of int
var coinnum : flexible array 0 .. 10 of int
var coinump : int := 100                   %Number of Coins the p-switches output after being activated
var coinump2 : int := 1000
%---------------------------------
%Timer Variables
var timer : int   %The current in game time
var timer2 : int  %The difference between the time from the title screen to the game actually starting
%---------------------------------
%Goomba variables, pictures and parameters
var goombapic : array 0 .. 1 of int
var goombaX : int                    %Goomba Coordinates
var goombaY : int
var goombaspeed : int                %Goomba Speed

for i : 0 .. 1
    goombapic (i) := Pic.FileNew ("goomba" + intstr (i + 1) + ".bmp")
end for

for i : 0 .. 0
    goombaX := 200
    goombaY := GROUND_LEVEL
    goombaspeed := 1                 %Adjust goomba speed here
end for
%-------------------------------------------%
%Game Screen Outputs
procedure redrawGameField
    Pic.Draw (marioPic (marioPicNum), marioX, marioY, picMerge)

    %Output the blocks
    drawfillbox (0, 0, 100, 150, brown)
    drawfillbox (600, 0, 700, 150, green)
    drawfillbox (0, 120, 100, 150, 1)
    drawfillbox (600, 120, 700, 150, 1)
    drawbox (0, 0, 100, 150, black)
    drawbox (600, 0, 700, 150, black)
    drawbox (0, 120, 100, 150, black)
    drawbox (600, 120, 700, 150, black)

    %Score Output
    drawfillbox (230, 300, 530, 380, black)
    drawfilloval (300, 340, 20, 25, yellow)
    drawfillbox (340, 350, 360, 340, yellow)
    drawfillbox (340, 320, 360, 330, yellow)

    var font : int
    font := Font.New ("sans serif:40:bold")
    var numstr : string
    var instr : int
    numstr := intstr (score)
    Font.Draw (numstr, 380, 320, font, yellow)
    Font.Free (font)

    %Giant coin next to score
    drawoval (300, 340, 20, 25, black)
    drawbox (295, 325, 305, 355, black)

    %TIMER Output
    drawfillbox (0, 300, 100, 380, gray)
    var font2 : int
    font2 := Font.New ("sans serif:40:bold")
    var numstr2 : string
    var instr2 : int
    numstr2 := intstr (timer)
    Font.Draw (numstr2, 20, 315, font2, black)
    Font.Free (font2)

    var font3 : int
    font3 := Font.New ("sans serif:15:bold")
    var tim : string := "TIME"
    Font.Draw (tim, 20, 360, font3, black)

end redrawGameField
%-------------------------------------------%
%Mario's movement
procedure moveMario
    marioX := marioX + marioXvelocity

    marioYvelocity := marioYvelocity - GRAVITY
    marioY := marioY + marioYvelocity
    if marioY < GROUND_LEVEL then
	marioY := GROUND_LEVEL
	marioYvelocity := 0
    end if
end moveMario
%---------------------------------------------
%Allow the goomba to move around the screen
procedure movegoomba
    for i : 0 .. 12
	goombaX := goombaX + goombaspeed
	if goombaX <= 100 then
	    goombaspeed := -goombaspeed
	elsif goombaX >= 600 - 30 then
	    goombaspeed := -goombaspeed
	end if
    end for
    if goombaspeed > 0 then
	Pic.Draw (goombapic (0), goombaX, goombaY, picMerge)       %change goomba pics later
    else
	Pic.Draw (goombapic (1), goombaX, goombaY, picMerge)
    end if
end movegoomba
%------------------------------------------------
%Randomly generate the coins around the screen
procedure coins
    for i : 0 .. upper (coinx)
	randint (coinx (i), 108, 592)
	randint (coiny (i), 0, 400)
	drawfilloval (coinx (i), coiny (i), 8, 10, yellow)
	drawoval (coinx (i), coiny (i), 8, 10, black)
    end for
end coins
%---------------------------------------------
%Determine when to output a p-switch
procedure pswitch
    for i : 0 .. 1
	if pswitchactiv1 = false then
	    Pic.Draw (pSwitch, 10, 138, picMerge)
	else
	end if
	if pswitchactiv2 = false then
	    Pic.Draw (pSwitch, 615, 138, picMerge)
	else
	end if
    end for
end pswitch
%---------------------------------------------
%Check if Mario can collect the coin
procedure check
    for i : 0 .. upper (coinx)
	if (marioX <= coinx (i) + 8 and marioX >= coinx (i) - 8) and (marioY + marioH > coiny (i) - 10 or marioY + marioH < coiny (i) + 10) then
	    score := score + 1
	end if
    end for
end check
%--------------------------------------------
%Check if p-switches are activated
procedure checkp
    if keyInput (KEY_DOWN_ARROW) and (marioX <= 50 and marioX >= 10) and marioY <= 145 and (score >= 100 and pswitchactiv2 = false) then
	pswitchactiv1 := true
    elsif keyInput (KEY_DOWN_ARROW) and (marioX <= 50 and marioX >= 10) and marioY <= 145 and (score >= 1000 and pswitchactiv2 = true) then
	pswitchactiv1 := true
    end if
    if keyInput (KEY_DOWN_ARROW) and (marioX <= 650 and marioX >= 620) and marioY <= 145 and (score >= 100 and pswitchactiv1 = false) then
	pswitchactiv2 := true
    elsif keyInput (KEY_DOWN_ARROW) and (marioX <= 650 and marioX >= 620) and marioY <= 145 and (score >= 1000 and pswitchactiv1 = true) then
	pswitchactiv2 := true
    end if
end checkp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Program                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Music.PlayFileReturn ("the_moon.mp3")
%Title screen
var title : string := "Mario's Raining Coin Collector"
var font4 : int
font4 := Font.New ("sans serif:35:bold")



var poo : int                            %Mario Picture on title screen
poo := Pic.FileNew ("pooping_Mario.jpg")
poo := Pic.Scale (poo, 200, 200)

put ""
put ""
put ""
put "Instructions"
put "Collect as many coins as possible within the time limit."
put "The game ends when the time reaches 45."
put ""
put "Ground pound the p-switches to collect more coins."
put "You can only hit a p-switch once you've collected 100 coins or nothing will happen."
put "You can only hit a second p-switch once you've collected a 1000 coins"
put "or nothing will happen."
put "It doesn't matter if you hit the left or right one first."
put "Mario can also duck under each block in to the blue area."
put "The goomba in this game is INVINCIBLE."
put "If you touch it, you'll lose half of your coins."
put ""
put "CONTROLS"
put "Use the arrow keys to move around."
put "Hit the space bar or up arrow to jump." 
put "Hit down while in the air to ground pound."
put ""
put "Can you collect over 9000 coins within the time limit?"
put "*NOTE: The game speed may vary depending on your monitor."
%put ""
put "*Press the Space bar to begin.*"

Pic.Draw (poo, 460, 30, picCopy)
Font.Draw (title, 10, 360, font4, black)

View.Update

loop

    Input.KeyDown (keyInput)
    if keyInput (' ') then
	timer2 := Time.Elapsed
	exit
    end if
end loop
cls

loop

    timer := round ((Time.Elapsed - timer2) / 1000)
    Input.KeyDown (keyInput)
    if (keyInput (KEY_LEFT_ARROW) and marioX > 100) or (marioY > pipe_level and
	    keyInput (KEY_LEFT_ARROW) and marioX >= 10) then
	marioXvelocity := -RUN_SPEED
	marioDir := "left"
	if (marioY = GROUND_LEVEL) or (marioY <= pipe_level + 5 and marioX <= 100) or (marioY <= pipe_level + 5 and marioX >= 600) then
	    marioPicNum := nextLeftPic (marioPicNum)
	end if


    elsif (keyInput (KEY_RIGHT_ARROW) and marioX < 600 - marioW) or marioY > pipe_level and
	    keyInput (KEY_RIGHT_ARROW) and marioX <= 700 - marioW then
	marioXvelocity := RUN_SPEED
	marioDir := "right"
	if (marioY = GROUND_LEVEL) or (marioY <= pipe_level + 5 and marioX <= 100) or (marioY >= 150 and marioX >= 600) then
	    marioPicNum := nextRightPic (marioPicNum)
	end if
    else
	marioXvelocity := 0
	if marioDir = "left" then           % when standing,
	    marioPicNum := 1                % the animation view is either 1 or 5,
	elsif marioDir = "right" then       % depending on the direction in which
	    marioPicNum := 5                % mario is facing
	end if
    end if

    %Stop Mario from falling through the blocks
    if marioX < 100 and marioY <= pipe_level + 4 and marioYvelocity < 0 then
	marioY := pipe_level + 4
	marioYvelocity := 0
    end if

    if marioX > 600 - marioW and marioY <= pipe_level + 4 and marioYvelocity < 0 then
	marioY := pipe_level + 4
	marioYvelocity := 0
    end if
    %-------------------------------------------------------------
    %Allow Mario to jump on the blocks
    if keyInput (' ') and ((marioY = GROUND_LEVEL) or (marioY <= pipe_level + 5 and marioX < 100) or (marioY <= pipe_level + 5 and marioX + marioW > 604)) then
	marioYvelocity := JUMP_SPEED

	if marioDir = "left" then           % when jumping,
	    marioPicNum := 9                % the animation view is either 9 or 10,
	elsif marioDir = "right" then       % depending on the direction in which
	    marioPicNum := 10               % mario is facing
	end if

    elsif keyInput (KEY_UP_ARROW) and ((marioY = GROUND_LEVEL) or (marioY <= pipe_level + 5 and marioX < 100) or (marioY <= pipe_level + 5 and marioX >= 604 - marioW)) then
	marioYvelocity := JUMP_SPEED

	if marioDir = "left" then           % when jumping,
	    marioPicNum := 9                % the animation view is either 9 or 10,
	elsif marioDir = "right" then       % depending on the direction in which
	    marioPicNum := 10               % mario is facing
	end if

    elsif (keyInput (KEY_DOWN_ARROW) and marioX > 90) or (marioY > pipe_level and
	    keyInput (KEY_DOWN_ARROW) and marioX >= 0) then
	marioXvelocity := 0
	marioYvelocity := newgravity
	if marioDir = "left" then           % when squatting,
	    marioPicNum := 11               % the animation view is either 11 or 12,
	elsif marioDir = "right" then       % depending on the direction in which
	    marioPicNum := 12               % mario is facing
	end if
    end if
    %-----------------------------------------------------------------------------
    pswitch
    moveMario
    checkp
    movegoomba
    coins
    check
    redrawGameField


    %P-switches output more coins when hit
    if pswitchactiv1 = true and pswitchactiv2 = false then
	new coinx, coinump
	new coiny, coinump
    elsif pswitchactiv1 = false and pswitchactiv2 = true then
	new coinx, coinump
	new coiny, coinump
    else
    end if
    %Second p-switch outputs even more coins when hit
    if pswitchactiv2 = true and pswitchactiv1 = true then
	new coinx, coinump2
	new coiny, coinump2
    else
    end if

    %Let the goomba take have your coins away when touched
    if goombaX < marioX + marioW and goombaX > marioX and marioY <= goombaY then
	score := score div 2
    end if

    View.Update
    delay (20)
    cls
    exit when timer >= 45
end loop
Music.PlayFileStop

%%%%%%%%%%%%%%%%%%END GAME%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Display the Game Over screen
var gameover : string := "Game Over"              %End Game Messages
var thanks : string := "Thanks for playing."
var y9000 : string := "You got over 9000 coins!"

put " Your score is: "
var numstr5 : string
var instr5 : int
numstr5 := intstr (score)
Font.Draw (numstr5, 130, 365, font4, brown)

if score > 9000 then                              %Check for the "bonus" ending
    Font.Draw (y9000, 100, 220, font4, yellow)
else
end if

Font.Draw (thanks, 170, 150, font4, black)       %Ouput the end game messages
Font.Draw (gameover, 220, 300, font4, black)





