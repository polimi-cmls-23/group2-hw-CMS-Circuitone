import processing.serial.*;
import oscP5.*; // .* = all the functions of the library
import netP5.*;
import controlP5.*;

ControlP5 cP5;
Serial myPort;
OscP5 oscP5;
NetAddress myRemoteLocation;

int fixed = 0;
int xVal = 0;
int yVal = 0;
int currentPot = 0;
int val = 1;
int isLow = 0;
PImage img;
PImage img_rotated;
PImage img_background;
PImage img_sand;
float altezza = -50;
float knobValue; 
float panPos = 0;
float xDist = 0;
float yDist = 0;
int x1Space = 320;
int x2Space = 1100;
int y1Space = 315;
int y2Space = 900;

Knob grainKnob;
Knob volumeKnob;

void setup() {
  size (1400,900);
  // noStroke();
  // rectMode(CENTER);
  
  img = loadImage("C:/Users/Gabriele/Documents/MEGA/Magistrale/Music and Acoustic Engineering/CMLS/HW3/FromArduinoToProcessing/Images/Maracas.png");
  img_rotated = loadImage("C:/Users/Gabriele/Documents/MEGA/Magistrale/Music and Acoustic Engineering/CMLS/HW3/FromArduinoToProcessing/Images/Maracas_rotated.png");
  img_sand = loadImage("C:/Users/Gabriele/Documents/MEGA/Magistrale/Music and Acoustic Engineering/CMLS/HW3/FromArduinoToProcessing/Images/Sand.png");
  img_background = loadImage("C:/Users/Gabriele/Documents/MEGA/Magistrale/Music and Acoustic Engineering/CMLS/HW3/FromArduinoToProcessing/Images/MaracaSpace_buco.png");
  cP5 = new ControlP5(this);
  grainKnob = cP5.addKnob("Number of grains", 3000, 10000, 10000, 1167, 500, 130);
  grainKnob.setColorForeground(color(11, 79, 108))
            .setColorBackground(color(253,192,69))
            .setColorActive(color(11, 79, 108))
            .setColorValueLabel(color(253,192,69))
            .setLabelVisible(false);
  volumeKnob = cP5.addKnob("Master Volume", 0, 1, 1, 1167, 720, 130);
  volumeKnob.setColorForeground(color(11, 79, 108))
            .setColorBackground(color(253,192,69))
            .setColorActive(color(11, 79, 108))
            .setColorValueLabel(color(11, 79, 108))
            .setLabelVisible(false);
  
  myPort = new Serial(this, "COM13", 9600);
  frameRate(125); // How many time draw is called
  oscP5 = new OscP5(this, 12000); // incoming port
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
}

void draw() {
  
  background(80,24,13);
  img.resize (150, 150);
  img_rotated.resize (150, 150);
  img_sand.resize (400, 400);
  image(img_sand, 1100, int(altezza)); // range y da 20 a -50
  image(img_background, 0, 0);
  
  if(mouseX > x1Space && mouseX < x2Space && mouseY > y1Space) {   
    if(isLow == 1) {
      if(fixed == 0){  
        noCursor(); 
        image(img_rotated, mouseX - 68, mouseY - 55);
      }
      else{
        cursor(ARROW);
        image(img_rotated, xVal - 68, yVal - 55);
      }
    }
    else {
        if(fixed == 0){  
          noCursor(); 
          image(img, mouseX - 68, mouseY - 55);
        }
        else{
          cursor(ARROW);
          image(img, xVal - 68, yVal - 55);
        }
    }
  }
  else {
    cursor(ARROW);
    if(isLow == 1 && fixed == 1) {
      image(img_rotated, xVal - 68, yVal - 55);
    }
    if(isLow == 0 && fixed == 1) {
      image(img, xVal - 68, yVal - 55);
    }
  }
  
  noFill();
  rect(100, 400, 100, 400, 20);
  fill(253,192,69);
  float slider = map(currentPot, 2, 255, -400, -30);
  rect(100, 800, 100, slider, 20);
  
  text("NUMBER OF\nGRAINS", 1232, 655);
  textSize(17);
  textAlign(CENTER);
  text("MASTER VOLUME", 1232, 880);
  textSize(17);
  textAlign(CENTER);
  text("EMPHASIS", 150, 850);
  textSize(17);
  textAlign(CENTER);
  
  if(fixed == 0){
    panPos = ((float)mouseX - (float)x1Space) / ((float)x2Space - (float)x1Space);
    xDist = (mouseX - ((x1Space + x2Space) / 2));
    if(mouseX > x2Space){
      xDist = x2Space - ((x1Space + x2Space) / 2);
    }
    if(mouseX < x1Space){
      xDist = x1Space - ((x1Space + x2Space) / 2);
    }
    yDist = (y2Space - mouseY);
    if(mouseY < y1Space){
      yDist = (y2Space - y1Space);
    }
  }
  else{
    panPos = ((float)xVal - (float)x1Space) / ((float)x2Space - (float)x1Space);
    xDist = (xVal - ((x1Space + x2Space) / 2));
    if(xVal > x2Space){
      xDist = x2Space - ((x1Space + x2Space) / 2);
    }
    if(xVal < x1Space){
      xDist = x1Space - ((x1Space + x2Space) / 2);
    }
    yDist = (y2Space - yVal);
    if(yVal < y1Space){
      yDist = (y2Space - y1Space);
    }
  }
  
  if(panPos > 1){
    panPos = 1;
  }
  if(panPos < 0){
    panPos = 0;
  }
  
  OscMessage myMessage = new OscMessage("/mar");
  
  if(myPort.available() > 0) {
      val = myPort.read();
      if(val == 1) {
        myMessage.add(panPos);    // pan
        myMessage.add(grainKnob.getValue()); // number of grains
        myMessage.add((sqrt(pow(xDist,2) + pow(yDist,2))) / (sqrt((pow((y2Space-y1Space),2)) + (pow(((x2Space-x1Space)/2),2)))));   // (-1)*Reverb  
        myMessage.add("1"); // make the sound
        myMessage.add("1"); // maraca position (high or low) (2 possible sounds)
        myMessage.add(currentPot); // pot value --> softness
        myMessage.add(volumeKnob.getValue()); // gain
        isLow = 0;
      }  
      else {
        if(val == 0) {
          myMessage.add(panPos);    // pan
          myMessage.add(grainKnob.getValue()); // number of grains
          myMessage.add((sqrt(pow(xDist,2) + pow(yDist,2))) / (sqrt((pow((y2Space-y1Space),2)) + (pow(((x2Space-x1Space)/2),2)))));   // (-1)*Reverb  
          myMessage.add("1");
          myMessage.add("0");
          myMessage.add(currentPot); // pot value --> softness
          myMessage.add(volumeKnob.getValue()); // gain
          isLow = 1;
        }
        else {
          currentPot = val;
        }
    }
    if(myMessage.checkTypetag("fffssif")){
      oscP5.send(myMessage, myRemoteLocation);
      myMessage.print(); // only for the console
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    if(theEvent.getController().getName()=="Number of grains") {
         altezza = map(theEvent.getController().getValue(), 3000, 10000, 50, -50);
    }
  } 
}

void mouseClicked() {
  if(mouseX > x1Space && mouseX < x2Space && mouseY > y1Space){
    if (fixed == 0) {
      xVal = mouseX;
      yVal = mouseY;
      fixed = 1;
    } else {
      fixed = 0;
    }
  }
}
