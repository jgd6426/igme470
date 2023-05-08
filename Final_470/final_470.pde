/* Judy Derrick
 * IGME.470 Final Project
 *
 * Built and modified from Carlos Castellanos SensorGraphASCII and Sensor Analysis & Filtering,
 * and Daniel Shiffman Pointillism
 */

import processing.serial.*;

Serial myPort; // Serial object

float sensorVal;
String inBuffer;

//String portName;
float prevEstimate = 0;      // previous result

// Images array and randomly chosen image
PImage[] images = new PImage[6];
PImage img;

int randomNumber;


void setup() {
  size(600, 900); // window size
  
  // set the range of the dots
  //smallPoint = 1.0;
  //largePoint = 200.0;
  
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
  
  // create a serial object
  //String portName = Serial.list()[1];
  String portName = "COM3";
  myPort = new Serial(this, portName, 9600);
  
  // empty the serial buffer
  myPort.clear();
  
  // don't generate a serialEvent() until you get a newline character
  myPort.bufferUntil('\n');
}

void draw() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readStringUntil('\n');
  
    if (inBuffer != null) {
      inBuffer = trim(inBuffer); // remove any possible white space characters
      sensorVal = float(inBuffer); // get the latest string char & convert it to an int
      //println(sensorVal); // print it
    }
    
    // convert to voltage: (not required, can just use val as the raw value)
    float voltage = 3.3 * sensorVal / 1023.0;
    
    // read the trim pot:
    float weightVal = 0.5;
     
    // filter the sensor's result:
    float currEstimate = filter(voltage, weightVal, prevEstimate);
    
    // save the current result for future use:
    prevEstimate = currEstimate;
    //println(prevEstimate * 1000);
      
    //float pointillize = map(mouseX, 0, width, smallPoint, largePoint);
    //float pointillize = map(currEstimate *  1000, 0, 100, smallPoint, largePoint);
    float val = currEstimate * 10000;
    println(val);
    
    float pointillize;
    
    if (val < 25.0) {
      pointillize = 100;
    }
    else if (val >= 25.0 && val < 40.0) {
      pointillize = 10;
    }
    else {
      pointillize = 100;
    }
    
    
    int x = int(random(img.width));
    int y = int(random(img.height));
    
    color pix = img.get(x, y);
    
    fill(pix, 128);
    ellipse(x, y, pointillize, pointillize); 
  }
}

// filter the current result using a weighted average filter:
float filter(float rawValue, float weight, float prevValue) {
  // run the filter:
  float result = weight * rawValue + (1.0 - weight) * prevValue;
  // return the result:
  return result;
}
