Maxim maxim;
AudioPlayer backGroundMusic;
AudioPlayer ballHit;
AudioPlayer ballMiss;
PImage backGround;
PImage ballImage;
PFont scoreFont;

// ****   Player Scores   *****
int scorePlayer1 = 0;
int scorePlayer2 = 0;
final int winningScore = 10;

// ****   Game Status   *****
boolean firstRun = true;
boolean gameStart = true;
boolean gameEnd = false;

// ****   Output Windows Size   *****
final int Width = 800;
final int Height = 600;
final int halfWidth = 400;
final int halfHeight = 300;

// ****   Player Pads   *****
final int padWidth = 10;
final int padHeight= 80;
int rightPadx = Width - padWidth;
int rightPady = halfHeight - (padHeight / 2);
int leftPadx = 0;
int leftPady = halfHeight - (padHeight / 2);

// ****   The Ball   *****
final float ballRadius = 50.0;
float ballX = halfWidth;
float ballY = halfHeight;

// ****   Movement Variables   *****
float speedAdjust = 1;
float velocityX = -(random(120, 240))/60;
float velocityY = -(random(60, 180))/60;
float rightPadelVelocity = 32;
boolean leftSide = true;

/*=================================================
 *        Processing Output Window Setup
 *=================================================
 */
void setup()
{
  size(Width, Height);
  frameRate(60);
  backGround = loadImage("Space_041.jpg");
  ballImage = loadImage("ball.png");
  scoreFont = createFont("Ariel", 42, true);
  textFont(scoreFont);
  maxim = new Maxim(this);
  backGroundMusic = maxim.loadFile("bkgM.wav");
  backGroundMusic.setLooping(true);
  ballHit = maxim.loadFile("hit.wav");
  ballHit.setLooping(false);
  ballMiss = maxim.loadFile("miss.wav");
  ballMiss.setLooping(false);
  backGroundMusic.play();
}

/*=================================================
 *           Ah! The actual Drawing
 *=================================================
 */
void draw()
{
  smooth();
  imageMode(CORNERS);
  image(backGround, 0, 0, Width, Height);

  if (firstRun == true)
  {
    gameStart = false;
    gameEnd = false;
    textSize(48);
    fill(255);
    text("The Classical Game of Pong!", 80, 160);
    textSize(32);
    text("Player 1", halfWidth - 205, 200);
    text("Player 2", halfWidth + 100, 200);
    text("*Mouse*", halfWidth - 210, 240);
    text("*Key Board*", halfWidth + 75, 240);
    text("(UP/DOWN)", halfWidth - 235, 280);
    text("(UP/DOWN)", halfWidth + 75, 280);
    text("Click & Dragg", halfWidth - 245, 320);
    text("Arrow Keys", halfWidth + 85, 320);
    text("Hit Enter to Start a New Game...", 180, halfHeight+80);
  }
  else
  {
    drawMargins();
    showScore();
    displayBall();
    drawPads();
    if (scorePlayer1 == winningScore || scorePlayer2 == winningScore)
    {
      gameEnd = true;
    }

    moveBall();

    CollisionTest();
  }

  if (gameEnd)
  {
    gameStart = false;
    resetBall();
    if (scorePlayer1 > scorePlayer2)
    {
      textSize(72);
      fill(0, 255, 0);
      text("\"Winner is: Player 1\"", 72, 172);
    }
    else
    {
      textSize(72);
      fill(0, 255, 0);
      text("\"Winner is: Player 2\"", 72, 172);
    }
    textSize(32);
    fill(255);
    text("Hit Enter to Start a New Game...", 180, halfHeight+80);
  }
}


/*************************************
 *       Mouse Dragged Method        *
 *      Player 1's Pad Control       *
 *************************************
 */
void mouseDragged()
{
  if (gameStart)
  {
    if (pmouseY > mouseY)
    {
      leftPady = leftPady - 5;
      leftPady = constrain(leftPady, 0, Height - padHeight);
    }
    if (pmouseY < mouseY)
    {
      leftPady = leftPady + 5;
      leftPady = constrain(leftPady, 0, Height - padHeight);
    }
  }
}


/*******************************************
 *     Keyboard's KeyPressed Method        *
 *       Player 2's Pad Control            *
 *******************************************
 */
void keyPressed()
{
  if (gameEnd || firstRun)
  {
    if (key == ENTER || key == RETURN)
    {
      gameEnd = false;
      gameStart = true;
      firstRun = false;
      resetGame();
      clear();
      redraw();
    }
  }
  if (gameStart)
  {
    if (key == CODED)
    {
      if (keyCode == UP)
      {
        rightPadelVelocity = 32;
        rightPady = rightPady - int(rightPadelVelocity);
        rightPady = constrain(rightPady, 0, Height - padHeight);
        rightPadelVelocity += 5;
        rightPadelVelocity = constrain(rightPadelVelocity, 32, 80);
      }
      if (keyCode == DOWN)
      {
        rightPadelVelocity = 32;
        rightPady = rightPady + int(rightPadelVelocity);
        rightPady = constrain(rightPady, 0, Height - padHeight);
        rightPadelVelocity += 5;
        rightPadelVelocity = constrain(rightPadelVelocity, 32, 80);
      }
    }
  }
}

