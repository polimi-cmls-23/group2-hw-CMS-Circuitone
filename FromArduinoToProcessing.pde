import processing.serial.*;
import oscP5.*; // .* = all the functions of the library
import netP5.*;

Serial myPort;
OscP5 oscP5;
NetAddress myRemoteLocation;

int currentPot = 0;

void setup() {
  size(640, 360);
  noStroke();
  rectMode(CENTER);
  
  myPort = new Serial(this, "COM13", 9600);
  frameRate(125); // How many time draw is called
  oscP5 = new OscP5(this, 12000); // incoming port
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
}

void draw() {

  int val = 1;
  OscMessage myMessage = new OscMessage("/mar");
  
  if(myPort.available() > 0) {
    val = myPort.read();
    if(val == 1) {
      myMessage.add(mouseX / (float)width);    // Number of grains
      myMessage.add(mouseY / (float)height);   // (-1)*Reverb  
      myMessage.add("1"); // make the sound
      myMessage.add("1"); // maraca position (high or low) (2 possible sounds)
      myMessage.add(currentPot); // pot value
      background(200);
    }  
    else {
      if(val == 0) {
        myMessage.add(mouseX / (float)width);    // Number of grains
        myMessage.add(mouseY / (float)height);   // (-1)*Reverb  
        myMessage.add("1");
        myMessage.add("0");
        myMessage.add(currentPot); // pot value
        background(51);
      }
      else {
        currentPot = val;
      }
  }
  if(myMessage.checkTypetag("ffssi")){
    oscP5.send(myMessage, myRemoteLocation);
    myMessage.print(); // only for the console
  }
  }
}
