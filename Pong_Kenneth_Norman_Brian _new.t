% PONG (FinalPong.t)
% Kenneth Sinder, Brian Mao, Norman Huynh
% Created:  November 5, 2012
% Modified: November 13, 2012
% =======================================================================

% -----------------------------------------------------------------------
% Initialize the screen
% -----------------------------------------------------------------------
setscreen ("graphics: 800;600, nobuttonbar")
% -----------------------------------------------------------------------

% -----------------------------------------------------------------------
% Variable Declarations %
% -----------------------------------------------------------------------
% Ball variables
var ballX, ballY : int := 300                   % Ball X and Y position
var ballRadius : int := 20                      % Ball radius
var speedX, speedY : int := 6                   % Ball speed
var ballColour : int := 0                       % Ball colour
var ballExists : boolean := false               % Whether ball is in play

% Paddle variables
var leftPaddleY : int := 300                    % Height of left paddle
var rightPaddleY : int := 300                   % Height of right paddle
var paddleHeight : int := 60                    % Half of paddle length
var paddleColour : int := 0                     % Paddle colour
const leftPaddleL : int := 30                   % Left side of left paddle
const leftPaddleR : int := 50                   % Right side of left paddle
const rightPaddleL : int := (maxx - 50)         % Right side of right paddle
const rightPaddleR : int := (maxx - 30)         % Left side of right paddle
var paddleSpeed : int := 7                      % Speed of paddle movement
const paddleWidth : int := 20                   % Half of paddle width

% Control variables
var keysPressed : array char of boolean         % Keyboard status
var cheatFeature : int := 0                     % Flag for cheat feature
var bottomOfFieldColour := 0
var topOfFieldColour := 0                       % Colour settings
var lineOfSymmetryColour := 0
var backgroundColour := 16
var randomInteger : int := 0
const refreshRate := 8                          % Delay before redrawing
const bottomOfField := 20                       % Bottom of field (Y pos)
const topOfField := maxy - 20                   % Top of field (Y pos)
const lineOfSymmetryH := round (maxx / 2)       % Middle X coordinate
const lineOfSymmetryV := round (maxy / 2)       % Middle Y coordinate

% Score variables
var leftscore, rightscore : int := 0            % Score for both players
var lastPlayerScored : char := "L"              % Last player to score point
var scoreFont : int := 0                        % Font for the score
var leftscoreColour : int := 0                  % Colour for player 1 score
var rightscoreColour : int := 0                 % Colour for player 2 score

% Fonts for title screen, credits, game over screen
var fontnames : int := Font.New ("Arial:11")
var font3, font4 : int
% -----------------------------------------------------------------------

% -----------------------------------------------------------------------
% Procedures %
% -----------------------------------------------------------------------
procedure showTitleScreen
    % Explain game instructions
    locatexy (lineOfSymmetryH - 250, lineOfSymmetryV + 20)
    put "WELCOME TO TURING PONG!"
    locatexy (lineOfSymmetryH - 250, lineOfSymmetryV - 20)
    put "The player on the left uses W and S to move the paddle."
    locatexy (lineOfSymmetryH - 250, lineOfSymmetryV - 35)
    put "The player on the right uses P and L to move the paddle."
    locatexy (lineOfSymmetryH - 250, lineOfSymmetryV - 50)
    put "The objective is to hit the ball on the other player's side 7 times."
    locatexy (lineOfSymmetryH - 250, lineOfSymmetryV - 75)
    put "CREATED BY: Brian Mao, Kenneth Sinder, Norman Huynh"
    locatexy (lineOfSymmetryH - 250, lineOfSymmetryV - 110)
    put "Press SPACE to play."

    % Wait for user to press SPACE before entering game
    loop
	Input.KeyDown (keysPressed)
	if keysPressed (' ') then
	    exit
	end if
    end loop
    cls
end showTitleScreen
% -----------------------------------------------------------------------
procedure moveBall
    if ballExists = true then
	ballX := ballX + speedX
	ballY := ballY + speedY
    end if
end moveBall
% -----------------------------------------------------------------------
procedure bounceBall
    % Bounce the ball against the top and bottom borders
    if ballY + ballRadius >= topOfField or
	    ballY - ballRadius <= bottomOfField then
	speedY := -speedY
    end if

    % Bounce the ball against the paddles
    if ballX - ballRadius <= leftPaddleR + 2 and
	    ballX - ballRadius >= leftPaddleR - 2 and
	    ballY >= leftPaddleY - paddleHeight and
	    ballY <= leftPaddleY + paddleHeight then
	ballX := leftPaddleR + ballRadius
	speedX := -speedX
    elsif ballX + ballRadius >= rightPaddleL - 2 and
	    ballX + ballRadius <= rightPaddleR + 2 and
	    ballY >= rightPaddleY - paddleHeight and
	    ballY <= rightPaddleY + paddleHeight then
	ballX := rightPaddleL - ballRadius
	speedX := -speedX
    end if

    % Bounce the ball against the side of the paddles
    if ballX - ballRadius < leftPaddleR and
	    ballX + ballRadius >= leftPaddleL and
	    ballY + ballRadius >= leftPaddleY - paddleHeight - 3 and
	    ballY - ballRadius <= leftPaddleY + paddleHeight + 3 then
	if ballY > leftPaddleY then
	    ballY := leftPaddleY + paddleHeight + ballRadius
	    speedY := -speedY
	elsif ballY < leftPaddleY then
	    ballY := leftPaddleY - paddleHeight - ballRadius
	    speedY := -speedY
	end if
    elsif ballX - ballRadius <= rightPaddleR and
	    ballX + ballRadius > rightPaddleL and
	    ballY + ballRadius >= rightPaddleY - paddleHeight - 1 and
	    ballY - ballRadius <= rightPaddleY + paddleHeight + 1 then
	if ballY > rightPaddleY then
	    ballY := rightPaddleY + paddleHeight + ballRadius
	    speedY := -speedY
	elsif ballY < rightPaddleY then
	    ballY := rightPaddleY - paddleHeight - ballRadius
	    speedY := -speedY
	end if
    end if
end bounceBall
% -----------------------------------------------------------------------
procedure castNewBall
    % Determine whether the ball is in play and who scored the point
    if ballX - ballRadius > maxx then
	ballExists := false
	leftscore += 1
	lastPlayerScored := "L"
    elsif ballX + ballRadius < 0 then
	ballExists := false
	rightscore += 1
	lastPlayerScored := "R"
    end if

    if ballExists = false then
	% Delay for 300 ms before recast.ing the ball
	Time.DelaySinceLast (300)

	% Reset ball direction to default
	if leftscore = 0 and rightscore = 0 then
	    if speedX > 0 then
		speedX := -speedX
	    end if
	else
	    if speedX < 0 then
		speedX := -speedX
	    end if
	    if speedY < 0 then
		speedY := -speedY
	    end if
	end if

	% Send the ball in the right direction
	if ballX + ballRadius >= maxx then
	    speedX := -speedX
	end if
	randint (randomInteger, 1, 2)
	if randomInteger = 1 then
	    speedY := -speedY
	end if

	% Place the ball at the correct location
	case lastPlayerScored of
	    label "L" :
		ballX := round (lineOfSymmetryH + (0.5 * lineOfSymmetryH))
	    label "R" :
		ballX := round (lineOfSymmetryH - (0.5 * lineOfSymmetryH))
	end case
	ballY := lineOfSymmetryV

	% Resume ball movement and normal gameplay
	ballExists := true
    end if
end castNewBall
% -----------------------------------------------------------------------
procedure incrementPaddleXY
    % Get status of keyboard
    Input.KeyDown (keysPressed)

    % Determine when to enable or disable the cheat feature
    % Only allow the cheat feature to be used once (integer flag)
    if keysPressed ('y') and cheatFeature = 0 then
	cheatFeature := 1
    end if
    if cheatFeature = 1 and (ballX <= 0 or ballX >= maxx) then
	cheatFeature := cheatFeature + 1
    end if

    % Move the left paddle up if possible/necessary
    if (leftPaddleY + paddleHeight < topOfField) and
	    ((keysPressed ('w') and cheatFeature not= 1) or
	    (keysPressed ('s') and cheatFeature = 1)) then
	leftPaddleY := leftPaddleY + paddleSpeed
    end if
    % Move the left paddle down if possible/necessary
    if (leftPaddleY - paddleHeight > bottomOfField) and
	    ((keysPressed ('s') and cheatFeature not= 1) or
	    (keysPressed ('w') and cheatFeature = 1)) then
	leftPaddleY := leftPaddleY - paddleSpeed
    end if

    % Move the right paddle up if possible/necessary
    if keysPressed ('p') and
	    rightPaddleY + paddleHeight < topOfField then
	rightPaddleY := rightPaddleY + paddleSpeed
    end if
    % Move the right paddle down if possible/necessary
    if keysPressed ('l') and
	    rightPaddleY - paddleHeight > bottomOfField then
	rightPaddleY := rightPaddleY - paddleSpeed
    end if
end incrementPaddleXY
% -----------------------------------------------------------------------
procedure redrawField

    % Draw the background
    drawfill (0, 0, backgroundColour, backgroundColour)

    % Draw the lines on the field
    drawfillbox (0, 0, maxx, bottomOfField, bottomOfFieldColour)
    drawfillbox (0, maxy, maxx, topOfField, topOfFieldColour)
    drawline (lineOfSymmetryH, 0, lineOfSymmetryH, maxy, lineOfSymmetryColour)

    % Draw both paddles
    drawfillbox (leftPaddleL, leftPaddleY - paddleHeight, leftPaddleR,
	leftPaddleY + paddleHeight, paddleColour)
    drawfillbox (rightPaddleR, rightPaddleY - paddleHeight, rightPaddleL,
	rightPaddleY + paddleHeight, paddleColour)

    % Draw the ball
    drawfilloval (ballX, ballY, ballRadius, ballRadius, ballColour)

    % Display the score in large font
    var font : int
    font := Font.New ("sans serif:60:bold")
    var numstr : string
    var instr : int
    numstr := intstr (leftscore)
    Font.Draw (numstr, 250, 500, font, leftscoreColour)
    numstr := intstr (rightscore)
    Font.Draw (numstr, 515, 500, font, rightscoreColour)
    Font.Free (font)

    % Allow user to percieve image then clear it
    View.Update
    Time.DelaySinceLast (refreshRate)
    cls
end redrawField
% -----------------------------------------------------------------------
procedure drawEndgamePosition
    % Draw the 'game over' screen

    % Display the score in large font
    leftscoreColour := 16
    rightscoreColour := 16
    var font : int
    font := Font.New ("sans serif:60:bold")
    var numstr : string
    var instr : int
    numstr := intstr (leftscore)
    Font.Draw (numstr, 250, 500, font, leftscoreColour)
    numstr := intstr (rightscore)
    Font.Draw (numstr, 515, 500, font, rightscoreColour)
    Font.Free (font)

    % Draw stationary paddles
    drawfillbox (leftPaddleL, leftPaddleY - paddleHeight, leftPaddleR,
	leftPaddleY + paddleHeight, darkgrey)
    drawfillbox (rightPaddleR, rightPaddleY - paddleHeight, rightPaddleL,
	rightPaddleY + paddleHeight, darkgrey)

    % Draw a stationary game field
    drawfillbox (0, 0, maxx, bottomOfField, black)
    drawfillbox (0, maxy, maxx, topOfField, black)

    % Write the endgame text
    locatexy (lineOfSymmetryH - 65, lineOfSymmetryV + 75)
    colour (16)
    if leftscore = 7 then

	font3 := Font.New ("mono:15:")
	assert font3 > 0
	font4 := Font.New ("Arial:36:bold")
	assert font4 > 0

	Font.Draw ("Player One Wins", 340, 280, font3, colorfg)
	Font.Draw ("Game Over", 300, 300, font4, 16)

	Font.Free (font3)
	Font.Free (font4)

    else

	font3 := Font.New ("mono:15:bold")
	assert font3 > 0
	font4 := Font.New ("Arial:36:bold")
	assert font4 > 0
	Font.Draw ("Player Two Wins", 340, 280, font3, colorfg)
	Font.Draw ("Game Over", 300, 300, font4, 16)

	Font.Free (font3)
	Font.Free (font4)

    end if
end drawEndgamePosition
% -----------------------------------------------------------------------

% -----------------------------------------------------------------------
% Main Program Loop %
% -----------------------------------------------------------------------
Music.PlayFileReturn ("the_moon.mp3") % Play background music
showTitleScreen
setscreen ("offscreenonly") % Output graphics only when View.Update given
loop
    moveBall
    incrementPaddleXY
    redrawField
    bounceBall
    castNewBall
    if leftscore = 7 or rightscore = 7 then
	delay (1000)
	exit
    end if
end loop
Music.PlayFileStop
drawEndgamePosition
% -----------------------------------------------------------------------

