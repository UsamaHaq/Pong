float red, green, blue;
float alpha, speed, lineWidth;
float[] x = new float[20];
float[] y = new float[20];
float segLength = 16;
int StrokeWidth;

// ***********************************
//     Show the Score of  Players
// ***********************************
void showScore()
{
  textSize(42);
  text(str(scorePlayer1), halfWidth - 100, 80);
  text(str(scorePlayer2), halfWidth + 58, 80);
  return;
}

// ***********************************
//     Draw the Margin Lines
// ***********************************
void drawMargins()
{
  strokeWeight(2);
  fill(255);
  stroke(255, 60);

  line(halfWidth, 0, halfWidth, Height);
  line(padWidth, 0, padWidth, Height);
  line(Width-padWidth, 0, Width-padWidth, Height);
  return;
}

// ***********************************
//    Draw the Pads on the Screen
// ***********************************
void drawPads()
{
  strokeWeight(2);
  fill(255);
  stroke(255, 60);

  rect(rightPadx, rightPady, padWidth, padHeight);
  rect(leftPadx, leftPady, padWidth, padHeight);
  return;
}


// ***********************************
//   Draw the Ball on the Screen
// ***********************************
void displayBall() {
  if (gameStart)
  {
    dragSegment(0, ballX, ballY);
    StrokeWidth = 20;
    for (int i=0; i<x.length-1; i++) {
      dragSegment(i+1, x[i], y[i]);
    }
  }
  noTint();
  imageMode(CENTER);
  image(ballImage, ballX, ballY, ballRadius*1.3, ballRadius*1.3);
  return;
}

// ***********************************
//          Move the Ball
// ***********************************
void moveBall()
{
  ballX = ballX + speedAdjust * velocityX;
  ballY = ballY + speedAdjust * velocityY;
  return;
}

/*=================================================
 *   >> Collision Test Code for Ball with:
 *   1. Collision from Upper and Lower boundaries.
 *   2. Collision from Left and Right boundaries.
 *   3. Collision from Left and Right pads.
 *=================================================
 */

void CollisionTest()
{
  if (gameStart)
  {
    //   *** Collision Test:  Ceiling and Floor ***
    if (ballY <= 0 + (ballRadius / 2))
      velocityY = -velocityY;
    if (ballY >= Height - (ballRadius / 2))
      velocityY = -velocityY;

    //   *** Collision Test:  Left Pad ***
    if (ballX < halfWidth)
    {
      if (ballX - (ballRadius/2) <= padWidth
        && (ballY >= leftPady &&
        ballY <= (leftPady + padHeight)) )
      {
        velocityX = -velocityX;
        ballHit.play();
        speedAdjust += 0.5;
      }
      else if ((ballX - (ballRadius/2)) - padWidth <= 0)
      {
        velocityX = -velocityX;
        scorePlayer2++;
        ballMiss.play();
      }
    }

    //   *** Collision Test:  Right Pad ***
    if (ballX > halfWidth)
    {
      if (ballX + (ballRadius/2) >= Width-padWidth
        && (ballY >= rightPady &&
        ballY <= (rightPady + padHeight)))
      {
        velocityX = -velocityX;
        ballHit.play();
        speedAdjust += 0.5;
      }
      else if ((ballX + (ballRadius/2)) + (padWidth) >= Width)
      {
        velocityX = -velocityX;
        scorePlayer1++;
        ballMiss.play();
      }
    }
    speedAdjust = constrain(speedAdjust, 1, 4);
  }
  return;
}



// ***********************************
//          Reset the Ball
// ***********************************
void resetBall()
{
  ballX = halfWidth;
  ballY = halfHeight;
  return;
}

// ***********************************
//          Reset the Game
// ***********************************
void resetGame()
{
  scorePlayer1 = 0;
  scorePlayer2 = 0;
  rightPadx = Width - padWidth;
  rightPady = halfHeight - (padHeight / 2);
  leftPadx = 0;
  leftPady = halfHeight - (padHeight / 2);
  speedAdjust = 1;
  resetBall();
  if (leftSide)
  {
    velocityX = (random(120, 240))/60;
    leftSide = false;
  }
  else
  {
    velocityX = -(random(120, 240))/60;
    leftSide = true;
  }
  velocityY = -(random(60, 180))/60;
  return;
}


// ***********************************
//          Tail Effect:    1
// ***********************************
void dragSegment(int i, float xin, float yin)
{
  float dx = xin - x[i];
  float dy = yin - y[i];
  float angle = atan2(dy, dx);  
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
  return;
}

// ***********************************
//          Tail Effect:    2
// ***********************************
void segment(float x, float y, float a)
{
  red = map(ballX, 0, Width, 0, 255);
  blue = map(ballY, 0, Width, 0, 255);
  green = dist(ballX, ballY, Width/2, Height/2);
  speed = dist(ballX, ballY, Width/2, Height/2);
  alpha = map(speed, 0, 20, 0, 10);
  stroke(red, blue, green, alpha);
  StrokeWidth -= 1;
  StrokeWidth = constrain(StrokeWidth, 1, 20);
  brush1(x, y, speed, speed, StrokeWidth);
  brush2(x, y, speed, speed, 5);
  return;
}

// ***********************************
//          Tail Effect:    3
// ***********************************
private void brush1(float x, float y, float px, float py, float lineWidth)
{
  strokeWeight(lineWidth);
  pushMatrix();
  translate(x, y);
  rotate(random(px));
  line(0+random(50), 0+random(50), 0, 0);
  rotate(random(px));
  line(0+random(50), 0+random(50), 0, 0);
  rotate(random(px));
  line(0+random(50), 0+random(50), 0, 0);
  popMatrix();

  return;
}

// ***********************************
//          Tail Effect:    4
// ***********************************
void brush2(float x, float y, float px, float py, float lineWidth)
{
  strokeWeight(lineWidth);
  pushMatrix();
  translate(x, y);
  rotate(random(px));
  rect(0+random(50), 0+random(50), 10, 10); 
  popMatrix();
  return;
}

