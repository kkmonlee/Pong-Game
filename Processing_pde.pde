import processing.serial.*;

// This will change depending on the system
String port = "/dev/ttyACM0";

Serial arduino;

// Initialising image instances
PImage ball, player1Bat, player2Bat, background;

// Variables for core functionality
float player1Bat_Position, player2Bat_Position;
float ballX, ballY;
float vertical, horizontal;
String[] value;
int p1Score=0;
int p2Score=0;
int count=0;


// Font for player score
PFont f;

void setup()
{
	// Window size
	size(960,720);
	// This if statement should not run, user should manually enter the port
	if(port.equals("")) scanForArduino();
	else arduino = new Serial(this, port, 9600);
	// Image initialisation
	imageMode(CENTER);
	ball = loadImage("ball.png");
	player1Bat = loadImage("bat.png");
	player2Bat = loadImage("bat.png");
	background = loadImage("background.png");
	// Font initialisation
	f = createFont("Arial",16,true);
	textFont(f,16);
	// Both bats should be placed in the middle of their areas
	player1Bat_Position = player1Bat.width / 2;
	player2Bat_Position = player2Bat.width / 2;
	resetBall();
}

// Needs improvement but current system works
void resetBall()
{
  ballX = 480;
  ballY = 360;
  vertical = random(-12,12);
  horizontal = random(-6,6);
}

void draw()
{
  image(background,width/2,height/2,width,height);
  text("Score player1: "+p1Score+"\nScore player2: "+p2Score,10,100);
  count++;
  // increase the velocity
  if (count==200) {
    count=0;
    if (vertical<0) { vertical--; }
    if (vertical>0) { vertical++; }
  }
  // Move the bat
  if((arduino != null) && (arduino.available()>0)) {
    String message = arduino.readStringUntil('\n');
    if(message != null) {
      value = split(message, '|');
      if (value.length==2) {
        player1Bat_Position = map(int(trim(value[0])),0,1024,0,width);
        player2Bat_Position = map(int(trim(value[1])),0,1024,0,width);
      }
    }
  }
  
  // Draw the bats
  image(player1Bat,player1Bat_Position,height-player1Bat.height);
  image(player2Bat,player2Bat_Position,player2Bat.height);
  
  

  // Calculate new position of ball - being sure to keep it on screen
  ballX = ballX + horizontal;
  ballY = ballY + vertical;
  if(ballY >= height) { p1Score++; resetBall(); }
  if(ballY <= 0) { p2Score++; resetBall(); }
  if(ballX >= width) wallBounce();
  if(ballX <= 0) wallBounce();

  // Draw the ball in the correct position and orientation
  translate(ballX,ballY);
  if(vertical > 0) rotate(-sin(horizontal/vertical));
  else rotate(PI-sin(horizontal/vertical));
  image(ball,0,0);
  
  // Do collision detection between bat and ball
  if(player1Bat_TouchingBall()) {
    float distFromBat_p1_Center = player1Bat_Position-ballX;
    horizontal = -distFromBat_p1_Center/10;
    vertical = -vertical;
    ballY = height-(player1Bat.height*2);
    
  }
  
  if(player2Bat_TouchingBall()) {
    float distFromBat_p2_Center = player2Bat_Position-ballX;
    horizontal = -distFromBat_p2_Center/10;
    vertical = -vertical;
    ballY = (player2Bat.height*2);
    
  }
  
}

boolean player1Bat_TouchingBall()
{
  float distFromBat_p1_Center = player1Bat_Position-ballX;
  return (ballY > height-(player1Bat.height*2)) && (ballY < height-(player1Bat.height/2)) && (abs(distFromBat_p1_Center)<player1Bat.width/2);
}

boolean player2Bat_TouchingBall()
{
  float distFromBat_p2_Center = player2Bat_Position-ballX;
  return (ballY < (player2Bat.height*2)) && (ballY > (player2Bat.height/2)) && (abs(distFromBat_p2_Center)<player2Bat.width/2);
}

// Multiply angle by -1 when the ball bounces off a wall
void wallBounce()
{
  horizontal = -horizontal;
  
}


void stop()
{
  arduino.stop();
}

void scanForArduino()
{
  try {
    for(int i=0; i<Serial.list().length ;i++) {
      if(Serial.list()[i].contains("tty.usb")) {
        arduino = new Serial(this, Serial.list()[i], 9600);
      }
    }
  } catch(Exception e) {
    // println("Cannot connect to Arduino !");
  }
}