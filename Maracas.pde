// import

import oscP5.*; // .* = all the functions of the library
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() { // called just one time
  size(640, 360);
  noStroke();
  rectMode(CENTER);
  
  frameRate(125); // How many time draw is called
  oscP5 = new OscP5(this, 12000); // incoming port
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
}

int isPressed = 0;

void draw() { // called in loop forever
  background(51);
  fill(255, 204);
  
  // create rectangle 1
  rect(mouseX, mouseY, height/4+10, height/4+10);
  
  // create an osc message based on the mouse position and send it
  OscMessage myMessage = new OscMessage("/mar"); // name (important) will be the same in SC
  myMessage.add(mouseX / (float)width);    // Number of grains
  myMessage.add(mouseY / (float)height);   // (-1)*Reverb
  // trigger
  if (mousePressed == true && isPressed == 0) {
    myMessage.add("1");
    isPressed = 1;
  }
  else {
    if (mousePressed == false && isPressed == 1) {
      myMessage.add("1");
      isPressed = 0;
    }
    else {
      myMessage.add("0");
    }
  }
  // Down/Up
  if (isPressed == 1) {
    myMessage.add("1");
  }
  else {
    myMessage.add("0");
  }
  oscP5.send(myMessage, myRemoteLocation);
  
  myMessage.print(); // only for the console
}
