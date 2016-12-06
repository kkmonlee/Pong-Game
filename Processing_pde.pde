import ddf.minim.*;
import processing.serial.*;

String serialPortName = "/dev/ttyACM0";
Serial arduino;
Minim minim;
AudioPlayer wallSound, batSound;
PImage ball, bat, back;
float batPosition;
float ballX, ballY;
float vertSpeed, horiSpeed;

void setup() {
  size(960, 720);
  if (serialPortName.equals("")) {
    scanForArduino();
  } else {
    arduino = new Serial(this, serialPortName, 9600);
  }

  imageMode(CENTER);
  ball = loadImage("ball.png");
  bat = loadImage("bat.png");
  back = loadImage("back.png");

  minim = new Minim(this);
  
  wallSound = minim.loadFile("wall.mp3");
  wallSound = minim.loadFile("wall.mp3");
  batSound = minim.loadFile("bat.mp3");

  batPosition = bat.width / 2;

  resetBall();
}

void resetBall() {
  ballX = 20;
  ballY = 1;
  vertSpeed = 6;
  horiSpeed = random(-6, 6);
}

void draw() {
  image(back, width / 2, height / 2, width, height);

  // moves bat
  if ((arduino != null) && (arduino.available() > 0)) {
    String message = arduino.readStringUntil('\n');
    if (message != null) {
      int value = int(message.trim());
      batPosition = map(value, 0, 1024, 0, width);
    }
  }

  // draws bat
  image(bat, batPosition, height - bat.height);

  // calculate new position of ball
  ballX += horiSpeed;
  ballY += vertSpeed;
  
  if (ballY >= height) resetBall();
  if (ballY <= 0) ceilingBounce();

  if (ballX >= width) wallBounce();
  if (ballX <= 0) wallBounce();

  // draw ball
  translate(ballX, ballY);
  if (vertSpeed > 0) {
    rotate(-sin(horiSpeed / vertSpeed));
  } else {
    rotate(PI - sin(horiSpeed / vertSpeed));
  }
  image(ball, 0, 0);

  // collision between bat and ball
  if (batTouchesBall()) {
    float distFromBatCenter = batPosition - ballX;
    horiSpeed = -distFromBatCenter / 10;
    vertSpeed = -vertSpeed;

    ballY = height - (bat.height * 2);
    //batSound.rewind();
    //batSound.play();
  }
}

boolean batTouchesBall() {
  float distFromBatCenter = batPosition - ballX;
  return (ballY > height - (bat.height * 2)) && (ballY < height - (bat.height / 2)) && (abs(distFromBatCenter) < bat.width / 2);
}

void wallBounce() {
  horiSpeed = -horiSpeed;
  //wallSound.rewind();
  //wallSound.play();
}

void ceilingBounce() {
  vertSpeed = -vertSpeed;
  //wallSound.rewind();
  //wallSound.play();
}

void stop() {
  arduino.stop();
}

void scanForArduino() {
  try {
    for (int i = 0; i < Serial.list().length; i++) {
      if (Serial.list()[i].contains("tty.usb")) {
        arduino = new Serial(this, Serial.list()[i], 9600);
      }
    }
  } catch (Exception e) {
    println("Cannot connect");
  }
}