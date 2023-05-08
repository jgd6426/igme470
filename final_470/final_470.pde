/* Judy Derrick
 * IGME.470 Final Project
 *
 * Built and modified from Carlos Castellanos SensorGraphASCII
 * and Daniel Shiffman Pointillism
 */

import processing.serial.*;

Serial myPort; // Serial object

// Data received from the serial port
int val;
String inBuffer;

// Images array and randomly chosen image
PImage[] images = new PImage[6];
PImage img;

int randomNumber;

// Dot size range
int smallPoint, largePoint;


void setup() {
  size(600, 900); // window size
  
  // set the range of the dots
  smallPoint = 1;
  largePoint = 200;
  
  imageMode(CENTER);
  noStroke();
  background(255);
  
  //initialize images array (load each one)
  for(int i = 0; i < images.length; i++) {
        images[i] = loadImage("img"+i+".jpg");
  }
  
  // Get random image from the array
  randomNumber = int(random(0, images.length));
  img = images[randomNumber];
 
  // List all the available serial ports
  println(Serial.list());
  
  // change the number below to match your port
  String portName = Serial.list()[0];
  
  // create a serial object
  myPort = new Serial(this, portName, 9600);
  
  // empty the serial buffer
  myPort.clear();
  
  // don't generate a serialEvent() until you get a newline character
  myPort.bufferUntil('\n');
}

void draw() {
  float pointillize = map(mouseX, 0, width, smallPoint, largePoint);
  
  int x = int(random(img.width));
  int y = int(random(img.height));
  
  color pix = img.get(x, y);
  
  fill(pix, 128);
  ellipse(x, y, pointillize, pointillize);
}

void serialEvent(Serial s) {
  // get the string
  String inBuffer = s.readStringUntil('\n');
  
  if (inBuffer != null) {
    inBuffer = trim(inBuffer); // remove any possible white space characters
    val = int(inBuffer); // get the latest string char & convert it to an int
    println(val); // print it
  }
}
